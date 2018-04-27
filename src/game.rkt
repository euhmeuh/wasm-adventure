#lang s-exp "wat.rkt"

(import "console" "log" (log pos len))
(import "console" "lognum" (log-num i))

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'tile-size 258
  'soldier-size 514
  'action-size 66
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
  'board-size 143
  'no-selection #xFF
  'player-unit 1
  'ennemy-unit 2
  'move-pile-len 8
  'action-upgrade 0
  'action-move 1
  'action-attack 2
  'action-blocked 3
  'action-wait 4
  'action-select 5
  'action-none #xFF
  'player-turn 0
  'ennemy-turn 1)

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
  '(units 1803 (memstring 1
     start
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
     soldier2 16 32
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  7  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  7  6  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  6  6  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  6  6  0  0  0  0  0  0  6  0  0
      0  0  7  0  0  7  6  0  0  7  0  0  7  6  0  0
      0  0  6  0  7  6  6  6  0  6  0  0  7  6  0  0
      0  0  6  6  6  6  6  6  6  6  0  0  7  6  0  0
      0  0  6  6  7  6  6  6  6  6  0  0  7  6  0  0
      0  0  6  7  6  6  4  4  4  6  0  0  7  6  0  0
      0  0  6  7  6  4 15 15  4  6  0  0  7  6  0  0
      0  0  6  6  6  4 15  9 15  4  0  0  7  6  0  0
      0  0  6  6  6  4 15 15 15 15  0  0  7  6  0  0
      0 13 13  6  6 15 15 15 15 15 13  0  7  6  0  0
      0 13 13 13  6  6  6  6 13 13 13  0  7  6  0  0
      0 13 13 13 13 13 13 13 13 13  6  0  7  6  0  6
      0 12  5  5 13 13 13 13 13  5  6  6  6  6  6  6
      0 12  5 13  5 13 13 13  5  13 5  5  6  7  0  0
      0 12  5  5 13  5 13  5 13  5  5  5  7  6  0  0
      0 12  5  5  5  5  5  5  5  5 12  0  6  7  0  0
      0 12  6  6  6  6  6  6  6  6 12  0  0  0  0  0
      0 12  6  6  6 12 12  6  6  6 12  0  0  0  0  0
      0 12  6  6 12 12 12 12  6  6 12  0  0  0  0  0
      0 12  6  6 12 12 12 12  6  6 12  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  6  6  0  0  0  0  6  6  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ennemy0 16 32
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
      0  0  0  0  0  0  0  6  6  6  6  6  6  0  0  0
      0  0  6  0  0  0  6  6  6  6  6  7  6  6  0  0
      0  0  6  7  0  0  4  4  4  4  6  6  7  6  0  0
      0  0  6  7  0  0 15 15 15 15  4  6  7  6  0  0
      0  0  6  7  0  0 15 15  9 15  4  6  6  6  0  0
      0  0  6  7  0  0 15 15 15 15  4  6  6  6  0  0
      0  0  6  7  0  0 15 15 15 15 15  6  6  0  0  0
      0  0  6  7  0  0 13 13  6  6  6  6 13 13  0  0
      0  6  6  6  6  0 13 13 13 13 13 13 13 13  0  0
      0  0  4  4  5  5  5  5  5  5  5  5  5  5  0  0
      0  0  4  4  5  5  5  5  5  5  5  5  5  5  0  0
      0  0  4  4  5  5  5  5  5  5  5  5  5  5  0  0
      0  0  0  0  0  0  5  5  5  5  5  5  5  5  0  0
      0  0  0  0  0  0  6  6  6  6  6  6  6  6  0  0
      0  0  0  0  0  0  6  6  6  0  0  6  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ennemy1 16 32
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  8  8  8  8  0  0  0  0
      0  0  0  0  0  0  0  0  8  8  8  8  0  0  0  0
      0  0  0  0  0  0  0  0  6  6  6  6  0  0  0  0
      0  0  0  0  0  0  6  0  0  6  6  0  0  6  0  0
      0  6  6  0  0  0  6  6  6  6  6  6  6  6  0  0
      6  6  0  0  0  0  6  6  6  6  6  7  6  6  0  0
      6  6  6  4  4  0  6  4  4  4  6  6  7  6  0  0
      6  6  6  6  6  0  6  4 15 15  4  6  7  6  0  0
      6  6  6  6  6  0  4 15  9 15  4  6  6  6  0  0
      6  6  6  4  4  0 15 15 15 15  4  6  6  6  0  0
      6  6  0  4  4 13 15 15 15 15 15  6  6 13 13  0
      0  6  6  4  4 13 13 13  6  6  6  6 13 13 13  0
      0  0  0  4  4 13 13 13 13 13 13 13 13 13 13  0
      0  0  0  4  4  5  5 13  5  5  5 13  5  5  0  0
      0  0  0  4  4  5  5  5  5  5  5  5  5  5  0  0
      0  0  0  4  4  5  5  5  5  5  5  5  5  5  0  0
      0  0  0  0  0  0  5  5  5  5  5  5  5  5  0  0
      0  0  0  0  0  0  6  6  6  6  6  6  6  6  0  0
      0  0  0  0  0  0  6  6  6  0  0  6  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ennemy2 16 32
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  7  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  6  7  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  6  6  0  0  0  0  0
      0  0  6  0  0  0  0  0  0  6  6  0  0  0  0  0
      0  0  6  7  0  0  7  0  0  6  7  0  0  7  0  0
      0  0  6  7  0  0  6  0  6  6  6  7  0  6  0  0
      0  0  6  7  0  0  6  6  6  6  6  6  6  6  0  0
      0  0  6  7  0  0  6  6  6  6  6  7  6  6  0  0
      0  0  6  7  0  0  6  4  4  4  6  6  7  6  0  0
      0  0  6  7  0  0  6  4 15 15  4  6  7  6  0  0
      0  0  6  7  0  0  4 15  9 15  4  6  6  6  0  0
      0  0  6  7  0  0 15 15 15 15  4  6  6  6  0  0
      0  0  6  7  0 13 15 15 15 15 15  6  6 13 13  0
      0  0  6  7  0 13 13 13  6  6  6  6 13 13 13  0
      6  0  6  7  0  6 13 13 13 13 13 13 13 13 13  0
      6  6  6  6  6  6  5 13 13 13 13 13  5  5  8  0
      0  0  7  6  5  5 13  5 13 13 13  5 13  5  8  0
      0  0  6  7  5  5  5 13  5 13  5 13  5  5  8  0
      0  0  7  6  0  8  5  5  5  5  5  5  5  5  8  0
      0  0  0  0  0  8  6  6  6  6  6  6  6  6  8  0
      0  0  0  0  0  8  6  6  6  8  8  6  6  6  8  0
      0  0  0  0  0  8  6  6  8  8  8  8  6  6  8  0
      0  0  0  0  0  8  6  6  8  8  8  8  6  6  8  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  6  6  0  0  0  0  6  6  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
      0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
     ))
  '(ui 4887 (memstring 1
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
     14 14 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14 14 14
     14  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14
     14  0 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14  0 14
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
     14  0 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14  0 14
     14  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14
     14 14 14  0  0  0  0  0  0  0  0  0  0  0  0  0  0 14 14 14
     move-indicator 16 16
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
  '(actions 6500 (memstring 1
     start
     upgrade 8 8
      0  0  0  7  7  0  0  0
      0  0  7 12 12  7  0  0
      0  7 12 12 12 12  7  0
      7 12 12 12 12 12 12  7
      7  7  7 12 12  7  7  7
      0  0  7 12 12  7  0  0
      0  0  7 12 12  7  0  0
      0  0  7  7  7  7  0  0
     move 8 8
      7  4  7  0  0  0  0  0
      7  4  7  0  0  0  0  0
      7  4  7  0  0  0  0  0
      7  4  4  7  7  0  0  0
      7  4  4  4  4  7  7  0
      7  4  4  4  4  4  4  7
      7  4  4  4  4  4  4  7
      7  7  7  7  7  7  7  0
     attack 8 8
      0  0  0  0  0  0  7  6
      0  0  0  0  0  7  6  6
      0  0  0  0  7  6  6  0
      6  0  0  7  6  6  0  0
      0  6  6  6  6  0  0  0
      0  4  6  6  0  0  0  0
      4  4  4  6  0  0  0  0
      4  4  0  0  6  0  0  0
     blocked 8 8
      8  8  0  0  0  0  8  8
      8  8  8  0  0  8  8  8
      0  8  8  8  8  8  8  0
      0  0  8  8  8  8  0  0
      0  0  8  8  8  8  0  0
      0  8  8  8  8  8  8  0
      8  8  8  0  0  8  8  8
      8  8  0  0  0  0  8  8
     wait 8 8
      0  7  7  7  7  7  7  0
      0  7  0  0  0  0  7  0
      0  0  7  0  0  7  0  0
      0  0  0  7  7  0  0  0
      0  0  7  0  0  7  0  0
      0  0  7 12 12  7  0  0
      0  7 12 12 12 12  7  0
      0  7  7  7  7  7  7  0
     ))
  '(levels 7189 (memstring 1
     level0
     ;; grass 0
     ;; water 1
     ;; sand 2
     ;; pit 3, 4
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
     ;; player units
     66 1 78 0 81 0 104 0 #xFF #xFF
     ;; ennemy units
     51 0 74 2 88 1 89 1 103 0 #xFF #xFF
     ))
  '(game 8192 (memstring 1
     turn 0
     coins 10
     cursor-pos 66
     selection #xFF
     move-pile #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF
     current-action #xFF
     current-level 0
     current-units #xFF #xFF #xFF #xFF))
  '(screen 10240 0))

