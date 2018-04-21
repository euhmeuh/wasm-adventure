#lang s-exp "wat.rkt"

(import "console" "log" (log pos len))
(import "console" "lognum" (log-num i))

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'object-size 4
  'alien-cols 9
  'alien-rows 5
  'alien-spacing 15
  'up 0
  'down 1
  'left 2
  'right 3)

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
  '(game 2048 (memstring 4
     score 0
     life 3
     level 0))
  '(aliens 2176 (memstring 1
     x 10 y 10
     speed 1
     down 0
     direction 3
     start
     1 1 1 1 1 1 1 1 1
     1 1 0 1 1 1 0 1 1
     1 1 1 1 1 1 1 1 1
     1 1 1 1 1 1 1 1 1
     1 0 1 1 0 1 1 0 1))
  '(player 2560 (memstring 1
     x 110 y 200))
  '(ranks 2670 (memstring 4
     start
     "SIM" 66666666
     "JER" 44444444
     "BEN" 10101010
     "AAA"  9000000
     "BBB"  5000000
     "CCC"  2500000
     "DDD"   100000
     "EEE"    10000
     "FFF"     5000
     "GGG"      500
     end))
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

(func show-aliens ()
  (locals i x y)
  (set-local x (load-byte (mem 'aliens 'x)))
  (set-local y (load-byte (mem 'aliens 'y)))

  (for i (* (const 'alien-cols) (const 'alien-rows)) 1
    (if (load-byte (+ i (mem 'aliens 'start)))
      (call 'sprite
            (+ x (* (% i (const 'alien-cols))
                    (const 'alien-spacing)))
            (+ y (* (/ i (const 'alien-cols))
                    (const 'alien-spacing)))
            (mem 'sprites 'invader)))))

(func show-player ()
  (call 'sprite
        (load-byte (mem 'player 'x))
        (load-byte (mem 'player 'y))
        (mem 'sprites 'player)))

(func render ()
  (call 'fill_screen (mem 'palette 'black))
  (call 'show-aliens)
  (call 'show-player))

(func move-aliens (delta)
  (locals x y speed down direction)
  (set-local x (load-byte (mem 'aliens 'x)))
  (set-local y (load-byte (mem 'aliens 'y)))
  (set-local speed (load-byte (mem 'aliens 'speed)))
  (set-local down (load-byte (mem 'aliens 'down)))
  (set-local direction (load-byte (mem 'aliens 'direction)))
  (if (call 'aliens-at-border? direction)
    (if (not down)
      ;; let's start moving down
      (set-local down 1))
    (if (>= down (const 'alien-spacing))
        ;; we finished moving down, let's change direction
        (set-local down 0)
        (set-local direction (call 'switch-direction direction))))
  (if down
    (then
      (set-local y (+ y speed))
      (set-local down (+ down speed)))
    (else
      (set-local x (call 'move x direction speed))))
  (store-byte (mem 'aliens 'x) x)
  (store-byte (mem 'aliens 'y) y)
  (store-byte (mem 'aliens 'down) down))

(func move (pos direction speed) =>
  (if (= direction (const 'right)) =>
    (then (+ pos speed))
    (else (- pos speed))))

(func switch-direction (direction) =>
  (set-local direction
    (if (= direction (const 'left)) =>
      (then (const 'right))
      (else (const 'left))))
  (store-byte (mem 'aliens 'direction) direction)
  direction)

(func aliens-at-border? (direction) =>
  (locals x)
  (set-local x (load-byte (mem 'aliens 'x)))
  (or (>= x 80) (<= x 5)))

(func update (delta)
  (call 'move-aliens delta))

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "update" (func $update))
(export "hello" (func $hello))
