#lang s-exp "wat.rkt"

(import "console" "log" (log pos len))
(import "console" "lognum" (log-num i))

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'up 0
  'down 1
  'left 2
  'right 3)

(data
  '(width 0 0)
  '(height 4 0)
  '(palette 8 (memstring 3
     start       ;; Pico8 palette
     black       #x000000
     dark-blue   #x1D2B53
     dark-purple #x7E2553
     dark-green  #x008751
     brown       #xAB5236
     dark-gray   #x5F574F
     light-gray  #xC2C3C7
     white       #xFFF1E8
     red         #xFF004D
     orange      #xFFA300
     yellow      #xFFEC27
     green       #x00E436
     blue        #x29ADFF
     indigo      #x83769C
     pink        #xFF77A8
     peach       #xFFCCAA))
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
             0 0 0 1 1 0 1 1 0 0 0
     player 11 8
            0 0 0 0 0 1 0 0 0 0 0
            0 0 0 0 0 1 0 0 0 0 0
            0 0 0 0 0 1 0 0 0 0 0
            0 1 0 0 1 1 1 0 0 1 0
            1 1 1 1 1 0 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1
            1 0 1 1 1 1 1 1 1 0 1
            1 0 1 0 1 1 1 0 1 0 1
     ))
  '(game 2048 (memstring 1
     coins 0
     level 0))
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

(func render ()
  (locals i)
  (set-local i 0)
  (call 'fill_screen (mem 'palette 'black))
  (for i (load (mem 'height)) 1
    (call 'fill_row i (+ (* (% i 16)
                            (const 'color-size))
                         (mem 'palette 'start)))))

;;(func update (delta)
;;  todo)

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
;;(export "update" (func $update))
(export "hello" (func $hello))