;; ============================================================================
;;                               GRAPHICS ENGINE
;; ============================================================================

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
  '(drop)
  ;; load first level
  (call 'load-level (mem 'levels 'level0)))

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

;; ============================================================================
;;                                   DISPLAY
;; ============================================================================

(func show-level (level)
  (locals i tile)
  (set-local i 0)
  (set-local tile 0)
  (for i (const 'board-size) 1
    (set-local tile (load-byte (+ level i)))
    (call 'sprite (call 'tile-x i)
                  (call 'tile-y i)
                  (+ (mem 'tiles 'start) (* (const 'tile-size) tile)))))

(func show-current-units ()
  (locals i pos level units ennemy?)
  (set-local i 0)
  (set-local units (mem 'game 'current-units))
  (for i (* 2 (const 'board-size)) 2
    (set-local pos (load-byte (+ units i)))
    (set-local level (load-byte (+ units (+ 1 i))))
    (if (and (= pos #xFF) ennemy?)
      (break))
    (if (and (= pos #xFF) (not ennemy?))
      (set-local ennemy? 1))
    (call 'sprite (call 'tile-x pos)
                  (call 'tile-y (call 'row-up pos))
                  (+ (mem 'units 'start)
                     (* (+ level (* 3 ennemy?))
                        (const 'soldier-size))))))

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
                  (mem 'ui 'move-indicator))))

(func show-action ()
  (locals cursor-pos current-action)
  (set-local current-action (load-byte (mem 'game 'current-action)))
  (if (and (!= current-action (const 'action-none))
           (!= current-action (const 'action-select)))
    (set-local cursor-pos (load-byte (mem 'game 'cursor-pos)))
    (call 'sprite (+ 16 (call 'tile-x cursor-pos))
                  (call 'tile-y (call 'row-down cursor-pos))
                  (+ (mem 'actions 'start)
                     (* current-action (const 'action-size))))))

;; ============================================================================
;;                                   CURSOR
;; ============================================================================

(func move-cursor-up ()
  (locals pos)
  (set-local pos (load-byte (mem 'game 'cursor-pos)))
  (if (>= pos (const 'board-width))
    (set-local pos (call 'row-up pos))
    (store-byte (mem 'game 'cursor-pos) pos)
    (call 'update-move-pile pos)))

(func move-cursor-down ()
  (locals pos)
  (set-local pos (call 'row-down (load-byte (mem 'game 'cursor-pos))))
  (if (< pos (const 'board-size))
    (store-byte (mem 'game 'cursor-pos) pos)
    (call 'update-move-pile pos)))

(func move-cursor-left ()
  (locals pos)
  (set-local pos (load-byte (mem 'game 'cursor-pos)))
  (if (> (% pos (const 'board-width)) 0)
    (set-local pos (- pos 1))
    (store-byte (mem 'game 'cursor-pos) pos)
    (call 'update-move-pile pos)))

(func move-cursor-right ()
  (locals pos)
  (set-local pos (+ (load-byte (mem 'game 'cursor-pos)) 1))
  (if (> (% pos (const 'board-width)) 0)
    (store-byte (mem 'game 'cursor-pos) pos)
    (call 'update-move-pile pos)))

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

;; ============================================================================
;;                             POSSIBLE ACTION
;; ============================================================================

(func update-action ()
  (locals pos)
  (set-local pos (load-byte (mem 'game 'cursor-pos)))
  (if (call 'is-ennemy-turn?)
    (then
      (store-byte (mem 'game 'current-action) (const 'action-wait)))
    (else
      (if (call 'has-selection?)
        (then
          (if (call 'is-unit? pos)
            (then
              (if (call 'is-selection? pos)
                (then (store-byte (mem 'game 'current-action) (const 'action-upgrade)))
                (else (if (and (call 'is-ennemy-unit? pos)
                               (call 'is-within-distance? 1))
                        (then (store-byte (mem 'game 'current-action) (const 'action-attack)))
                        (else (store-byte (mem 'game 'current-action) (const 'action-blocked)))))))
            (else
              (if (and (not (call 'is-blocking-tile? pos))
                       (call 'is-within-distance? 3))
                (then (store-byte (mem 'game 'current-action) (const 'action-move)))
                (else (store-byte (mem 'game 'current-action) (const 'action-blocked)))))))
        (else
          (if (call 'is-player-unit? pos)
            (then (store-byte (mem 'game 'current-action) (const 'action-select)))
            (else (store-byte (mem 'game 'current-action) (const 'action-none)))))))))

;; ============================================================================
;;                                  CHECKS
;; ============================================================================

(func has-selection? () =>
  (return (!= (load-byte (mem 'game 'selection))
              (const 'no-selection))))

(func is-player-turn? () =>
  (return (= (load-byte (mem 'game 'turn)) (const 'player-turn))))

(func is-ennemy-turn? () =>
  (return (= (load-byte (mem 'game 'turn)) (const 'ennemy-turn))))

(func is-selection? (pos) =>
  (return (= pos (load-byte (mem 'game 'selection)))))

(func is-unit? (pos) =>
  (locals i unit ennemy? result)
  (set-local i 0)
  (set-local result 0)
  (set-local ennemy? 0)
  (for i (* 2 (const 'board-size)) 2
    (set-local unit (load-byte (+ (mem 'game 'current-units) i)))
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
  (set-local tile (load-byte (+ (call 'get-current-level) pos)))
  (return (or (= tile 1) ;; water
              (or (= tile 3) ;; pit
                  (= tile 4)) ;; pit 2
              )))

;; check if the cursor is too far from the selection or not
(func is-within-distance? (max) =>
  (return (= (load-byte (+ (mem 'game 'move-pile) max))
             #xFF)))

;; ============================================================================
;;                               COMPLEX GETTERS
;; ============================================================================

(func get-selected-unit () =>
  (locals i addr unit selection result)
  (set-local i 0)
  (set-local result 0)
  (set-local selection (load-byte (mem 'game 'selection)))
  (if (!= selection (const 'no-selection))
    (for i (* 2 (const 'board-size)) 2
      (set-local addr (+ (mem 'game 'current-units) i))
      (set-local unit (load-byte addr))
      (if (= unit selection)
        (set-local result addr)
        (break))
      (if (= unit #xFF) (break))))
  (return result))

(func get-current-level () =>
  ;;(locals level)
  ;;(set-local level (load-byte (mem 'game 'current-level)))
  (return (mem 'levels 'level0)))

(func get-level-units (level) =>
  (return (+ level (const 'board-size))))

;; ============================================================================
;;                                   LOAD
;; ============================================================================

(func load-level (level)
  (locals i units pos lvl ennemy?)
  (set-local i 0)
  (set-local units (call 'get-level-units level))
  (set-local ennemy? 0)
  (for i (* 2 (const 'board-size)) 2
    (set-local pos (load-byte (+ units i)))
    (set-local lvl (load-byte (+ 1 (+ units i))))
    (store-byte (+ i (mem 'game 'current-units)) pos)
    (store-byte (+ 1 (+ i (mem 'game 'current-units))) lvl)
    (if (and (= pos #xFF) ennemy?)
      (break))
    (if (and (= pos #xFF) (not ennemy?))
      (set-local ennemy? 1))))

;; ============================================================================
;;                                GAME LOGIC
;; ============================================================================

(func enter ()
  (locals cursor-pos current-action)
  (set-local cursor-pos (load-byte (mem 'game 'cursor-pos)))
  (set-local current-action (load-byte (mem 'game 'current-action)))
  (if (= current-action (const 'action-select))
    (call 'select cursor-pos))
  (if (= current-action (const 'action-move))
    (call 'move cursor-pos))
  (if (= current-action (const 'action-attack))
    (call 'attack cursor-pos))
  (if (= current-action (const 'action-upgrade))
    (call 'upgrade)))

(func select (pos)
  (store-byte (mem 'game 'selection) pos))

(func cancel ()
  (store-byte (mem 'game 'selection) (const 'no-selection))
  (store-byte (mem 'game 'current-action) (const 'action-none))
  ;; reset move-pile
  (store (mem 'game 'move-pile) #xFFFFFFFF)
  (store (+ 4 (mem 'game 'move-pile)) #xFFFFFFFF))

(func move (pos)
  (store-byte (call 'get-selected-unit) pos)
  (call 'end-player-turn)
  (call 'cancel))

(func attack (pos)
  (call 'log-num 6666))

(func upgrade ()
  (locals coins lvl-addr lvl)
  (set-local coins (load-byte (mem 'game 'coins)))
  (set-local lvl-addr (+ 1 (call 'get-selected-unit)))
  (set-local lvl (load-byte lvl-addr))
  (if (and (> coins 0) (< lvl 2))
    (store-byte lvl-addr (+ 1 lvl))
    (store-byte (mem 'game 'coins) (- coins 1))
    (call 'end-player-turn))
  (call 'cancel))

(func end-player-turn ()
  (store-byte (mem 'game 'turn) (const 'ennemy-turn)))

(func end-ennemy-turn ()
  (store-byte (mem 'game 'turn) (const 'player-turn)))

(func hello ()
  (call 'log (mem 'messages) 12))

(func render ()
  (call 'fill-screen (mem 'palette 'black))
  (call 'show-level (call 'get-current-level))
  (call 'show-cursor-top)
  (call 'show-current-units)
  (call 'show-cursor-bot)
  (call 'show-path)
  (call 'show-action))

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
    (call 'cancel))
  (call 'update-action))

;;(func update (delta)
;;  todo)

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "keydown" (func $keydown))
;;(export "update" (func $update))
(export "hello" (func $hello))
