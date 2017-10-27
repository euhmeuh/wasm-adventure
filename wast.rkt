#lang racket

(require
  racket/syntax)

(provide (except-out (all-from-out racket)
                     #%module-begin)
         (rename-out (module-begin #%module-begin))
         import
         export
         func
         call
         data
         mem
         data-section
         for
         +
         -)

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    (display `(module ,expr ... ,@(data-section)))))

(define (str value)
  (format "\"~a\"" value))

(define ($ name)
  (format-symbol "$~a" name))

(define (var x)
  (cond
    ((symbol? x) `(get_local ,($ x)))
    ((number? x) `(i32.const ,x))
    (else x)))

(define-syntax-rule (import path ... (name arg ...))
  (import-impl '(path ...) 'name '(arg ...)))

(define (import-impl paths name args)
  `(import ,@(map str paths) ,(func-signature name args)))

(define-syntax-rule (export name object)
  (export-impl 'name 'object))

(define (export-impl name object)
  `(export ,(str name) ,object))

(define-syntax-rule (func name (arg ...) body ...)
  (let ((arg 'arg) ...)
    (func-impl 'name '(arg ...) body ...)))

(define (func-impl name args . body)
  (define (eval-arg arg)
    `(param ,($ arg) i32))
  `(func ,($ name)
         ,@(map eval-arg args)
         ,@body))

(define (func-signature name args)
  (define (eval-arg arg) `(param i32))
  `(func ,($ name)
         ,@(map eval-arg args)))

(define (call name . args)
  `(call ,($ name) ,@(map var args)))

(define memory '())

(define (data . entries)
  (set! memory entries)
  "")

(define (mem index)
  `(i32.const ,(second (assq index memory))))

(define (flatten data)
  (cond
    ((or (null? data) (symbol? data)) '())
    ((pair? data) (append (flatten (car data)) (flatten (cdr data))))
    (else (list data))))

(define (list->memstring list)
  (string-append* (map (lambda (x)
                         (string-append "\\"
                           (~r x #:min-width 6
                                 #:pad-string "0"
                                 #:base 16)))
                       list)))

(define (data-section)
  (define (eval-value v)
    (if (string? v)
      (str v)
      (str (list->memstring (flatten v)))))

  (map (lambda (entry)
         (let ((offset (second entry))
               (value (third entry)))
           `(data (i32.const ,offset) ,(eval-value value))))
       memory))

(define (+ x y)
  `(i32.add ,(var x) ,(var y)))

(define (- x y)
  `(i32.sub ,(var x) ,(var y)))

(define (for counter limit step . body)
  `(loop $loop
     (block $done
       (br_if $done (i32.ge_u ,(var counter) ,(var limit)))
       ,@body
       (set_local ,($ counter)
         ,(+ counter step))
       (br $loop))))
