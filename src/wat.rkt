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
         return
         constants
         const
         data
         mem
         data-section
         for
         break
         continue
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
         not
         and
         or
         xor
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
  (syntax-rules (=> locals)
    ((_ name (arg ...) => (locals loc ...) body ...)
     (let ((arg 'arg) ... (loc 'loc) ...)
       (func-impl #t 'name '(arg ...) '(loc ...) body ...)))

    ((_ name (arg ...) (locals loc ...) body ...)
     (let ((arg 'arg) ... (loc 'loc) ...)
       (func-impl #f 'name '(arg ...) '(loc ...) body ...)))

    ((_ name (arg ...) => body ...)
     (let ((arg 'arg) ...)
       (func-impl #t 'name '(arg ...) '() body ...)))

    ((_ name (arg ...) body ...)
     (let ((arg 'arg) ...)
       (func-impl #f 'name '(arg ...) '() body ...)))))

(define (func-impl return name args locals . body)
  (define (eval-arg arg)
    `(param ,($ arg) i32))
  (define (eval-loc loc)
    `(local ,($ loc) i32))
  `(func ,($ name)
         ,@(map eval-arg args)
         ,(result return)
         ,@(map eval-loc locals)
         ,@(map var body)))

(define (func-signature name args)
  (define (eval-arg arg) `(param i32))
  `(func ,($ name)
         ,@(map eval-arg args)))

(define (call name . args)
  `(call ,($ name) ,@(map var args)))

(define (return x)
  `(return ,(var x)))

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

(define (break)
  '(br $done))

(define (continue)
  `(br $loop))

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

(define (and x y)
  `(i32.and ,(var x) ,(var y)))

(define (or x y)
  `(i32.or ,(var x) ,(var y)))

(define (xor x y)
  `(i32.xor ,(var x) ,(var y)))

(define (not x)
  (eq x 0))

(define-syntax if%
  (syntax-rules (=> then else)
    ((_ condition => (then body ...) (else other-body ...))
     (if-impl #t condition `(,body ...) `(,other-body ...)))

    ((_ condition (then body ...) (else other-body ...))
     (if-impl #f condition `(,body ...) `(,other-body ...)))

    ((_ condition => body ...)
     (if-impl #t condition `(,body ...) '()))

    ((_ condition body ...)
     (if-impl #f condition `(,body ...) '()))))

(define (if-impl return condition bodies elses)
  (if (pair? elses)
    `(if ,(result return) ,(var condition) (then ,@bodies) (else ,@elses))
    `(if ,(result return) ,(var condition) (then ,@bodies))))

(define (set-local x y)
  `(set_local ,($ x) ,(var y)))

(define (load index)
  `(i32.load ,(var index)))

(define (load-byte index)
  `(i32.load8_u ,(var index)))

(define (store index value)
  `(i32.store ,(var index) ,(var value)))

(define (store-byte index value)
  `(i32.store8 ,(var index) ,(var value)))
