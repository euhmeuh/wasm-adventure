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
     `(import ,(format "~s" path) ... ,(func name (arg ...))))))

(define-syntax export
  (syntax-rules ()
    ((_ name object)
     `(export ,(format "~s" name) object))))

(define-syntax func
  (syntax-rules ()
    ((_ name (arg ...) body ...)
     `(func ,(format-symbol "$~a" 'name)
            (param ,(format-symbol "$~a" 'arg) i32) ... ,body ...))))

(define-syntax-rule (call name arg ...)
  `(call ,(format-symbol "$~a" 'name) ,(eval-arg arg) ...))

(define-syntax data
  (syntax-rules () ((_ args ...) '(data args ...))))

(define (mem index)
  0)

(define-syntax for
  (syntax-rules () ((_ args ...) '(for args ...))))

;; check whether an argument of a call is a single symbol or an method application
(define-syntax eval-arg
  (syntax-rules ()
    ((_ (rator rand ...)) (rator rand ...))
    ((_ arg)
     `(get_local ,(format-symbol "$~a" 'arg)))))
