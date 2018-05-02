#lang racket

(require racket/syntax)

(provide pack $ str var result-or-none)

(define (pack a-list pack-size)
  (if (pair? a-list)
      (cons (take a-list pack-size)
            (pack (drop a-list pack-size) pack-size))
      '()))

(define ($ name)
  (format-symbol "$~a" name))

(define (str string)
  (format "\"~a\"" string))

(define (var x)
  (cond
    ((symbol? x) `(get_local ,($ x)))
    ((number? x) `(i32.const ,x))
    (else x)))

(define (result-or-none returns?)
    (if returns? '((result i32)) '()))
