#lang racket

(require racket/syntax)

(provide flatten cut str $ var *noop*)

;; return this value from a procedure in order not to generate any output code
(define *noop* "")

(define (flatten data)
  (cond
    ((or (null? data) (symbol? data)) '())
    ((pair? data) (append (flatten (car data)) (flatten (cdr data))))
    (else (list data))))

(define (cut l n)
   (if (not (empty? l))
       (cons (take l n) (cut (drop l n) n))
       '()))

(define (str value)
  (format "\"~a\"" value))

(define ($ name)
  (format-symbol "$~a" name))

(define (var x)
  (cond
    ((symbol? x) `(get_local ,($ x)))
    ((number? x) `(i32.const ,x))
    (else x)))
