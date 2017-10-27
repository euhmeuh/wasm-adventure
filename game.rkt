#lang s-exp "wast.rkt"

(import "console" "log" (log pos len))

'(memory 1)

(data
  '(width 0 0)
  '(height 4 0)
  '(palette 8 ((black #x000000)
               (white #xFFFFFF)
               (red #xFF0000)
               (green #x00FF00)
               (blue #x0000FF)
               (maroon #x000000)
               (beige #x000000)
               (orange #x000000)
               (cyan #x000000)
               (purple #x000000)
               (pink #x000000)
               (yellow #x000000)
               (grey #x000000)
               (dark-grey #x000000)
               (dark-green #x000000)
               (dark-red #x000000)))
  '(messages 256 "Hello world!")
  '(screen 1024 0))

(func fill_pixels (pos len step color)
  (for pos (- len 1) step
    (call 'pixel pos color)))

(func fill_row (row color)
  ;;; fill a full row of the screen with the given color
  (let-local (i len)
    (set-local i (* (load 'width) row))
    (set-local len (+ (load 'width) i))
    (call 'fill_pixels i len 1 color)))

'(func $fill_col (param $col i32) (param $color i32)
  ;;; fill a full column of the screen with the given color
  (local $len i32)

  i32.const 0 ;; @WIDTH
  i32.load
  i32.const 4 ;; @HEIGHT
  i32.load
  i32.mul
  set_local $len

  get_local $col
  get_local $len
  i32.const 0 ;; @WIDTH
  i32.load
  get_local $color
  call $fill_pixels)

'(func $fill_screen (param $color i32)
  ;;; fill the whole screen with a color

  ;; start
  i32.const 0

  ;; end
  i32.const 0 ;; @WIDTH
  i32.load
  i32.const 4 ;; @HEIGHT
  i32.load
  i32.mul

  i32.const 1
  get_local $color
  call $fill_pixels)

'(func $pixel (param $pos i32) (param $color i32)
  ;;; draw a pixel at the given position in memory with the given color

  (local $cursor i32) ;; write position in memory
  (local $comp i32) ;; color component to write

  get_local $pos
  i32.const 4 ;; pixel size
  i32.mul
  i32.const 1024 ;; @IMAGE
  i32.add
  tee_local $cursor

  get_local $color
  i32.const 3 ;; palette pixel size
  i32.mul
  i32.const 8 ;; @PALETTE
  i32.add
  tee_local $comp
  i32.load
  i32.store ;; red component

  get_local $cursor
  i32.const 1
  i32.add
  get_local $comp
  i32.const 1
  i32.add
  i32.load
  i32.store ;; green component

  get_local $cursor
  i32.const 2
  i32.add
  get_local $comp
  i32.const 2
  i32.add
  i32.load
  i32.store ;; blue component

  get_local $cursor
  i32.const 3
  i32.add
  i32.const 0xFF ;; alpha component
  i32.store)

'(func $plot (param $x i32) (param $y i32) (param $color i32)
  ;;; draw a pixel at the given coordinates
  get_local $y
  i32.const 4 ;; @HEIGHT
  i32.load
  i32.mul
  get_local $x
  i32.add
  get_local $color
  call $pixel)

'(func $init (param $width i32) (param $height i32)
  ;;; grow memory given the dimensions of the screen

  i32.const 0 ;; @WIDTH
  get_local $width
  i32.store

  i32.const 4 ;; @HEIGHT
  get_local $height
  i32.store

  get_local $width
  get_local $height
  i32.mul
  i32.const 4 ;; pixel size
  i32.mul
  i32.const 0x10000 ;; memory page size
  i32.div_u
  grow_memory
  drop)

(func hello ()
  (call 'log (mem 'messages) 12))

'(func $render (param $t i32)
  i32.const 1
  call $fill_screen

  get_local $t
  i32.const 4 ;; @HEIGHT
  i32.load
  i32.rem_u
  i32.const 0
  call $fill_row

  get_local $t
  i32.const 0 ;; @WIDTH
  i32.load
  i32.rem_u
  i32.const 2
  call $fill_col

  get_local $t
  i32.const 2
  i32.mul
  i32.const 0 ;; @WIDTH
  i32.load
  i32.rem_u
  i32.const 3
  call $fill_col

  get_local $t
  i32.const 3
  i32.mul
  i32.const 4 ;; @HEIGHT
  i32.load
  i32.rem_u
  i32.const 4
  call $fill_row

  i32.const 0
  i32.const 0
  i32.const 0
  call $plot)

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "hello" (func $hello))
