#lang racket

(require racket/syntax)

(provide (except-out (all-from-out racket)
                     #%module-begin)
         (rename-out (module-begin #%module-begin))
         import export
         func call
         data mem
         for)

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
   (display `(module ,expr ...))))

(define-syntax import
  (syntax-rules ()
    ((_ path ... (name arg ...))
     `(import ,(format "~s" path) ...
              (func ,(format-symbol "$~a" 'name)
                    (param ,(format-symbol "$~a" 'arg) i32) ...)))))

(define-syntax export
  (syntax-rules () ((_ args ...) '(export args ...))))

(define-syntax func
  (syntax-rules () ((_ args ...) '(func args ...))))

(define-syntax call
  (syntax-rules () ((_ args ...) '(call args ...))))

(define-syntax data
  (syntax-rules () ((_ args ...) '(data args ...))))

(define (mem index)
  0)

(define-syntax for
  (syntax-rules () ((_ args ...) '(for args ...))))
