#lang s-exp "wast.rkt"

(import "console" "log" (log pos len))

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'object-size 4)

(data
  '(width 0 0)
  '(height 4 0)
  '(palette 8 (memstring 3
     start
     black      #x000000
     white      #xFFFFFF
     red        #xFF0000
     green      #x00FF00
     blue       #x0000FF
     maroon     #x000000
     beige      #x000000
     orange     #x000000
     cyan       #x000000
     purple     #x000000
     pink       #x000000
     yellow     #x000000
     grey       #x000000
     dark-grey  #x000000
     dark-green #x000000
     dark-red   #x000000))
  '(messages 256 "Hello world!")
  '(sprites 1024 (memstring 1
     start
     invader 11 8
             0 0 1 0 0 0 0 0 1 0 0
             0 0 0 1 0 0 0 1 0 0 0
             0 0 1 1 1 1 1 1 1 0 0
             0 1 1 0 1 1 1 0 1 1 0
             1 1 1 1 1 1 1 1 1 1 1
             1 0 1 1 1 1 1 1 1 0 1
             1 0 1 0 0 0 0 0 1 0 1
             0 0 0 1 1 0 1 1 0 0 0))
  '(game 2048 (memstring 4
     score 0
     life 0
     level 0))
  '(objects 2176 (memstring 1
     start
     0 50 50 1 ;; show sprite 0 at pos (10 10) with 1HP
     0 70 50 1
     0 90 50 1
     0 110 50 1
     0 130 50 1
     0 150 50 1
     0 170 50 1
     0 190 50 1
     end))
  '(ranks 2560 (memstring 4
     start
     "JER" 44444444
     "AAA" 10000000
     "BBB"  5000000
     "CCC"  2500000
     "DDD"   100000
     "EEE"    10000
     "FFF"     5000
     "GGG"      500))
  '(screen 4092 0))

(func fill_pixels (pos len step color)
  (for pos len step
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
  (locals cursor) ;; write position in memory
  (set-local cursor (+ (mem 'screen) (* pos 4))) ;; 4 is pixel size
  ;; red component
  (store-byte cursor (load-byte color))
  ;; green component
  (store-byte (+ cursor 1) (load-byte (+ color 1)))
  ;; blue component
  (store-byte (+ cursor 2) (load-byte (+ color 2)))
  ;; alpha
  (store-byte (+ cursor 3) #xFF))

(func plot (x y color)
  ;;; draw a pixel at the given coordinates
  (call 'pixel (+ x (* y (load (mem 'height)))) color))

(func sprite (x y index)
  (locals width height color i)
  (set-local width (load-byte index))
  (set-local height (load-byte (+ 1 index)))
  (set-local color (+ 2 index))
  (for i (* width height) 1
    (call 'plot (+ x (% i width)) (+ y (/ i width))
          ;; convert the color number to a palette index
          (+ (mem 'palette 'start)
             (* (const 'color-size) (load-byte (+ i color)))))))

(func init (width height)
  ;;; grow memory given the dimensions of the screen
  (store (mem 'width) width)
  (store (mem 'height) height)
  `(grow_memory ,(/ (+ (mem 'screen) (* (const 'pixel-size) (* width height)))
                    (const 'page-size)))
  '(drop))

(func hello ()
  (call 'log (mem 'messages) 12))

(func render (dt)
  (locals i x y s)
  (call 'fill_screen (mem 'palette 'black))

  ;; show all sprites
  (set-local i (mem 'objects 'start))
  (for i (mem 'objects 'end) (const 'object-size)
    (set-local s (load-byte i))
    (set-local x (load-byte (+ 1 i)))
    (set-local y (load-byte (+ 2 i)))
    (call 'sprite x y (+ (mem 'sprites 'start) s))))

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "hello" (func $hello))
