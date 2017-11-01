#lang racket

(require racket/syntax)

(provide flatten remove-symbols cut str $ var *noop*)

;; return this value from a procedure in order not to generate any output code
(define *noop* "")

(define (flatten l)
  (cond
    ((null? l) '())
    ((pair? l) (append (flatten (car l)) (flatten (cdr l))))
    (else (list l))))

(define (remove-symbols l)
  (filter (negate symbol?) l))

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
