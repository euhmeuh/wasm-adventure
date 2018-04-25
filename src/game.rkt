#lang s-exp "wat.rkt"

(import "console" "log" (log pos len))
(import "console" "lognum" (log-num i))

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'tile-size 258
  'key-up 0
  'key-down 1
  'key-left 2
  'key-right 3
  'key-a 4
  'key-b 5
  'board-offset-x 6
  'board-offset-y 22
  'board-width 13
  'board-height 11
  'no-selection #xFF
  'max-units 143
  'player-unit 1
  'ennemy-unit 2
  'move-pile-len 8)

(data
  '(width 0 0)
  '(height 4 0)
  '(palette 8 (memstring 3
     start       ;; Pico8 palette
     transparent #x000000
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
     peach       #xFFCCAA
     black       #x000000))
  '(messages 256 "Hello world!")
  '(tiles 512 (memstring 1
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
  '(units 2048 (memstring 1
     soldier0 16 32
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
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  6  6  6  6  6  6  0  0  0  0  0  0  0
      0  0  6  6  7  6  6  6  6  6  0  0  0  6  0  0
      0  0  6  7  6  6  4  4  4  4  0  0  7  6  0  0
      0  0  6  7  6  4 15 15 15 15  0  0  7  6  0  0
      0  0  6  6  6  4 15  9 15 15  0  0  7  6  0  0
      0  0  6  6  6  4 15 15 15 15  0  0  7  6  0  0
      0  0  0  6  6 15 15 15 15 15  0  0  7  6  0  0
      0  0 13 13  6  6  6  6 13 13  0  0  7  6  0  0
      0  0 13 13 13 13 13 13 13 13  0  6  6  6  6  0
      0  0  5  5  5  5  5  5  5  5  5  5  4  4  0  0
      0  0  5  5  5  5  5  5  5  5  5  5  4  4  0  0
      0  0  5  5  5  5  5  5  5  5  5  5  4  4  0  0
      0  0  5  5  5  5  5  5  5  5  0  0  0  0  0  0
      0  0  6  6  6  6  6  6  6  6  0  0  0  0  0  0
      0  0  6  6  6  0  0  6  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
    soldier1 16 32
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0 12 12 12 12  0  0  0  0  0  0  0  0
      0  0  0  0 12 12 12 12  0  0  0  0  0  0  0  0
      0  0  0  0  6  6  6  6  0  0  0  0  0  0  0  0
      0  0  6  0  0  6  6  0  0  6  0  0  0  0  0  0
      0  0  6  6  6  6  6  6  6  6  0  0  0  6  6  0
      0  0  6  6  7  6  6  6  6  6  0  0  0  0  6  6
      0  0  6  7  6  6  4  4  4  6  0  4  4  6  6  6
      0  0  6  7  6  4 15 15  4  6  0  6  6  6  6  6
      0  0  6  6  6  4 15  9 15  4  0  6  6  6  6  6
      0  0  6  6  6  4 15 15 15 15  0  4  4  6  6  6
      0 13 13  6  6 15 15 15 15 15 13  4  4  0  6  6
      0 13 13 13  6  6  6  6 13 13 13  4  4  6  6  0
      0 13 13 13 13 13 13 13 13 13 13  4  4  0  0  0
      0  0  5  5 13  5  5  5 13  5  5  4  4  0  0  0
      0  0  5  5  5  5  5  5  5  5  5  4  4  0  0  0
      0  0  5  5  5  5  5  5  5  5  5  4  4  0  0  0
      0  0  5  5  5  5  5  5  5  5  0  0  0  0  0  0
      0  0  6  6  6  6  6  6  6  6  0  0  0  0  0  0
      0  0  6  6  6  0  0  6  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ))
  '(ui 5120 (memstring 1
     cursor-top 20 10
      0  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  0
      7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7
      7  0  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
    cursor-bot 20 10
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7  0  7
      7  0  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  0  7
      7  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  7
      0  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  0
     cursor-top-selected 20 10
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
    cursor-bot-selected 20 10
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14  0  0
      0  0 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
    move 16 16
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0 14 14 14 14  0  0  0  0  0  0
      0  0  0  0  0 14  0  0  0  0 14  0  0  0  0  0
      0  0  0  0 14  0  0 14 14  0  0 14  0  0  0  0
      0  0  0 14  0  0 14 14 14 14  0  0 14  0  0  0
      0  0  0 14  0 14 14 14 14 14 14  0 14  0  0  0
      0  0  0 14  0 14 14 14 14 14 14  0 14  0  0  0
      0  0  0 14  0  0 14 14 14 14  0  0 14  0  0  0
      0  0  0  0 14  0  0 14 14  0  0 14  0  0  0  0
      0  0  0  0  0 14  0  0  0  0 14  0  0  0  0  0
      0  0  0  0  0  0 14 14 14 14  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ))
  '(levels 7189 (memstring 1
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
     level1-player-units
     66 1 78 0 81 0 104 0 #xFF #xFF
     level1-ennemy-units
     51 0 74 2 88 1 89 1 104 0 #xFF #xFF
     ))
  '(game 8192 (memstring 1
     coins 0
     level 0
     cursor-pos 66
     selection #xFF
     move-pile #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF))
  '(screen 10240 0))

