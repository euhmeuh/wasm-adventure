(module
  (import "console" "log" (func $log (param i32) (param i32)))

  (memory 1)

  (func $fill_pixels (param $pos i32) (param $len i32) (param $a i32)
    block
      loop
        get_local $pos
        get_local $len
        i32.ge_u
        br_if 1

        get_local $pos
        get_local $a
        call $pixel

        get_local $pos
        i32.const 1
        i32.add
        set_local $pos
        br 0
      end
    end)

  (func $fill_row (param $row i32) (param $a i32)
    (local $i i32)
    (local $len i32)

    i32.const 4 ;; height offset
    i32.load
    get_local $row
    i32.mul
    set_local $i

    i32.const 0 ;; width offset
    i32.load
    get_local $i
    i32.add
    set_local $len
    
    get_local $i
    get_local $len
    get_local $a
    call $fill_pixels)

  (func $fill_screen (param $a i32)
    ;; start
    i32.const 0

    ;; end
    i32.const 0 ;; width offset
    i32.load
    i32.const 4 ;; height offset
    i32.load
    i32.mul

    get_local $a
    call $fill_pixels)

  (func $pixel (param $pos i32) (param $a i32)
    ;;; draw a black pixel at the given position in memory

    i32.const 3 ;; alpha byte offset
    i32.const 32 ;; image memory offset
    i32.const 4 ;; pixel size
    get_local $pos
    i32.mul
    i32.add
    i32.add
    get_local $a
    i32.store)

  (func $init (export "init") (param $width i32) (param $height i32)
    ;;; grow memory given the dimensions of the screen

    i32.const 0
    get_local $width
    i32.store

    i32.const 4
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

  (func $hello (export "hello")
    i32.const 16
    i32.const 12
    call $log)

  (func $render (export "render") (param $t i32)
    i32.const 0x00
    call $fill_screen
    i32.const 10
    i32.const 0xFF
    call $fill_row)

  (export "memory" (memory 0))
  (data (i32.const 16) "Hello world!"))

;; Memory Map
;; 0-3    screen width
;; 4-7    screen height
;; 16-31  debug messages
;; 32-?   image memory
