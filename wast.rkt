#lang racket

(require
  (for-syntax racket)
  (for-syntax racket/syntax))

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
         for)

(define (str v) (format "\"~a\"" v))

(define-for-syntax ($ name)
  (format-symbol "$~a" name))

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    (display `(module ,expr ... ,@(data-section)))))

(define-syntax-rule (import path ... (name arg ...))
  `(import ,(str path) ... ,(func name (arg ...))))

(define-syntax-rule (export name object)
  `(export ,(str name) object))

(define-syntax (func stx)
  (define (eval-args args)
    (map (lambda (a) `'(param ,($ a) i32))
         (syntax->list args)))

  (syntax-case stx ()
    ((_ name (arg ...) body ...)
     #``(func #,($ #'name)
              ,@(list #,@(eval-args #'(arg ...)))
              ,body ...))))

(define-syntax (call stx)
  (define (eval-args args)
    (map (lambda (a)
           (if (identifier? a)
             `'(get_local ,($ a)) ;; quote
             a)) ;; don't quote
         (syntax->list args)))

  (syntax-case stx ()
    ((_ name . args)
     #``(call #,($ #'name) ,@(list #,@(eval-args #'args))))))

(define memory '())

(define (data . entries)
  (set! memory entries)
  "")

(define (mem index)
  (second (assq index memory)))

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

(define-syntax for
  (syntax-rules () ((_ args ...) `(for ,args ...))))
