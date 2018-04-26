(module (import "console" "log" (func $log (param i32) (param i32))) (import "console" "lognum" (func $log-num (param i32))) (memory 1)   (func $fill-pixels (param $pos i32) (param $len i32) (param $step i32) (param $color i32)  (loop $loop (block $done (br_if $done (i32.ge_u (get_local $pos) (get_local $len))) (call $pixel (get_local $pos) (get_local $color)) (set_local $pos (i32.add (get_local $pos) (get_local $step))) (br $loop)))) (func $fill-row (param $row i32) (param $color i32)  (local $i i32) (local $len i32) (set_local $i (i32.mul (i32.load (i32.const 0)) (get_local $row))) (set_local $len (i32.add (i32.load (i32.const 0)) (get_local $i))) (call $fill-pixels (get_local $i) (get_local $len) (i32.const 1) (get_local $color))) (func $fill-col (param $col i32) (param $color i32)  (local $len i32) (set_local $len (i32.mul (i32.load (i32.const 0)) (i32.load (i32.const 4)))) (call $fill-pixels (get_local $col) (get_local $len) (i32.load (i32.const 0)) (get_local $color))) (func $fill-screen (param $color i32)  (call $fill-pixels (i32.const 0) (i32.mul (i32.load (i32.const 0)) (i32.load (i32.const 4))) (i32.const 1) (get_local $color))) (func $pixel (param $pos i32) (param $color i32)  (local $cursor i32) (if  (i32.ne (get_local $color) (i32.const 8)) (then (set_local $cursor (i32.add (i32.const 10240) (i32.mul (get_local $pos) (i32.const 4)))) (i32.store8 (get_local $cursor) (i32.load8_u (get_local $color))) (i32.store8 (i32.add (get_local $cursor) (i32.const 1)) (i32.load8_u (i32.add (get_local $color) (i32.const 1)))) (i32.store8 (i32.add (get_local $cursor) (i32.const 2)) (i32.load8_u (i32.add (get_local $color) (i32.const 2)))) (i32.store8 (i32.add (get_local $cursor) (i32.const 3)) (i32.const 255))))) (func $plot (param $x i32) (param $y i32) (param $color i32)  (call $pixel (i32.add (get_local $x) (i32.mul (get_local $y) (i32.load (i32.const 4)))) (get_local $color))) (func $sprite (param $x i32) (param $y i32) (param $index i32)  (local $width i32) (local $height i32) (local $color i32) (local $i i32) (set_local $width (i32.load8_u (get_local $index))) (set_local $height (i32.load8_u (i32.add (i32.const 1) (get_local $index)))) (set_local $color (i32.add (i32.const 2) (get_local $index))) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (get_local $width) (get_local $height)))) (call $plot (i32.add (get_local $x) (i32.rem_u (get_local $i) (get_local $width))) (i32.add (get_local $y) (i32.div_u (get_local $i) (get_local $width))) (i32.add (i32.const 8) (i32.mul (i32.const 3) (i32.load8_u (i32.add (get_local $i) (get_local $color)))))) (set_local $i (i32.add (get_local $i) (i32.const 1))) (br $loop)))) (func $init (param $width i32) (param $height i32)  (i32.store (i32.const 0) (get_local $width)) (i32.store (i32.const 4) (get_local $height)) (grow_memory (i32.div_u (i32.add (i32.const 10240) (i32.mul (i32.const 4) (i32.mul (get_local $width) (get_local $height)))) (i32.const 65536))) (drop) (call $load-level (i32.const 7189))) (func $tile-x (param $i i32) (result i32) (return (i32.add (i32.const 6) (i32.mul (i32.rem_u (get_local $i) (i32.const 13)) (i32.const 16))))) (func $tile-y (param $i i32) (result i32) (return (i32.add (i32.const 22) (i32.mul (i32.div_u (get_local $i) (i32.const 13)) (i32.const 16))))) (func $row-up (param $pos i32) (result i32) (return (i32.sub (get_local $pos) (i32.const 13)))) (func $row-down (param $pos i32) (result i32) (return (i32.add (get_local $pos) (i32.const 13)))) (func $show-level (param $level i32)  (local $i i32) (local $tile i32) (set_local $i (i32.const 0)) (set_local $tile (i32.const 0)) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.const 143))) (set_local $tile (i32.load8_u (i32.add (get_local $level) (get_local $i)))) (call $sprite (call $tile-x (get_local $i)) (call $tile-y (get_local $i)) (i32.add (i32.const 512) (i32.mul (i32.const 258) (get_local $tile)))) (set_local $i (i32.add (get_local $i) (i32.const 1))) (br $loop)))) (func $show-current-units  (local $i i32) (local $pos i32) (local $level i32) (local $units i32) (local $ennemy? i32) (set_local $i (i32.const 0)) (set_local $units (i32.const 8205)) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (i32.const 2) (i32.const 143)))) (set_local $pos (i32.load8_u (i32.add (get_local $units) (get_local $i)))) (set_local $level (i32.load8_u (i32.add (get_local $units) (i32.add (i32.const 1) (get_local $i))))) (if  (i32.and (i32.eq (get_local $pos) (i32.const 255)) (get_local $ennemy?)) (then (br $done))) (if  (i32.and (i32.eq (get_local $pos) (i32.const 255)) (i32.eq (get_local $ennemy?) (i32.const 0))) (then (set_local $ennemy? (i32.const 1)))) (call $sprite (call $tile-x (get_local $pos)) (call $tile-y (call $row-up (get_local $pos))) (i32.add (i32.const 1803) (i32.mul (i32.add (get_local $level) (i32.mul (i32.const 3) (get_local $ennemy?))) (i32.const 514)))) (set_local $i (i32.add (get_local $i) (i32.const 2))) (br $loop)))) (func $show-cursor-top  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 8193))) (call $sprite (i32.sub (call $tile-x (get_local $pos)) (i32.const 2)) (i32.sub (call $tile-y (get_local $pos)) (i32.const 2)) (if (result i32) (call $has-selection?) (then (i32.const 5291)) (else (i32.const 4887))))) (func $show-cursor-bot  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 8193))) (call $sprite (i32.sub (call $tile-x (get_local $pos)) (i32.const 2)) (i32.add (call $tile-y (get_local $pos)) (i32.const 8)) (if (result i32) (call $has-selection?) (then (i32.const 5493)) (else (i32.const 5089))))) (func $show-path  (local $i i32) (local $move i32) (set_local $i (i32.const 0)) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.const 8))) (set_local $move (i32.load8_u (i32.add (i32.const 8195) (get_local $i)))) (if  (i32.eq (get_local $move) (i32.const 255)) (then (br $done))) (call $sprite (call $tile-x (get_local $move)) (call $tile-y (get_local $move)) (i32.const 5695)) (set_local $i (i32.add (get_local $i) (i32.const 1))) (br $loop)))) (func $show-action  (local $cursor-pos i32) (local $current-action i32) (set_local $current-action (i32.load8_u (i32.const 8203))) (if  (i32.and (call $has-selection?) (i32.and (i32.ne (get_local $current-action) (i32.const 255)) (i32.ne (get_local $current-action) (i32.const 5)))) (then (set_local $cursor-pos (i32.load8_u (i32.const 8193))) (call $sprite (i32.add (i32.const 16) (call $tile-x (get_local $cursor-pos))) (call $tile-y (call $row-down (get_local $cursor-pos))) (i32.add (i32.const 6500) (i32.mul (get_local $current-action) (i32.const 66))))))) (func $move-cursor-up  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 8193))) (if  (i32.ge_u (get_local $pos) (i32.const 13)) (then (set_local $pos (call $row-up (get_local $pos))) (i32.store8 (i32.const 8193) (get_local $pos)) (call $update-move-pile (get_local $pos))))) (func $move-cursor-down  (local $pos i32) (set_local $pos (call $row-down (i32.load8_u (i32.const 8193)))) (if  (i32.lt_u (get_local $pos) (i32.const 143)) (then (i32.store8 (i32.const 8193) (get_local $pos)) (call $update-move-pile (get_local $pos))))) (func $move-cursor-left  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 8193))) (if  (i32.gt_u (i32.rem_u (get_local $pos) (i32.const 13)) (i32.const 0)) (then (set_local $pos (i32.sub (get_local $pos) (i32.const 1))) (i32.store8 (i32.const 8193) (get_local $pos)) (call $update-move-pile (get_local $pos))))) (func $move-cursor-right  (local $pos i32) (set_local $pos (i32.add (i32.load8_u (i32.const 8193)) (i32.const 1))) (if  (i32.gt_u (i32.rem_u (get_local $pos) (i32.const 13)) (i32.const 0)) (then (i32.store8 (i32.const 8193) (get_local $pos)) (call $update-move-pile (get_local $pos))))) (func $update-move-pile (param $pos i32)  (local $i i32) (local $move i32) (local $erase-mode i32) (set_local $i (i32.const 0)) (set_local $erase-mode (i32.const 0)) (if  (call $has-selection?) (then (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.const 8))) (if  (get_local $erase-mode) (then (i32.store8 (i32.add (i32.const 8195) (get_local $i)) (i32.const 255))) (else (set_local $move (i32.load8_u (i32.add (i32.const 8195) (get_local $i)))) (if  (i32.eq (get_local $move) (i32.const 255)) (then (i32.store8 (i32.add (i32.const 8195) (get_local $i)) (get_local $pos)) (br $done))) (if  (i32.eq (get_local $move) (get_local $pos)) (then (set_local $erase-mode (i32.const 1)))))) (set_local $i (i32.add (get_local $i) (i32.const 1))) (br $loop)))))) (func $update-action  (local $pos i32) (set_local $pos (i32.load8_u (i32.const 8193))) (if  (call $has-selection?) (then (if  (call $is-unit? (get_local $pos)) (then (if  (call $is-selection? (get_local $pos)) (then (i32.store8 (i32.const 8203) (i32.const 0))) (else (if  (i32.and (call $is-ennemy-unit? (get_local $pos)) (call $within-distance? (i32.const 1))) (then (i32.store8 (i32.const 8203) (i32.const 2))) (else (i32.store8 (i32.const 8203) (i32.const 3))))))) (else (if  (i32.and (i32.eq (call $is-blocking-tile? (get_local $pos)) (i32.const 0)) (call $within-distance? (i32.const 3))) (then (i32.store8 (i32.const 8203) (i32.const 1))) (else (i32.store8 (i32.const 8203) (i32.const 3))))))) (else (if  (call $is-player-unit? (get_local $pos)) (then (i32.store8 (i32.const 8203) (i32.const 5))) (else (i32.store8 (i32.const 8203) (i32.const 255))))))) (func $has-selection? (result i32) (return (i32.ne (i32.load8_u (i32.const 8194)) (i32.const 255)))) (func $is-selection? (param $pos i32) (result i32) (return (i32.eq (get_local $pos) (i32.load8_u (i32.const 8194))))) (func $selected-unit (result i32) (local $i i32) (local $addr i32) (local $unit i32) (local $selection i32) (local $result i32) (set_local $i (i32.const 0)) (set_local $result (i32.const 0)) (set_local $selection (i32.load8_u (i32.const 8194))) (if  (i32.ne (get_local $selection) (i32.const 255)) (then (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (i32.const 2) (i32.const 143)))) (set_local $addr (i32.add (i32.const 8205) (get_local $i))) (set_local $unit (i32.load8_u (get_local $addr))) (if  (i32.eq (get_local $unit) (get_local $selection)) (then (set_local $result (get_local $addr)) (br $done))) (if  (i32.eq (get_local $unit) (i32.const 255)) (then (br $done))) (set_local $i (i32.add (get_local $i) (i32.const 2))) (br $loop))))) (return (get_local $result))) (func $current-level (result i32) (return (i32.const 7189))) (func $level-units (param $level i32) (result i32) (return (i32.add (get_local $level) (i32.const 143)))) (func $load-level (param $level i32)  (local $i i32) (local $units i32) (local $pos i32) (local $lvl i32) (local $ennemy? i32) (set_local $i (i32.const 0)) (set_local $units (call $level-units (get_local $level))) (set_local $ennemy? (i32.const 0)) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (i32.const 2) (i32.const 143)))) (set_local $pos (i32.load8_u (i32.add (get_local $units) (get_local $i)))) (set_local $lvl (i32.load8_u (i32.add (i32.const 1) (i32.add (get_local $units) (get_local $i))))) (i32.store8 (i32.add (get_local $i) (i32.const 8205)) (get_local $pos)) (i32.store8 (i32.add (i32.const 1) (i32.add (get_local $i) (i32.const 8205))) (get_local $lvl)) (if  (i32.and (i32.eq (get_local $pos) (i32.const 255)) (get_local $ennemy?)) (then (br $done))) (if  (i32.and (i32.eq (get_local $pos) (i32.const 255)) (i32.eq (get_local $ennemy?) (i32.const 0))) (then (set_local $ennemy? (i32.const 1)))) (set_local $i (i32.add (get_local $i) (i32.const 2))) (br $loop)))) (func $is-unit? (param $pos i32) (result i32) (local $i i32) (local $unit i32) (local $ennemy? i32) (local $result i32) (set_local $i (i32.const 0)) (set_local $result (i32.const 0)) (set_local $ennemy? (i32.const 0)) (loop $loop (block $done (br_if $done (i32.ge_u (get_local $i) (i32.mul (i32.const 2) (i32.const 143)))) (set_local $unit (i32.load8_u (i32.add (i32.const 8205) (get_local $i)))) (if  (i32.eq (get_local $unit) (get_local $pos)) (then (set_local $result (if (result i32) (get_local $ennemy?) (then (i32.const 2)) (else (i32.const 1)))) (br $done))) (if  (i32.and (i32.eq (get_local $unit) (i32.const 255)) (get_local $ennemy?)) (then (br $done))) (if  (i32.and (i32.eq (get_local $unit) (i32.const 255)) (i32.eq (get_local $ennemy?) (i32.const 0))) (then (set_local $ennemy? (i32.const 1)))) (set_local $i (i32.add (get_local $i) (i32.const 2))) (br $loop))) (return (get_local $result))) (func $is-player-unit? (param $pos i32) (result i32) (return (i32.eq (call $is-unit? (get_local $pos)) (i32.const 1)))) (func $is-ennemy-unit? (param $pos i32) (result i32) (return (i32.eq (call $is-unit? (get_local $pos)) (i32.const 2)))) (func $is-blocking-tile? (param $pos i32) (result i32) (local $tile i32) (set_local $tile (i32.load8_u (i32.add (call $current-level) (get_local $pos)))) (return (i32.or (i32.eq (get_local $tile) (i32.const 1)) (i32.or (i32.eq (get_local $tile) (i32.const 3)) (i32.eq (get_local $tile) (i32.const 4)))))) (func $within-distance? (param $max i32) (result i32) (return (i32.eq (i32.load8_u (i32.add (i32.const 8195) (get_local $max))) (i32.const 255)))) (func $enter  (local $cursor-pos i32) (local $current-action i32) (set_local $cursor-pos (i32.load8_u (i32.const 8193))) (set_local $current-action (i32.load8_u (i32.const 8203))) (if  (i32.eq (get_local $current-action) (i32.const 5)) (then (call $select (get_local $cursor-pos)))) (if  (i32.eq (get_local $current-action) (i32.const 1)) (then (call $move (get_local $cursor-pos)))) (if  (i32.eq (get_local $current-action) (i32.const 2)) (then (call $attack (get_local $cursor-pos)))) (if  (i32.eq (get_local $current-action) (i32.const 0)) (then (call $upgrade)))) (func $select (param $pos i32)  (i32.store8 (i32.const 8194) (get_local $pos))) (func $cancel  (i32.store8 (i32.const 8194) (i32.const 255)) (i32.store8 (i32.const 8203) (i32.const 255)) (i32.store (i32.const 8195) (i32.const 4294967295)) (i32.store (i32.add (i32.const 4) (i32.const 8195)) (i32.const 4294967295))) (func $move (param $pos i32)  (i32.store8 (call $selected-unit) (get_local $pos)) (call $cancel)) (func $attack (param $pos i32)  (call $log-num (i32.const 6666))) (func $upgrade  (call $log-num (i32.const 1234))) (func $hello  (call $log (i32.const 256) (i32.const 12))) (func $render  (call $fill-screen (i32.const 56)) (call $show-level (call $current-level)) (call $show-cursor-top) (call $show-current-units) (call $show-cursor-bot) (call $show-path) (call $show-action)) (func $keydown (param $key i32)  (if  (i32.eq (get_local $key) (i32.const 0)) (then (call $move-cursor-up))) (if  (i32.eq (get_local $key) (i32.const 1)) (then (call $move-cursor-down))) (if  (i32.eq (get_local $key) (i32.const 2)) (then (call $move-cursor-left))) (if  (i32.eq (get_local $key) (i32.const 3)) (then (call $move-cursor-right))) (if  (i32.eq (get_local $key) (i32.const 4)) (then (call $enter))) (if  (i32.eq (get_local $key) (i32.const 5)) (then (call $cancel))) (call $update-action)) (export "memory" (memory 0)) (export "init" (func $init)) (export "render" (func $render)) (export "keydown" (func $keydown)) (export "hello" (func $hello)) (data (i32.const 0) "\00") (data (i32.const 4) "\00") (data (i32.const 8) "\00\00\00\1d\2b\53\7e\25\53\00\87\51\ab\52\36\5f\57\4f\c2\c3\c7\ff\f1\e8\ff\00\4d\ff\a3\00\ff\ec\27\00\e4\36\29\ad\ff\83\76\9c\ff\77\a8\ff\cc\aa\00\00\00") (data (i32.const 256) "Hello world!") (data (i32.const 512) "\10\10\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\0b\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\0b\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\0b\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\10\10\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\0d\01\01\01\01\01\01\01\01\01\01\01\0d\0d\0d\01\01\01\01\01\0d\01\01\01\0d\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\0d\01\01\01\01\0d\01\01\01\01\01\01\01\01\0d\01\01\01\01\0d\0d\01\01\01\0d\0d\0d\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\0d\0d\01\0d\01\01\01\0d\01\0d\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\10\10\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\09\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\0f\10\10\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\04\02\02\04\04\04\04\04\04\02\02\02\04\04\02\02\02\05\02\02\02\02\04\04\02\02\05\05\04\04\02\05\00\05\05\02\05\05\02\02\05\05\05\05\02\02\05\02\05\00\05\05\05\05\05\05\05\00\05\05\05\02\05\05\00\05\00\05\05\00\05\00\00\05\00\05\05\05\05\05\00\00\05\00\05\05\00\00\05\00\05\00\05\00\05\05\00\00\00\00\00\00\05\00\00\00\00\05\05\00\05\00\00\00\05\00\05\00\00\00\00\00\00\00\00\00\00\05\00\00\00\05\00\00\00\00\00\00\05\00\00\00\05\00\00\00\00\00\00\05\00\00\00\05\00\05\00\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\10\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\05\05\00\00\00\00\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\00\00\05\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") (data (i32.const 1803) "\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\06\06\06\06\06\00\00\00\00\00\00\00\00\00\06\06\07\06\06\06\06\06\00\00\00\06\00\00\00\00\06\07\06\06\04\04\04\04\00\00\07\06\00\00\00\00\06\07\06\04\0f\0f\0f\0f\00\00\07\06\00\00\00\00\06\06\06\04\0f\09\0f\0f\00\00\07\06\00\00\00\00\06\06\06\04\0f\0f\0f\0f\00\00\07\06\00\00\00\00\00\06\06\0f\0f\0f\0f\0f\00\00\07\06\00\00\00\00\0d\0d\06\06\06\06\0d\0d\00\00\07\06\00\00\00\00\0d\0d\0d\0d\0d\0d\0d\0d\00\06\06\06\06\00\00\00\05\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\05\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\05\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\00\00\00\00\00\06\06\06\00\00\06\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\0c\0c\0c\00\00\00\00\00\00\00\00\00\00\00\00\0c\0c\0c\0c\00\00\00\00\00\00\00\00\00\00\00\00\06\06\06\06\00\00\00\00\00\00\00\00\00\00\06\00\00\06\06\00\00\06\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\06\06\00\00\00\06\06\07\06\06\06\06\06\00\00\00\00\06\06\00\00\06\07\06\06\04\04\04\06\00\04\04\06\06\06\00\00\06\07\06\04\0f\0f\04\06\00\06\06\06\06\06\00\00\06\06\06\04\0f\09\0f\04\00\06\06\06\06\06\00\00\06\06\06\04\0f\0f\0f\0f\00\04\04\06\06\06\00\0d\0d\06\06\0f\0f\0f\0f\0f\0d\04\04\00\06\06\00\0d\0d\0d\06\06\06\06\0d\0d\0d\04\04\06\06\00\00\0d\0d\0d\0d\0d\0d\0d\0d\0d\0d\04\04\00\00\00\00\00\05\05\0d\05\05\05\0d\05\05\04\04\00\00\00\00\00\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\00\05\05\05\05\05\05\05\05\05\04\04\00\00\00\00\00\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\00\00\00\00\00\06\06\06\00\00\06\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\06\00\00\00\00\00\00\06\00\00\00\00\07\00\00\07\06\00\00\07\00\00\07\06\00\00\00\00\06\00\07\06\06\06\00\06\00\00\07\06\00\00\00\00\06\06\06\06\06\06\06\06\00\00\07\06\00\00\00\00\06\06\07\06\06\06\06\06\00\00\07\06\00\00\00\00\06\07\06\06\04\04\04\06\00\00\07\06\00\00\00\00\06\07\06\04\0f\0f\04\06\00\00\07\06\00\00\00\00\06\06\06\04\0f\09\0f\04\00\00\07\06\00\00\00\00\06\06\06\04\0f\0f\0f\0f\00\00\07\06\00\00\00\0d\0d\06\06\0f\0f\0f\0f\0f\0d\00\07\06\00\00\00\0d\0d\0d\06\06\06\06\0d\0d\0d\00\07\06\00\00\00\0d\0d\0d\0d\0d\0d\0d\0d\0d\06\00\07\06\00\06\00\0c\05\05\0d\0d\0d\0d\0d\05\06\06\06\06\06\06\00\0c\05\0d\05\0d\0d\0d\05\0d\05\05\06\07\00\00\00\0c\05\05\0d\05\0d\05\0d\05\05\05\07\06\00\00\00\0c\05\05\05\05\05\05\05\05\0c\00\06\07\00\00\00\0c\06\06\06\06\06\06\06\06\0c\00\00\00\00\00\00\0c\06\06\06\0c\0c\06\06\06\0c\00\00\00\00\00\00\0c\06\06\0c\0c\0c\0c\06\06\0c\00\00\00\00\00\00\0c\06\06\0c\0c\0c\0c\06\06\0c\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\06\06\06\06\06\00\00\00\00\00\06\00\00\00\06\06\06\06\06\07\06\06\00\00\00\00\06\07\00\00\04\04\04\04\06\06\07\06\00\00\00\00\06\07\00\00\0f\0f\0f\0f\04\06\07\06\00\00\00\00\06\07\00\00\0f\0f\09\0f\04\06\06\06\00\00\00\00\06\07\00\00\0f\0f\0f\0f\04\06\06\06\00\00\00\00\06\07\00\00\0f\0f\0f\0f\0f\06\06\00\00\00\00\00\06\07\00\00\0d\0d\06\06\06\06\0d\0d\00\00\00\06\06\06\06\00\0d\0d\0d\0d\0d\0d\0d\0d\00\00\00\00\04\04\05\05\05\05\05\05\05\05\05\05\00\00\00\00\04\04\05\05\05\05\05\05\05\05\05\05\00\00\00\00\04\04\05\05\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\00\00\00\00\00\06\06\06\00\00\06\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\08\08\08\00\00\00\00\00\00\00\00\00\00\00\00\08\08\08\08\00\00\00\00\00\00\00\00\00\00\00\00\06\06\06\06\00\00\00\00\00\00\00\00\00\00\06\00\00\06\06\00\00\06\00\00\00\06\06\00\00\00\06\06\06\06\06\06\06\06\00\00\06\06\00\00\00\00\06\06\06\06\06\07\06\06\00\00\06\06\06\04\04\00\06\04\04\04\06\06\07\06\00\00\06\06\06\06\06\00\06\04\0f\0f\04\06\07\06\00\00\06\06\06\06\06\00\04\0f\09\0f\04\06\06\06\00\00\06\06\06\04\04\00\0f\0f\0f\0f\04\06\06\06\00\00\06\06\00\04\04\0d\0f\0f\0f\0f\0f\06\06\0d\0d\00\00\06\06\04\04\0d\0d\0d\06\06\06\06\0d\0d\0d\00\00\00\00\04\04\0d\0d\0d\0d\0d\0d\0d\0d\0d\0d\00\00\00\00\04\04\05\05\0d\05\05\05\0d\05\05\00\00\00\00\00\04\04\05\05\05\05\05\05\05\05\05\00\00\00\00\00\04\04\05\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\05\05\05\05\05\05\05\05\00\00\00\00\00\00\00\00\06\06\06\06\06\06\06\06\00\00\00\00\00\00\00\00\06\06\06\00\00\06\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\20\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\06\06\00\00\00\00\00\00\00\06\00\00\00\00\00\00\06\06\00\00\00\00\00\00\00\06\07\00\00\07\00\00\06\07\00\00\07\00\00\00\00\06\07\00\00\06\00\06\06\06\07\00\06\00\00\00\00\06\07\00\00\06\06\06\06\06\06\06\06\00\00\00\00\06\07\00\00\06\06\06\06\06\07\06\06\00\00\00\00\06\07\00\00\06\04\04\04\06\06\07\06\00\00\00\00\06\07\00\00\06\04\0f\0f\04\06\07\06\00\00\00\00\06\07\00\00\04\0f\09\0f\04\06\06\06\00\00\00\00\06\07\00\00\0f\0f\0f\0f\04\06\06\06\00\00\00\00\06\07\00\0d\0f\0f\0f\0f\0f\06\06\0d\0d\00\00\00\06\07\00\0d\0d\0d\06\06\06\06\0d\0d\0d\00\06\00\06\07\00\06\0d\0d\0d\0d\0d\0d\0d\0d\0d\00\06\06\06\06\06\06\05\0d\0d\0d\0d\0d\05\05\08\00\00\00\07\06\05\05\0d\05\0d\0d\0d\05\0d\05\08\00\00\00\06\07\05\05\05\0d\05\0d\05\0d\05\05\08\00\00\00\07\06\00\08\05\05\05\05\05\05\05\05\08\00\00\00\00\00\00\08\06\06\06\06\06\06\06\06\08\00\00\00\00\00\00\08\06\06\06\08\08\06\06\06\08\00\00\00\00\00\00\08\06\06\08\08\08\08\06\06\08\00\00\00\00\00\00\08\06\06\08\08\08\08\06\06\08\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\06\06\00\00\00\00\06\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") (data (i32.const 4887) "\14\0a\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\07\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\14\0a\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\07\07\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07\00\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\07\00\14\0a\0e\0e\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\0e\0e\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\0e\00\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\00\0e\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\14\0a\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\0e\00\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\0e\00\0e\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\0e\0e\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\0e\0e\10\10\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\0e\0e\0e\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\0e\00\00\0e\0e\00\00\0e\00\00\00\00\00\00\00\0e\00\00\0e\0e\0e\0e\00\00\0e\00\00\00\00\00\00\0e\00\0e\0e\0e\0e\0e\0e\00\0e\00\00\00\00\00\00\0e\00\0e\0e\0e\0e\0e\0e\00\0e\00\00\00\00\00\00\0e\00\00\0e\0e\0e\0e\00\00\0e\00\00\00\00\00\00\00\0e\00\00\0e\0e\00\00\0e\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\0e\0e\0e\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") (data (i32.const 6500) "\08\08\00\00\00\07\07\00\00\00\00\00\07\0c\0c\07\00\00\00\07\0c\0c\0c\0c\07\00\07\0c\0c\0c\0c\0c\0c\07\07\07\07\0c\0c\07\07\07\00\00\07\0c\0c\07\00\00\00\00\07\0c\0c\07\00\00\00\00\07\07\07\07\00\00\08\08\07\04\07\00\00\00\00\00\07\04\07\00\00\00\00\00\07\04\07\00\00\00\00\00\07\04\04\07\07\00\00\00\07\04\04\04\04\07\07\00\07\04\04\04\04\04\04\07\07\04\04\04\04\04\04\07\07\07\07\07\07\07\07\00\08\08\00\00\00\00\00\00\07\06\00\00\00\00\00\07\06\06\00\00\00\00\07\06\06\00\06\00\00\07\06\06\00\00\00\06\06\06\06\00\00\00\00\04\06\06\00\00\00\00\04\04\04\06\00\00\00\00\04\04\00\00\06\00\00\00\08\08\08\08\00\00\00\00\08\08\08\08\08\00\00\08\08\08\00\08\08\08\08\08\08\00\00\00\08\08\08\08\00\00\00\00\08\08\08\08\00\00\00\08\08\08\08\08\08\00\08\08\08\00\00\08\08\08\08\08\00\00\00\00\08\08\08\08\00\04\04\04\04\04\04\00\00\04\00\00\00\00\04\00\00\00\04\00\00\04\00\00\00\00\00\04\04\00\00\00\00\00\04\00\00\04\00\00\00\00\04\0f\0f\04\00\00\00\04\0f\0f\0f\0f\04\00\00\04\04\04\04\04\04\00") (data (i32.const 7189) "\02\02\02\02\02\02\02\02\02\03\02\00\00\00\00\00\00\02\02\02\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\02\01\01\00\00\00\00\00\00\00\00\00\00\02\02\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\01\01\01\00\00\00\00\00\03\03\00\00\01\01\01\01\01\02\02\00\03\04\04\00\01\01\01\01\01\01\01\01\02\04\42\01\4e\00\51\00\68\00\ff\ff\33\00\4a\02\58\01\59\01\67\00\ff\ff") (data (i32.const 8192) "\00\42\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\00\ff\ff\ff\ff") (data (i32.const 10240) "\00"))