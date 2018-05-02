#lang racket

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
         while
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
         (rename-out (wasm-if if))
         not
         and
         or
         xor
         set-local
         load
         load-byte
         store
         store-byte)

(require
  (for-syntax
    racket/base
    racket/syntax
    syntax/stx
    syntax/parse)
  "utils.rkt"
  "memory.rkt"
  "constants.rkt")

(begin-for-syntax
  (define-splicing-syntax-class maybe-returns
    #:datum-literals (=>)
    (pattern (~seq =>)
             #:with returns? #'#t)
    (pattern (~seq)
             #:with returns? #'#f))

  (define-splicing-syntax-class maybe-locals
    #:datum-literals (locals)
    (pattern (~seq (locals loc:id ...))
             #:with locs #'(loc ...))
    (pattern (~seq)
             #:with locs #'())))

(define import-section '())
(define function-section '())
(define export-section '())

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    expr ...
    (display `(module ,@import-section
                      (memory 1)
                      ,@function-section
                      ,@export-section
                      ,@(data-section)))))

(define callables '())

(define (add-callable func-name)
  (set! callables (cons func-name callables)))

(define-syntax (import stx)
  (syntax-parse stx
    [(_ path ... (name arg ...) mr:maybe-returns)
     #'(add-import '(path ...) 'name '(arg ...) #:returns? mr.returns?)]))

(define (add-import paths name args #:returns? [returns? #f])
  (set! import-section
        (cons `(import ,@(map str paths)
                       ,(func-signature name args #:returns? returns?))
              import-section))
  (add-callable name))

(define (func-signature name args #:returns? [returns? #f])
  (define (eval-arg arg) `(param i32))
  `(func ,($ name)
         ,@(map eval-arg args)
         ,@(result-or-none returns?)))

(define-syntax export
  (syntax-rules (memory func)
    [(_ name-out (memory num))
     (add-memory-export 'name-out num)]
    [(_ name-out (func name))
     (add-function-export 'name-out 'name)]))

(define (add-memory-export name-out num)
  (set! export-section
        (cons `(export ,(str name-out) (memory ,num))
              export-section)))

(define (add-function-export name-out name)
  (set! export-section
        (cons `(export ,(str name-out) (func ,($ name)))
              export-section)))

(define-syntax (func stx)
  (syntax-parse stx
    [(_ name (arg ...) mr:maybe-returns ml:maybe-locals body ...)
     #`(let ([arg 'arg] ... ;; every arg in the body of the function is bound to its symbol
             #,@(stx-map (lambda (a) #`(#,a '#,a))
                         #'ml.locs))
         (add-function 'name '(arg ...) 'ml.locs #:returns? mr.returns? body ...))]))

(define (add-function name args locals #:returns? [returns? #f] . body)
  (set! function-section
        (cons `(func ,($ name)
                 ,@(map param args)
                 ,@(result-or-none returns?)
                 ,@(map local locals)
                 ,@(map var body))
              function-section))
  (add-callable name))

(define (param symbol)
  `(param ,($ symbol) i32))

(define (local symbol)
  `(local ,($ symbol) i32))

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

(define (while condition . body)
  `(loop $loop
     (block $done
       (br_if $done ,(not condition))
       ,@body
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

(define-syntax (wasm-if stx)
  (syntax-parse stx
    #:datum-literals (then else)
    [(_ condition mr:maybe-returns (then body ...) (else other-body ...))
     #'(if-impl mr.returns? condition (list body ...) (list other-body ...))]
    [(_ condition mr:maybe-returns body ...)
     #'(if-impl mr.returns? condition (list body ...) '())]))

(define (if-impl returns? condition bodies elses)
  (if (pair? elses)
    `(if ,@(result-or-none returns?)
         ,(var condition) (then ,@bodies) (else ,@elses))
    `(if ,@(result-or-none returns?)
         ,(var condition) (then ,@bodies))))

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
