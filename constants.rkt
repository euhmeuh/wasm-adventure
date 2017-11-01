#lang racket

(require "utils.rkt")

(provide constants const)

(define *constants* (make-hash))

(define (constants . entries)
  (for-each
    (lambda (e)
      (hash-set! *constants* (car e) (cadr e)))
    (cut entries 2))
  "")

(define (const x)
  (var (hash-ref *constants* x)))
