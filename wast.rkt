#lang racket

(require
  "utils.rkt"
  "memory.rkt"
  "constants.rkt")

(provide (except-out (all-from-out racket)
                     #%module-begin
                     + - / * = < <= > >= if)
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
         (rename-out (eq =))
         (rename-out (ne !=))
         (rename-out (lt <))
         (rename-out (le <=))
         (rename-out (gt >))
         (rename-out (ge >=))
         (rename-out (if% if))
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

(define (eq x y)
  `(i32.eq ,(var x) ,(var y)))

(define (ne x y)
  `(i32.ne ,(var x) ,(var y)))

(define (lt x y)
  `(i32.lt_u ,(var x) ,(var y)))

(define (le x y)
  `(i32.le_u ,(var x) ,(var y)))

(define (gt x y)
  `(i32.gt_u ,(var x) ,(var y)))

(define (ge x y)
  `(i32.ge_u ,(var x) ,(var y)))

(define-syntax if%
  (syntax-rules (then else)
    ((_ condition (then body ...) (else other-body ...))
     (if-impl condition `(,body ...) `(,other-body ...)))

    ((_ condition body ...)
     (if-impl condition `(,body ...) '()))))

(define (if-impl condition bodies elses)
  (if (pair? elses)
    `(if ,condition (then ,@bodies) (else ,@elses))
    `(if ,condition (then ,@bodies))))

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
