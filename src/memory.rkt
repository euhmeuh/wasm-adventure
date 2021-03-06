#lang racket

(provide data mem data-section)

(require
  racket/list
  "utils.rkt")

(define *memory* '())
(define *offsets* (make-hash))

(struct entry (name offset value))

(define (memstring? obj)
  (and (pair? obj) (eq? (car obj) 'memstring)))

(define (memstring-elements memstr) (cddr memstr))
(define (memstring-size memstr) (cadr memstr))

;; save the offset of every symbol encoutered in the memstring
;; in a hash-table and return it
;;
;; the offset is relative to base-offset
(define (find-offsets memstr base-offset)
  (let ([offsets (make-hash)]
        [i 0])
    (for-each
      (lambda (value)
        (if (symbol? value)
          (hash-set! offsets value (+ base-offset i))
          (set! i (+ i (memstring-size memstr)))))
      (memstring-elements memstr))
    offsets))

(define (data . entries)
  (set! *memory* entries)
  (for-each
    (lambda (e)
      (let* ([the-entry (apply entry e)]
             [name (entry-name the-entry)]
             [offset (entry-offset the-entry)]
             [value (entry-value the-entry)])
        (if (memstring? value)
            (hash-set! *offsets* name (find-offsets value offset))
            (hash-set! *offsets* name offset))))
    entries))

(define (mem index . subindex)
  (if (and (pair? subindex) (symbol? (car subindex)))
    `(i32.const ,(hash-ref (hash-ref *offsets* index) (car subindex)))
    `(i32.const ,(hash-ref *offsets* index))))

;; transform a list of values into a string representing bytes
;;
;; Examples:
;; (format-memstring '(memstring 1 1 2 3))
;; "\01\02\03"
;;
;; (format-memstring '(memstring 4 #xDEADBEEF #x11223344 255))
;; "\DE\AD\BE\EF\11\22\33\44\00\00\00\FF"
;;
;; (format-memstring '(memstring 2 apple 1 orange 2 lemon 3))
;; "\00\01\00\02\00\03"
(define (format-memstring memstr)
  (define (hexa x)
    (~r x #:min-width (* (memstring-size memstr) 2)
          #:pad-string "0"
          #:base 16))

  (define (remove-symbols l)
    (filter (negate symbol?) l))

  (define (parse x)
    (if (string? x)
        x
        (list->string (flatten
                        (cons #\\ (add-between
                                    (pack (string->list (hexa x)) 2)
                                    #\\))))))

  (string-append* (map parse
                       (remove-symbols (memstring-elements memstr)))))

(define (data-section)
  (define (eval-value v)
    (cond
      [(number? v) (str (format-memstring `(memstring 1 ,v)))]
      [(memstring? v) (str (format-memstring v))]
      [(string? v) (str v)]
      [else (error 'wrong-data-value v)]))

  (map (lambda (e)
         (define the-entry (apply entry e))
         `(data (i32.const ,(entry-offset the-entry))
                ,(eval-value (entry-value the-entry))))
       *memory*))
