#lang s-exp "wat.rkt"

(import "console" "log" (log pos len))
(import "console" "lognum" (log-num i))

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'tile-size 258
  'up 0
  'down 1
  'left 2
  'right 3
  'board-offset-x 6
  'board-offset-y 22
  'board-width 13
  'board-height 11)

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
  '(tiles 1024 (memstring 1
     start
     grass 16 16
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3 11  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3 11  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3 11  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
      3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
     water 16 16
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1 13  1  1  1  1  1  1  1  1  1  1
      1 13 13 13  1  1  1  1  1 13  1  1  1 13  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1 13  1  1  1  1 13  1  1  1  1  1  1
      1  1 13  1  1  1  1 13 13  1  1  1 13 13 13  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1 13 13  1 13  1  1  1 13  1 13  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
      1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
     sand 16 16
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15  9 15 15 15 15 15
     15 15 15  9 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15  9 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15  9 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15
     pit 16 16
      4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4
      4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4
      4  2  2  4  4  4  4  4  4  2  2  2  4  4  2  2
      2  5  2  2  2  2  4  4  2  2  5  5  4  4  2  5
      0  5  5  2  5  5  2  2  5  5  5  5  2  2  5  2
      5  0  5  5  5  5  5  5  5  0  5  5  5  2  5  5
      0  5  0  5  5  0  5  0  0  5  0  5  5  5  5  5
      0  0  5  0  5  5  0  0  5  0  5  0  5  0  5  5
      0  0  0  0  0  0  5  0  0  0  0  5  5  0  5  0
      0  0  5  0  5  0  0  0  0  0  0  0  0  0  0  5
      0  0  0  5  0  0  0  0  0  0  5  0  0  0  5  0
      0  0  0  0  0  5  0  0  0  5  0  5  0  0  0  0
      0  0  0  5  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     pit2 16 16
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  5  0  0  0  0  0  0  0  0  0  5  5  0
      0  0  0  0  0  0  0  0  0  5  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  5  0  0  0
      5  0  0  0  0  5  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ))
  '(levels 6144 (memstring 1
     level1
     ;; grass 0
     ;; water 1
     ;; sand 2
     ;; pit 3
     2 2 2 2 2 2 2 2 2 3 2 0 0
     0 0 0 0 2 2 2 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 2 1 1 0 0 0 0
     0 0 0 0 0 0 2 2 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 1 1 1 1 0 0 0 0 0
     3 3 0 0 1 1 1 1 1 2 2 0 3
     4 4 0 1 1 1 1 1 1 1 1 2 4
     player-units
     66 1 78 0 81 0 104 0 #xFF #xFF
     ennemy-units
     52 0 74 2 88 1 89 1 104 0 #xFF #xFF
     ))
  '(game 7876 (memstring 1
     coins 0
     level 0))
  '(screen 8192 0))

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

(func show_level (level)
  (locals i tile)
  (set-local i 0)
  (set-local tile 0)
  (for i (* (const 'board-width) (const 'board-height)) 1
    (set-local tile (load-byte (+ level i)))
    (call 'sprite (+ (const 'board-offset-x) (* (% i (const 'board-width)) 16))
                  (+ (const 'board-offset-y) (* (/ i (const 'board-width)) 16))
                  (+ (mem 'tiles 'start) (* (const 'tile-size) tile)))))

(func hello ()
  (call 'log (mem 'messages) 12))

(func render ()
  (call 'fill_screen (mem 'palette 'black))
  (call 'show_level (mem 'levels 'level1)))

;;(func update (delta)
;;  todo)

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
;;(export "update" (func $update))
(export "hello" (func $hello))
