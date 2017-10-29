#lang s-exp "wast.rkt"

(import "console" "log" (log pos len))

'(memory 1)

(data
  '(width 0 0)
  '(height 4 0)
  `(palette 8 ,(memstring 3
    '(black #x000000)
    '(white #xFFFFFF)
    '(red #xFF0000)
    '(green #x00FF00)
    '(blue #x0000FF)
    '(maroon #x000000)
    '(beige #x000000)
    '(orange #x000000)
    '(cyan #x000000)
    '(purple #x000000)
    '(pink #x000000)
    '(yellow #x000000)
    '(grey #x000000)
    '(dark-grey #x000000)
    '(dark-green #x000000)
    '(dark-red #x000000)))
  '(messages 256 "Hello world!")
  '(screen 1024 0))

(func fill_pixels (pos len step color)
  (for pos (- len 1) step
    (call 'pixel pos color)))

(func fill_row (row color)
  ;;; fill a full row of the screen with the given color
  (locals i len)
  (set-local i (* (load (mem 'width)) row))
  (set-local len (+ (load (mem 'width)) i))
  (call 'fill_pixels i len 1 color))

(func fill_col (col color)
  ;;; fill a full column of the screen with the given color
  (locals len)
  (set-local len (* (load (mem 'width)) (load (mem 'height))))
  (call 'fill_pixels col len (load (mem 'width)) color))

(func fill_screen (color)
  ;;; fill the whole screen with a color
  (call 'fill_pixels 0 (* (load (mem 'width)) (load (mem 'height))) 1 color))

(func pixel (pos color)
  ;;; draw a pixel at the given position in memory with the given color
  (locals cursor ;; write position in memory
          comp) ;; color component to write
  (set-local cursor (+ (mem 'screen) (* pos 4))) ;; 4 is pixel size
  (set-local comp (+ (mem 'palette) (* color 3))) ;; 3 is palette color size
  ;; red component
  (store cursor (load comp))
  ;; green component
  (store (+ cursor 1) (load (+ comp 1)))
  ;; blue component
  (store (+ cursor 2) (load (+ comp 2)))
  ;; alpha
  (store (+ cursor 3) #xFF))

(func plot (x y color)
  ;;; draw a pixel at the given coordinates
  (call 'pixel (+ x (* y (load (mem 'height)))) color))

(func init (width height)
  ;;; grow memory given the dimensions of the screen
  (store (mem 'width) width)
  (store (mem 'height) height)
  `(grow_memory ,(/ (* 4 (* width height)) #x10000)) ;; 0x10000 is memory page size
  '(drop))

(func hello ()
  (call 'log (mem 'messages) 12))

(func render (t)
  (call 'fill_screen 1)

  ;; black horizontal line
  (call 'fill_row (% t (load (mem 'height))) 0)
  ;; red vertical line
  (call 'fill_col (% t (load (mem 'width))) 2)
  ;; green vertical line
  (call 'fill_col (% (* 2 t) (load (mem 'width))) 3)
  ;; blue horizontal line
  (call 'fill_row (% (* 3 t) (load (mem 'height))) 4)
  ;; top left black dot
  (call 'plot 0 0 0))

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "hello" (func $hello))
