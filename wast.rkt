#lang racket

(require racket/syntax
  (for-syntax racket)
  (for-syntax racket/syntax))

(provide (except-out (all-from-out racket)
                     #%module-begin)
         (rename-out (module-begin #%module-begin))
         import export
         func call
         data mem
         for)

(define ($ name)
  (format-symbol "$~a" name))

(define-for-syntax ($ name)
  (format-symbol "$~a" name))

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

(define-syntax-rule (func name (arg ...) body ...)
  `(func ,($ 'name)
           (param ,($ 'arg) i32) ... ,body ...))

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
  (set! memory entries))

(define (mem index)
  15)
  ;;(second (assq index memory)))

(define-syntax for
  (syntax-rules () ((_ args ...) `(for ,args ...))))