(func fill-pixels (pos len step color)
  (for pos len step
    (call 'pixel pos color)))

(func fill-row (row color)
  ;;; fill a full row of the screen with the given color
  (locals i len)
  (set-local i (* (load (mem 'width)) row))
  (set-local len (+ (load (mem 'width)) i))
  (call 'fill-pixels i len 1 color))

(func fill-col (col color)
  ;;; fill a full column of the screen with the given color
  (locals len)
  (set-local len (* (load (mem 'width)) (load (mem 'height))))
  (call 'fill-pixels col len (load (mem 'width)) color))

(func fill-screen (color)
  ;;; fill the whole screen with a color
  (call 'fill-pixels 0 (* (load (mem 'width)) (load (mem 'height))) 1 color))

(func pixel (pos color)
  ;;; draw a pixel at the given position in memory with the given color
  (locals cursor) ;; write position in memory

  (if (!= color (mem 'palette 'transparent))
    (set-local cursor (+ (mem 'screen) (* pos 4))) ;; 4 is pixel size
    ;; red component
    (store-byte cursor (load-byte color))
    ;; green component
    (store-byte (+ cursor 1) (load-byte (+ color 1)))
    ;; blue component
    (store-byte (+ cursor 2) (load-byte (+ color 2)))
    ;; alpha
    (store-byte (+ cursor 3) #xFF)))

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

;; get tile x position on screen based on the tile index
(func tile-x (i) =>
  (return (+ (const 'board-offset-x) (* (% i (const 'board-width)) 16))))

;; get tile y position on screen based on the tile index
(func tile-y (i) =>
  (return (+ (const 'board-offset-y) (* (/ i (const 'board-width)) 16))))

(func row-up (pos) =>
  (return (- pos (const 'board-width))))

(func row-down (pos) =>
  (return (+ pos (const 'board-width))))

(func show-level (level)
  (locals i tile)
  (set-local i 0)
  (set-local tile 0)
  (for i (* (const 'board-width) (const 'board-height)) 1
    (set-local tile (load-byte (+ level i)))
    (call 'sprite (call 'tile-x i)
                  (call 'tile-y i)
                  (+ (mem 'tiles 'start) (* (const 'tile-size) tile)))))

(func show-units (unit-list)
  (locals i pos level)
  (set-local i 0)
  (for i (* 2 (const 'max-units)) 2
    (set-local pos (load-byte (+ unit-list i)))
    (set-local level (load-byte (+ unit-list (+ 1 i))))
    (if (= pos #xFF) (break))
    (call 'sprite (call 'tile-x pos)
                  (call 'tile-y (call 'row-up pos))
                  (mem 'units 'soldier0))))

(func show-cursor-top ()
  (locals pos)
  (set-local pos (load-byte (mem 'game 'cursor-pos)))
  (call 'sprite (- (call 'tile-x pos) 2)
                (- (call 'tile-y pos) 2)
                (if (call 'has-selection?) =>
                  (then (mem 'ui 'cursor-top-selected))
                  (else (mem 'ui 'cursor-top)))))

(func show-cursor-bot ()
  (locals pos)
  (set-local pos (load-byte (mem 'game 'cursor-pos)))
  (call 'sprite (- (call 'tile-x pos) 2)
                (+ (call 'tile-y pos) 8)
                (if (call 'has-selection?) =>
                  (then (mem 'ui 'cursor-bot-selected))
                  (else (mem 'ui 'cursor-bot)))))

(func show-path ()
  (locals i move)
  (set-local i 0)
  (for i (const 'move-pile-len) 1
    (set-local move (load-byte (+ (mem 'game 'move-pile) i)))
    (if (= move #xFF) (break))
    (call 'sprite (call 'tile-x move)
                  (call 'tile-y move)
                  (mem 'ui 'move))))

(func move-cursor-up ()
  (locals pos)
  (set-local pos (call 'row-up (load-byte (mem 'game 'cursor-pos))))
  (store-byte (mem 'game 'cursor-pos) pos)
  (call 'update-move-pile pos))

(func move-cursor-down ()
  (locals pos)
  (set-local pos (call 'row-down (load-byte (mem 'game 'cursor-pos))))
  (store-byte (mem 'game 'cursor-pos) pos)
  (call 'update-move-pile pos))

(func move-cursor-left ()
  (locals pos)
  (set-local pos (- (load-byte (mem 'game 'cursor-pos)) 1))
  (store-byte (mem 'game 'cursor-pos) pos)
  (call 'update-move-pile pos))

(func move-cursor-right ()
  (locals pos)
  (set-local pos (+ (load-byte (mem 'game 'cursor-pos)) 1))
  (store-byte (mem 'game 'cursor-pos) pos)
  (call 'update-move-pile pos))

(func update-move-pile (pos)
  (locals i move erase-mode)
  (set-local i 0)
  (set-local erase-mode 0)
  (if (call 'has-selection?)
    (for i (const 'move-pile-len) 1
      (if erase-mode
        (then ;; we erase until the end of the pile
          (store-byte (+ (mem 'game 'move-pile) i) #xFF))
        (else
          (set-local move (load-byte (+ (mem 'game 'move-pile) i)))
          (if (= move #xFF) ;; we can add to the pile
            (store-byte (+ (mem 'game 'move-pile) i) pos)
            (break))
          (if (= move pos) ;; we went back to an already visited tile
            (set-local erase-mode 1)))))))

(func has-selection? () =>
  (return (!= (load-byte (mem 'game 'selection))
              (const 'no-selection))))

(func is-selection? (pos) =>
  (return (= pos (load-byte (mem 'game 'selection)))))

(func current-level () =>
  ;;(locals level)
  ;;(set-local level (load-byte (mem 'game 'level)))
  (return (mem 'levels 'level1)))

(func current-level-units () =>
  (return (+ (call 'current-level)
             (* (const 'board-width) (const 'board-height)))))

(func is-unit? (pos) =>
  (locals i units unit ennemy? result)
  (set-local i 0)
  (set-local result 0)
  (set-local ennemy? 0)
  (set-local units (call 'current-level-units))
  (for i (* 2 (const 'max-units)) 2
    (set-local unit (load-byte (+ units i)))
    (if (= unit pos)
      (set-local result (if ennemy? =>
                          (then (const 'ennemy-unit))
                          (else (const 'player-unit))))
      (break))
    (if (and (= unit #xFF) ennemy?)
      ;; we finished scanning everything
      (break))
    (if (and (= unit #xFF) (not ennemy?))
      ;; we finished scanning player units
      ;; so the following units will be ennemies
      (set-local ennemy? 1)))
  (return result))

(func is-player-unit? (pos) =>
  (return (= (call 'is-unit? pos) (const 'player-unit))))

(func is-ennemy-unit? (pos) =>
  (return (= (call 'is-unit? pos) (const 'ennemy-unit))))

(func is-blocking-tile? (pos) =>
  (locals tile)
  (set-local tile (load-byte (+ (call 'current-level) pos)))
  (return (or (= tile 1) ;; water
              (or (= tile 3) ;; pit
                  (= tile 4)) ;; pit 2
              )))

;; check if the cursor is too far from the selection or not
(func within-distance? (max) =>
  (return (= (load-byte (+ (mem 'game 'move-pile) max))
             #xFF)))

(func enter ()
  (locals pos)
  (set-local pos (load-byte (mem 'game 'cursor-pos)))
  (if (call 'has-selection?)
    (then
      (if (call 'is-unit? pos)
        (then
          (if (call 'is-selection? pos)
            (then (call 'upgrade))
            (else (if (and (call 'is-ennemy-unit? pos)
                           (call 'within-distance? 1))
                    (call 'attack pos)))))
        (else
          (if (and (not (call 'is-blocking-tile? pos))
                   (call 'within-distance? 3))
            (call 'move pos)))))
    (else
      (if (call 'is-player-unit? pos)
        (call 'select pos)))))

(func select (pos)
  (store-byte (mem 'game 'selection) pos))

(func cancel ()
  (store-byte (mem 'game 'selection) (const 'no-selection))
  ;; reset move-pile
  (store (mem 'game 'move-pile) #xFFFFFFFF)
  (store (+ 4 (mem 'game 'move-pile)) #xFFFFFFFF))

(func move (pos)
  (call 'log-num 1010))

(func attack (pos)
  (call 'log-num 6666))

(func upgrade ()
  (call 'log-num 1234))

(func hello ()
  (call 'log (mem 'messages) 12))

(func render ()
  (call 'fill-screen (mem 'palette 'black))
  (call 'show-level (mem 'levels 'level1))
  (call 'show-cursor-top)
  (call 'show-units (mem 'levels 'level1-player-units))
  (call 'show-units (mem 'levels 'level1-ennemy-units))
  (call 'show-cursor-bot)
  (call 'show-path))

(func keydown (key)
  (if (= key (const 'key-up))
    (call 'move-cursor-up))
  (if (= key (const 'key-down))
    (call 'move-cursor-down))
  (if (= key (const 'key-left))
    (call 'move-cursor-left))
  (if (= key (const 'key-right))
    (call 'move-cursor-right))
  (if (= key (const 'key-a))
    (call 'enter))
  (if (= key (const 'key-b))
    (call 'cancel)))

;;(func update (delta)
;;  todo)

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "keydown" (func $keydown))
;;(export "update" (func $update))
(export "hello" (func $hello))
