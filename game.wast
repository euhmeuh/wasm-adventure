(module
  (import "console" "log" (func $log (param i32) (param i32)))

  (memory 1)


  ;;; ########################
  ;;; ### pixel primitives ###
  ;;; ########################


  (func $fill_pixels (param $pos i32) (param $len i32) (param $step i32) (param $color i32)
    ;;; fill pixels in memory with the given color, skipping pixels if needed using $step
    loop $loop
      block $stop
        get_local $pos
        get_local $len
        i32.const 1
        i32.sub
        i32.ge_u
        br_if $stop

        get_local $pos
        get_local $color
        call $pixel

        get_local $pos
        get_local $step
        i32.add
        set_local $pos
        br $loop
      end
    end)

  (func $fill_row (param $row i32) (param $color i32)
    ;;; fill a full row of the screen with the given color
    (local $i i32)
    (local $len i32)

    i32.const 0 ;; @WIDTH
    i32.load
    get_local $row
    i32.mul
    set_local $i

    i32.const 0 ;; @WIDTH
    i32.load
    get_local $i
    i32.add
    set_local $len

    get_local $i
    get_local $len
    i32.const 1
    get_local $color
    call $fill_pixels)

  (func $fill_col (param $col i32) (param $color i32)
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

  (func $fill_screen (param $color i32)
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

  (func $pixel (param $pos i32) (param $color i32)
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


  ;;; ########################
  ;;; ###    game init     ###
  ;;; ########################


  (func $init (export "init") (param $width i32) (param $height i32)
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


  ;;; ########################
  ;;; ###       misc       ###
  ;;; ########################


  (func $hello (export "hello")
    i32.const 256 ;; @MESSAGES
    i32.const 12 ;; length
    call $log)


  ;;; ########################
  ;;; ###   game render    ###
  ;;; ########################


  (func $render (export "render") (param $t i32)
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
    call $fill_row)


  ;;; ########################
  ;;; ###      memory      ###
  ;;; ########################

  ;;; Memory Map
  ;;; [0-3]        @WIDTH      screen width
  ;;; [4-7]        @HEIGHT     screen height
  ;;; [8-55]       @PALETTE    color palette
  ;;; [256-1023]   @MESSAGES   debug messages
  ;;; [1024-?]     @IMAGE      image memory

  (export "memory" (memory 0))

  ;;                   black   ]white   ]red     ]green   ]blue    ]
  (data (i32.const 8) "\00\00\00\FF\FF\FF\FF\00\00\00\FF\00\00\00\FF")
  (data (i32.const 256) "Hello world!"))


