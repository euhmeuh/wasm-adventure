#lang racket

(require racket/syntax)

(provide (except-out (all-from-out racket)
                     #%module-begin
                     + - / *)
         (rename-out (module-begin #%module-begin))
         import
         export
         func
         call
         data
         mem
         memstring
         data-section
         for
         (rename-out (add +))
         (rename-out (sub -))
         (rename-out (mul *))
         (rename-out (div /))
         (rename-out (rem %))
         let-local
         set-local
         load
         store)

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

(define (cut l n)
   (if (not (empty? l))
       (cons (take l n) (cut (drop l n) n))
       '()))

;; transform a list of values into a string representing bytes
;; entries - a list or tree of values (symbols are discarded)
;; size - size (in bytes) of every entry
;;
;; Examples:
;; (memstring 1 '(1 2 3))
;; "\01\02\03"
;;
;; (memstring 4 '(#xDEADBEEF #x11223344 255)
;; "\DE\AD\BE\EF\11\22\33\44\00\00\00\FF"
;;
;; (memstring 2 '((apple 1) (orange 2) (lemon 3)))
;; "\00\01\00\02\00\03"
(define (memstring size . entries)
  (define (parse x)
    (list->string
      (flatten
        (cons #\\ (add-between
          (cut
            (string->list
              (~r x #:min-width (* size 2)
                    #:pad-string "0"
                    #:base 16))
            2) #\\)))))

  (string-append* (map parse (flatten entries))))

(define (data-section)
  (define (eval-value v)
    (if (number? v)
        (str (memstring 1 v))
        (str v)))

  (map (lambda (entry)
         (let ((offset (second entry))
               (value (third entry)))
           `(data (i32.const ,offset) ,(eval-value value))))
       memory))

(define (add x y)
  `(i32.add ,(var x) ,(var y)))

(define (sub x y)
  `(i32.sub ,(var x) ,(var y)))

(define (mul x y)
  `(i32.mul ,(var x) ,(var y)))

(define (div x y)
  `(i32.div_u ,(var x) ,(var y)))

(define (rem x y)
  `(i32.rem_u ,(var x) ,(var y)))

(define (for counter limit step . body)
  `(loop $loop
     (block $done
       (br_if $done (i32.ge_u ,(var counter) ,(var limit)))
       ,@body
       (set_local ,($ counter)
         ,(add counter step))
       (br $loop))))

(define-syntax-rule (let-local (v ...) body ...)
  (let ((v 'v)...)
    `((local ,($ v) i32) ...
      ,body ...)))

(define (set-local x y)
  `(set_local ,($ x) ,y))

(define (load index)
  `(i32.load ,(var index)))

(define (store index value)
  `(i32.store ,(var index) ,(var value)))
