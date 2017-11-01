#lang racket

(require
  "utils.rkt"
  "memory.rkt"
  "constants.rkt")

(provide (except-out (all-from-out racket)
                     #%module-begin
                     + - / *)
         (rename-out (module-begin #%module-begin))
         import
         export
         func
         call
         constants
         const
         data
         mem
         data-section
         for
         (rename-out (add +))
         (rename-out (sub -))
         (rename-out (mul *))
         (rename-out (div /))
         (rename-out (rem %))
         set-local
         load
         load-byte
         store
         store-byte)

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    (display `(module ,expr ... ,@(data-section)))))

(define-syntax-rule (import path ... (name arg ...))
  (import-impl '(path ...) 'name '(arg ...)))

(define (import-impl paths name args)
  `(import ,@(map str paths) ,(func-signature name args)))

(define-syntax-rule (export name object)
  (export-impl 'name 'object))

(define (export-impl name object)
  `(export ,(str name) ,object))

(define-syntax func
  (syntax-rules (locals)
    ((_ name (arg ...) (locals loc ...) body ...)
     (let ((arg 'arg) ... (loc 'loc) ...)
       (func-impl 'name '(arg ...) '(loc ...) body ...)))

    ((_ name (arg ...) body ...)
     (let ((arg 'arg) ...)
       (func-impl 'name '(arg ...) '() body ...)))))

(define (func-impl name args locals . body)
  (define (eval-arg arg)
    `(param ,($ arg) i32))
  (define (eval-loc loc)
    `(local ,($ loc) i32))
  `(func ,($ name)
         ,@(map eval-arg args)
         ,@(map eval-loc locals)
         ,@body))

(define (func-signature name args)
  (define (eval-arg arg) `(param i32))
  `(func ,($ name)
         ,@(map eval-arg args)))

(define (call name . args)
  `(call ,($ name) ,@(map var args)))

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

(define (set-local x y)
  `(set_local ,($ x) ,y))

(define (load index)
  `(i32.load ,(var index)))

(define (load-byte index)
  `(i32.load8_u ,(var index)))

(define (store index value)
  `(i32.store ,(var index) ,(var value)))

(define (store-byte index value)
  `(i32.store8 ,(var index) ,(var value)))
