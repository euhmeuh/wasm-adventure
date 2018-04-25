(module (import "console" "log" (func $log (param i32) (param i32))) (import "console" "lognum" (func $log-num (param i32))) (memory 1)   (func $fill-pixels (param $pos i32) (param $len i32) (param $step i32) (param $color i32)  (loop $loop (block $done (br_if $done (i32.ge_u (get_local $pos) (get_local $len))) (call $pixel (get_local $pos) (get_local $color)) (set_local $pos (i32.add (get_local $pos) (get_local $step))) (br $loop)))) (func $fill-row (param $row i32) (param $color i32)  (local $i i32) (local $len i32) (set_local $i (i32.mul (i32.load (i32.const 0)) (get_local $row))) (set_local $len (i32.add (i32.load (i32.const 0)) (get_local $i))) (call $fill-pixels (get_local $i) (get_local $len) (i32.const 1) (get_local $color))) (func $fill-col (param $col i32) (param $color i32)  (local $len i32) (set_local $len (i32.mul (i32.load (i32.const 0)) (i32.load (i32.const 4)))) (call $fill-pixels (get_local $col) (get_local $len) (i32.load (i32.const 0)) (get_local $color))) (func $fill-screen (param $color i32)  (call $fill-pixels (i32.const 0) (i32.mul (i32.load (i32.const 0)) (i32.load (i32.const 4))) (i32.const 1) (get_local $color))) (func $pixel (param $pos i32) (param $color i32)  (local $cursor i32) (if  (i32.ne (get_local $color) (i32.const 8)) (then (set_local $cursor (i32.add (i32.const 8192) (i32.mul (get_local $pos) (i32.const 4)))) (i32.store8 (get_local $cursor) (i32.load8_u (get_local $color))) (i32.store8 (i32.add (get_local $cursor) (i32.const 1)) (i32.load8_u (i32.add (get_local $color) (i32.const 1)))) (i32.store8 (i32.add (get_local $cursor) (i32.const 2)) (i32.load8_u (i32.add (get_local $color) (i32.const 2)))) (i32.store8 (i32.add (get_local $cursor) (i32.const 3)) (i32.const 255))))) (func $plot (param $x i32) (param $y i32) (param $color i32)  (call $pixel (i32.add (get_local $x) (i32.mul (get_local $y) (i32.load (i32.const 4)))) (get_local $color))) (func $sprite (param $x i32) (param $y i32) (param $index i32)  (local $width i32) (local $height i32) (local $color i32) (local $i i32) (set_local $width (i32.load8_u (get_local $index))) (set_local $height (i32.load8_u (i32.add (i32.const 1) (get_local $index)))) (set_local $color (i32.add (i32.const 2) (get_local $index))) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (get_local $width) (get_local $height)))) (call $plot (i32.add (get_local $x) (i32.rem_u (get_local $i) (get_local $width))) (i32.add (get_local $y) (i32.div_u (get_local $i) (get_local $width))) (i32.add (i32.const 8) (i32.mul (i32.const 3) (i32.load8_u (i32.add (get_local $i) (get_local $color)))))) (set_local $i (i32.add (get_local $i) (i32.const 1))) (br $loop)))) (func $init (param $width i32) (param $height i32)  (i32.store (i32.const 0) (get_local $width)) (i32.store (i32.const 4) (get_local $height)) (grow_memory (i32.div_u (i32.add (i32.const 8192) (i32.mul (i32.const 4) (i32.mul (get_local $width) (get_local $height)))) (i32.const 65536))) (drop)) (func $tile-x (param $i i32) (result i32) (return (i32.add (i32.const 6) (i32.mul (i32.rem_u (get_local $i) (i32.const 13)) (i32.const 16))))) (func $tile-y (param $i i32) (result i32) (return (i32.add (i32.const 22) (i32.mul (i32.div_u (get_local $i) (i32.const 13)) (i32.const 16))))) (func $row-up (param $pos i32) (result i32) (return (i32.sub (get_local $pos) (i32.const 13)))) (func $row-down (param $pos i32) (result i32) (return (i32.add (get_local $pos) (i32.const 13)))) (func $show-level (param $level i32)  (local $i i32) (local $tile i32) (set_local $i (i32.const 0)) (set_local $tile (i32.const 0)) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (i32.const 13) (i32.const 11)))) (set_local $tile (i32.load8_u (i32.add (get_local $level) (get_local $i)))) (call $sprite (call $tile-x (get_local $i)) (call $tile-y (get_local $i)) (i32.add (i32.const 1024) (i32.mul (i32.const 258) (get_local $tile)))) (set_local $i (i32.add (get_local $i) (i32.const 1))) (br $loop)))) (func $show-units (param $unit-list i32)  (local $pos i32) (local $level i32) (set_local $pos (i32.const 81)) (call $sprite (call $tile-x (get_local $pos)) (call $tile-y (call $row-up (get_local $pos))) (i32.const 2314)) (set_local $pos (i32.const 66)) (call $sprite (call $tile-x (get_local $pos)) (call $tile-y (call $row-up (get_local $pos))) (i32.const 2828))) (func $show-cursor-top  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 7878))) (call $sprite (i32.sub (call $tile-x (get_local $pos)) (i32.const 2)) (i32.sub (call $tile-y (get_local $pos)) (i32.const 2)) (i32.const 5398))) (func $show-cursor-bot  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 7878))) (call $sprite (i32.sub (call $tile-x (get_local $pos)) (i32.const 2)) (i32.add (call $tile-y (get_local $pos)) (i32.const 8)) (i32.const 5600))) (func $hello  (call $log (i32.const 256) (i32.const 12))) (func $render  (call $fill-screen (i32.const 56)) (call $show-level (i32.const 6144)) (call $show-cursor-top) (call $show-units (i32.const 6287)) (call $show-cursor-bot)) (export "memory" (memory 0)) (export "init" (func $init)) (export "render" (func $render)) (export "hello" (func $hello)) (data (i32.const 0) "\00") (data (i32.const 4) "\00") (data (i32.const 8) "\00\00\00\1d\2b\53\7e\25\53\00\87\51\ab\52\36\5f\57\4f\c2\c3\c7\ff\f1\e8\ff\00\4d\ff\a3\00\ff\ec\27\00\e4\36\29\ad\ff\83\76\9c\ff\77\a8\ff\cc\aa\00\00\00") (data (i32.const 256) "Hello world!") (data (i32.const 1024) "\10\10\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\0b\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\0b\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\0b\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\10\10\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\0d\01\01\01\01\01\01\01\01\01\01\01\0d\0d\0d\01\01\01\01\01\0d\01\01\01\0d\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\0d\01\01\01\01\0d\01\01\01\01\01\01\01\01\0d\01\01\01\01\0d\0d\01\01\01\0d\0d\0d\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\0d\0d\01\0d\01\01\01\0d\01\0d\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\10\10\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\10\10\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\02\02\04\04\04\04\04\04\02\02\02\04\04\02\02\02\05\02\02\02\02\04\04\02\02\05\05\04\04\02\05\00\05\05\02\05\05\02\02\05\05\05\05\02\02\05\02\05\00\05\05\05\05\05\05\05\00\05\05\05\02\05\05\00\05\00\05\05\00\05\00\00\05\00\05\05\05\05\05\00\00\05\00\05\05\00\00\05\00\05\00\05\00\05\05\00\00\00\00\00\00\05\00\00\00\00\05\05\00\05\00\00\00\05\00\05\00\00\00\00\00\00\00\00\00\00\05\00\00\00\05\00\00\00\00\00\00\05\00\00\00\05\00\00\00\00\00\00\05\00\00\00\05\00\05\00\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\10\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\05\05\00\00\00\00\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\00\00\05\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") (data (i32.const 2314) "\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\06\06\06\06\06\00\00\00\00\00\00\00\00\00\06\06\07\06\06\06\06\06\00\00\00\06\00\00\00\00\06\07\06\06\04\04\04\04\00\00\07\06\00\00\00\00\06\07\06\04\0f\0f\0f\0f\00\00\07\06\00\00\00\00\06\06\06\04\0f\09\0f\0f\00\00\07\06\00\00\00\00\06\06\06\04\0f\0f\0f\0f\00\00\07\06\00\00\00\00\00\06\06\0f\0f\0f\0f\0f\00\00\07\06\00\00\00\00\0d\0d\06\06\06\06\0d\0d\00\00\07\06\00\00\00\00\0d\0d\0d\0d\0d\0d\0d\0d\00\06\06\06\06\00\00\00\05\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\05\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\05\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\00\00\00\00\00\06\06\06\00\00\06\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\0c\0c\0c\00\00\00\00\00\00\00\00\00\00\00\00\0c\0c\0c\0c\00\00\00\00\00\00\00\00\00\00\00\00\06\06\06\06\00\00\00\00\00\00\00\00\00\00\06\00\00\06\06\00\00\06\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\06\06\00\00\00\06\06\07\06\06\06\06\06\00\00\00\00\06\06\00\00\06\07\06\06\04\04\04\06\00\04\04\06\06\06\00\00\06\07\06\04\0f\0f\04\06\00\06\06\06\06\06\00\00\06\06\06\04\0f\09\0f\04\00\06\06\06\06\06\00\00\06\06\06\04\0f\0f\0f\0f\00\04\04\06\06\06\00\0d\0d\06\06\0f\0f\0f\0f\0f\0d\04\04\00\06\06\00\0d\0d\0d\06\06\06\06\0d\0d\0d\04\04\06\06\00\00\0d\0d\0d\0d\0d\0d\0d\0d\0d\0d\04\04\00\00\00\00\00\05\05\0d\05\05\05\0d\05\05\04\04\00\00\00\00\00\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\00\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\00\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\00\00\00\00\00\06\06\06\00\00\06\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") (data (i32.const 5398) "\14\0a\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\07\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\14\0a\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\07\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00") (data (i32.const 6144) "\02\02\02\02\02\02\02\02\02\03\02\00\00\00\00\00\00\02\02\02\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\02\01\01\00\00\00\00\00\00\00\00\00\00\02\02\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\01\01\01\00\00\00\00\00\03\03\00\00\01\01\01\01\01\02\02\00\03\04\04\00\01\01\01\01\01\01\01\01\02\04\42\01\4e\00\51\00\68\00\ff\ff\34\00\4a\02\58\01\59\01\68\00\ff\ff") (data (i32.const 7876) "\00\00\42") (data (i32.const 8192) "\00"))