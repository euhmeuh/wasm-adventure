#lang s-exp "wat.rkt"

(import "console" "log" (log pos len))
(import "console" "lognum" (log-num i))
(import "game" "victory" (victory))
(import "game" "gameover" (game-over))
(import "math" "random" (random-num i) =>)

'(memory 1)

(constants
  'page-size #x10000
  'pixel-size 4
  'color-size 3
  'tile-size 258
  'soldier-size 514
  'action-size 66
  'level-size 175
  'num-size 62
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
  'blue-unit 1
  'red-unit 2
  'max-units-number 16
  'move-pile-len 8
  'ai-moves-len 16
  'action-upgrade 0
  'action-move 1
  'action-attack 2
  'action-blocked 3
  'action-select 4
  'action-none #xFF
  'blue-turn 0
  'red-turn 1
  ;; small unit has few ATK but medium HP
  'small-unit-hp 2
  'small-unit-atk 1
  ;; medium unit has medium ATK but big HP
  'medium-unit-hp 4
  'medium-unit-atk 2
  ;; big unit has a lot of ATK, but few HP
  'big-unit-hp 2
  'big-unit-atk 3
  'number-of-levels 3)

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
  '(message-hello 256 "Hello world!")
  '(message-victory 268 "Victory!")
  '(message-defeat 276 "Defeat!")
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
     blue0 16 32
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
     blue1 16 32
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
     blue2 16 32
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
     red0 16 32
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
      0  0  6  7  0  0 14 14  6  6  6  6 14 14  0  0
      0  6  6  6  6  0 14 14 14 14 14 14 14 14  0  0
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
     red1 16 32
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
      6  6  0  4  4 14 15 15 15 15 15  6  6 14 14  0
      0  6  6  4  4 14 14 14  6  6  6  6 14 14 14  0
      0  0  0  4  4 14 14 14 14 14 14 14 14 14 14  0
      0  0  0  4  4  5  5 14  5  5  5 14  5  5  0  0
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
     red2 16 32
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
      0  0  6  7  0 14 15 15 15 15 15  6  6 14 14  0
      0  0  6  7  0 14 14 14  6  6  6  6 14 14 14  0
      6  0  6  7  0  6 14 14 14 14 14 14 14 14 14  0
      6  6  6  6  6  6  5 14 14 14 14 14  5  5  8  0
      0  0  7  6  5  5 14  5 14 14 14  5 14  5  8  0
      0  0  6  7  5  5  5 14  5 14  5 14  5  5  8  0
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
     coin-icon 8 8
      0  0  7  7  7  7  0  0
      0  7 10 10 10 10  7  0
      7 10  7 10 10  7 10  7
      7 10 10  0  0  7 10  7
      7 10 10  0  0  7 10  7
      7 10  7  7  7  7 10  7
      0  7 10 10 10 10  7  0
      0  0  7  7  7  7  0  0
     level-icon 8 8
      7  7  7  0  0  7  7  7
      7  5  7  7  7  7  5  7
      7  5  5  5  5  5  5  7
      7  6  6  6  6  6  6  7
      7  6  6  5  5  6  6  7
      7  6  5  4  4  5  6  7
      7  6  5  4  4  5  6  7
      7  7  7  7  7  7  7  7
     numbers
     num0 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
     num1 6 10
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
      0 0 7 7 0 0
     num2 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 0 0
      7 7 0 0 0 0
      7 7 7 7 7 7
      7 7 7 7 7 7
     num3 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
     num4 6 10
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
     num5 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 0 0
      7 7 0 0 0 0
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
     num6 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 0 0
      7 7 0 0 0 0
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
     num7 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
     num8 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
     num9 6 10
      7 7 7 7 7 7
      7 7 7 7 7 7
      7 7 0 0 7 7
      7 7 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
      0 0 0 0 7 7
      0 0 0 0 7 7
      7 7 7 7 7 7
      7 7 7 7 7 7
     ))
  '(actions 6772 (memstring 1
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
     ))
  '(levels 7189 (memstring 1
     start
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
     0 3 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 1 1 1 1 0 0 0 0 0
     3 3 0 0 1 1 1 1 1 2 2 0 3
     4 4 0 1 1 1 1 1 1 1 1 2 4
     ;; blue units
     66 1 78 0 81 0 104 0 #xFFFF #xFFFF #xFFFF #xFFFF
     ;; red units
     51 0 74 2 88 1 89 1 103 0 #xFFFF #xFFFF #xFFFF

     level1
     0 0 0 2 2 2 0 0 0 0 2 3 3
     0 0 2 0 2 2 0 0 0 0 2 4 4
     0 2 0 2 0 2 2 0 0 0 0 0 0
     0 0 0 0 0 1 2 2 0 0 0 0 0
     0 0 0 0 0 1 1 1 1 0 0 0 0
     0 0 0 0 0 1 1 1 2 0 0 0 0
     0 0 0 0 0 0 1 2 0 0 0 0 0
     0 0 0 0 0 0 2 0 0 0 0 0 0
     0 0 0 0 0 0 1 1 2 0 0 0 0
     0 3 3 3 0 1 1 1 2 2 0 0 0
     0 4 4 4 3 1 1 2 2 0 2 2 2
     ;; blue units
     66 1 80 0 #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF
     ;; red units
     51 0 77 1 #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF

     level2
     3 3 0 0 0 0 0 0 0 0 0 0 3
     4 0 0 0 0 2 2 0 0 0 0 0 4
     0 0 0 0 0 1 1 2 2 2 0 0 0
     0 0 2 2 0 1 1 1 1 1 2 0 0
     0 0 2 1 0 0 1 1 1 1 1 2 0
     0 0 1 1 1 2 1 1 1 1 1 2 0
     0 0 1 1 1 2 2 2 1 1 2 0 0
     0 0 1 1 1 1 1 0 2 2 2 0 0
     0 0 0 1 1 1 1 1 0 0 0 0 0
     2 2 2 2 1 1 1 1 1 2 0 0 0
     2 2 2 2 2 2 2 0 2 0 0 0 0
     ;; blue units
     66 1 79 0 #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF
     ;; red units
     51 0 77 1 #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF #xFFFF
     ))
  '(game 8192 (memstring 1
     level 0
     turn 0
     blue-coins 0
     red-coins 0
     cursor-pos 66
     ai-cursor-pos 70

     selection #xFF

     ;; keep track of cursor position when moving a unit to draw a path
     move-pile #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF

     ;; a list of keys the IA will press this turn
     ai-moves #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF

     current-action #xFF ;; what the player can currently do when pressing the action button

     current-units
     ;; list of blue units (pos, lvl, hp, atk)
     current-blue-units #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF
                        #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF
     ;; list of red units (pos, lvl, hp, atk)
     current-red-units #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF
                       #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF
     current-units-end))
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

(func fill-vertical-line (x y len color)
  (locals i stop)
  (set-local i (+ x (* y (load (mem 'width)))))
  (set-local stop (+ i len))
  (call 'fill-pixels i stop 1 color))

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
  (call 'load-level 0))

;; get tile x position on screen based on the tile index
(func tile-x (i) =>
  (return (+ (const 'board-offset-x) (* (% i (const 'board-width)) 16))))

;; get tile y position on screen based on the tile index
(func tile-y (i) =>
  (return (+ (const 'board-offset-y) (* (/ i (const 'board-width)) 16))))

(func row-up (pos) =>
  (return (if (>= pos (const 'board-width)) =>
            (then (- pos (const 'board-width)))
            (else (+ pos 0)))))

(func row-down (pos) =>
  (return (+ pos (const 'board-width))))

(func col-left (pos) =>
  (return (if (> pos 0) =>
            (then (- pos 1))
            (else (+ pos 0)))))

(func col-right (pos) =>
  (return (+ pos 1)))

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
  (locals i pos level red?)
  (set-local i (mem 'game 'current-units))
  (for i (mem 'game 'current-units-end) 4
    (set-local pos (load-byte i))
    (set-local level (load-byte (+ 1 i)))
    (set-local red? (>= i (mem 'game 'current-red-units)))
    (if (!= pos #xFF)
      (call 'sprite (call 'tile-x pos)
                    (call 'tile-y (call 'row-up pos))
                    (+ (mem 'units 'start)
                       (* (+ level (* 3 red?))
                          (const 'soldier-size)))))))

(func show-unit-stats (unit)
  (locals pos hp atk)
  (set-local pos (load-byte unit))
  (set-local hp (load-byte (+ unit 2)))
  (set-local atk (load-byte (+ unit 3)))
  (call 'show-points (call 'tile-x pos)
                     (call 'tile-y (call 'row-down pos))
                     (mem 'palette 'red)
                     hp)
  (call 'show-points (+ (call 'tile-x pos) 5)
                     (call 'tile-y (call 'row-down pos))
                     (mem 'palette 'blue)
                     atk))

(func show-points (x y color n)
  (locals i)
  (set-local i 0)
  (set-local n (* n 3))
  (for i n 3
    (call 'fill-vertical-line x (+ y i) 6 (mem 'palette 'white))
    (call 'fill-vertical-line x (+ (+ y i) 1) 6 (mem 'palette 'white))
    (call 'fill-vertical-line x (+ (+ y i) 2) 6 (mem 'palette 'white))
    (call 'fill-vertical-line (+ x 1) (+ y i) 4 color)
    (call 'fill-vertical-line (+ x 1) (+ (+ y i) 1) 4 color)))

(func show-cursor-top (pos)
  (call 'sprite (- (call 'tile-x pos) 2)
                (- (call 'tile-y pos) 2)
                (if (call 'has-selection?) =>
                  (then (mem 'ui 'cursor-top-selected))
                  (else (mem 'ui 'cursor-top)))))

(func show-cursor-bot (pos)
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
    (set-local cursor-pos (load-byte (call 'get-cursor)))
    (call 'sprite (+ 16 (call 'tile-x cursor-pos))
                  (call 'tile-y (call 'row-down cursor-pos))
                  (+ (mem 'actions 'start)
                     (* current-action (const 'action-size))))))

(func show-coins (x y amount)
  (call 'sprite (+ x 4) (+ y 4) (mem 'ui 'coin-icon))
  (call 'sprite (+ x 14) (+ y 3) (+ (mem 'ui 'numbers) (* (const 'num-size)
                                                          (/ amount 100))))
  (call 'sprite (+ x 22) (+ y 3) (+ (mem 'ui 'numbers) (* (const 'num-size)
                                                          (/ (% amount 100) 10))))
  (call 'sprite (+ x 30) (+ y 3) (+ (mem 'ui 'numbers) (* (const 'num-size)
                                                          (% (% amount 100) 10)))))

(func show-level-number (x y level)
  (call 'sprite (+ x 4) (+ y 4) (mem 'ui 'level-icon))
  (call 'sprite (+ x 14) (+ y 3) (+ (mem 'ui 'numbers) (* (const 'num-size) level))))

;; ============================================================================
;;                                   CURSOR
;; ============================================================================

(func get-cursor () =>
  (if (call 'is-blue-turn?) =>
    (then (mem 'game 'cursor-pos))
    (else (mem 'game 'ai-cursor-pos))))

(func move-cursor-up ()
  (locals pos)
  (set-local pos (load-byte (call 'get-cursor)))
  (if (>= pos (const 'board-width))
    (set-local pos (call 'row-up pos))
    (store-byte (call 'get-cursor) pos)
    (call 'update-move-pile pos)))

(func move-cursor-down ()
  (locals pos)
  (set-local pos (call 'row-down (load-byte (call 'get-cursor))))
  (if (< pos (const 'board-size))
    (store-byte (call 'get-cursor) pos)
    (call 'update-move-pile pos)))

(func move-cursor-left ()
  (locals pos)
  (set-local pos (load-byte (call 'get-cursor)))
  (if (> (% pos (const 'board-width)) 0)
    (set-local pos (- pos 1))
    (store-byte (call 'get-cursor) pos)
    (call 'update-move-pile pos)))

(func move-cursor-right ()
  (locals pos)
  (set-local pos (+ (load-byte (call 'get-cursor)) 1))
  (if (> (% pos (const 'board-width)) 0)
    (store-byte (call 'get-cursor) pos)
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
  (set-local pos (load-byte (call 'get-cursor)))
  (if (call 'has-selection?)
    (then
      (if (call 'is-unit? pos)
        (then
          (if (call 'is-selection? pos)
            (then (store-byte (mem 'game 'current-action) (const 'action-upgrade)))
            (else (if (and (call 'is-ennemy-unit? pos)
                           (call 'is-within-distance? 2))
                    (then (store-byte (mem 'game 'current-action) (const 'action-attack)))
                    (else (store-byte (mem 'game 'current-action) (const 'action-blocked)))))))
        (else
          (if (and (not (call 'is-blocking-tile? pos))
                   (call 'is-within-distance? 4))
            (then (store-byte (mem 'game 'current-action) (const 'action-move)))
            (else (store-byte (mem 'game 'current-action) (const 'action-blocked)))))))
    (else
      (if (call 'is-player-unit? pos)
        (then (store-byte (mem 'game 'current-action) (const 'action-select)))
        (else (store-byte (mem 'game 'current-action) (const 'action-none)))))))

;; ============================================================================
;;                                  CHECKS
;; ============================================================================

(func has-selection? () =>
  (return (!= (load-byte (mem 'game 'selection))
              (const 'no-selection))))

(func is-blue-turn? () =>
  (return (= (load-byte (mem 'game 'turn)) (const 'blue-turn))))

(func is-red-turn? () =>
  (return (= (load-byte (mem 'game 'turn)) (const 'red-turn))))

(func is-selection? (pos) =>
  (return (= pos (load-byte (mem 'game 'selection)))))

(func is-unit? (pos) =>
  (locals i unit red? result)
  (set-local i (mem 'game 'current-units))
  (set-local result 0)
  (set-local red? 0)
  (for i (mem 'game 'current-units-end) 4
    (set-local unit (load-byte i))
    (set-local red? (>= i (mem 'game 'current-red-units)))
    (if (= unit pos)
      (set-local result (if red? =>
                          (then (const 'red-unit))
                          (else (const 'blue-unit))))
      (break)))
  (return result))

(func is-player-unit? (pos) =>
  (return (= (call 'is-unit? pos)
             (if (call 'is-blue-turn?) =>
               (then (const 'blue-unit))
               (else (const 'red-unit))))))

(func is-ennemy-unit? (pos) =>
  (return (= (call 'is-unit? pos)
             (if (call 'is-blue-turn?) =>
               (then (const 'red-unit))
               (else (const 'blue-unit))))))

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

(func any-units-left? (units) =>
  (locals i len pos result)
  (set-local i units)
  (set-local len (+ i 32)) ;; we scan half the units to get only one team
  (set-local result 0)
  (for i len 4
    (set-local pos (load-byte i))
    (if (!= pos #xFF)
      (set-local result 1)
      (break)))
  (return result))

;; ============================================================================
;;                               COMPLEX GETTERS
;; ============================================================================

(func get-selected-unit () =>
  (locals selection result)
  (set-local result 0)
  (set-local selection (load-byte (mem 'game 'selection)))
  (if (!= selection (const 'no-selection))
    (set-local result (call 'get-unit selection)))
  (return result))

(func get-unit-under-cursor () =>
  (return (call 'get-unit (load-byte (call 'get-cursor)))))

(func get-unit (pos) =>
  (locals i addr unit red-team? result)
  (set-local i (mem 'game 'current-units))
  (set-local result 0)
  (for i (mem 'game 'current-units-end) 4
    (set-local unit (load-byte i))
    (if (= unit pos)
      (set-local result i)
      (break)))
  (return result))

(func get-current-level () =>
  (return (call 'get-level (load-byte (mem 'game 'level)))))

(func get-level (n) =>
  (return (+ (mem 'levels 'start) (* (const 'level-size) n))))

(func get-level-units (level) =>
  (return (+ level (const 'board-size))))

(func get-coins () =>
  (if (call 'is-blue-turn?) =>
    (then (mem 'game 'blue-coins))
    (else (mem 'game 'red-coins))))

;; ============================================================================
;;                                   LOAD
;; ============================================================================

(func load-level (n)
  (locals i level units pos lvl target-addr)
  (set-local i 0)
  (set-local level (call 'get-level n))
  (set-local units (call 'get-level-units level))
  (for i (* 2 (const 'max-units-number)) 2
    (set-local pos (load-byte (+ units i)))
    (set-local lvl (load-byte (+ 1 (+ units i))))
    ;; we multiply i by 2 because an in-game unit is 4 bytes
    (set-local target-addr (+ (* i 2) (mem 'game 'current-units)))
    (if (= pos #xFF)
      (then
        (store target-addr #xFFFFFFFF))
      (else
        (store-byte target-addr pos)
        (store-byte (+ target-addr 1) lvl)
        (call 'init-unit target-addr)))))

(func reset-everything ()
  (store-byte (mem 'game 'blue-coins) 0)
  (store-byte (mem 'game 'red-coins) 0)
  (store-byte (mem 'game 'turn) (const 'blue-turn))
  (store-byte (mem 'game 'cursor-pos) 66)
  (store-byte (mem 'game 'ai-cursor-pos) 70)
  (call 'cancel)
  (call 'clear-ai-moves))

(func next-level ()
  (locals level)
  (set-local level (+ (load-byte (mem 'game 'level)) 1))
  (if (>= level (const 'number-of-levels))
    (then (call 'victory))
    (else
      (store-byte (mem 'game 'level) level)
      (call 'reset-everything)
      (call 'load-level level))))

(func init-unit (addr)
  (locals lvl)
  (set-local lvl (load-byte (+ addr 1)))
  (if (= 0 lvl)
    (store-byte (+ addr 2) (const 'small-unit-hp))
    (store-byte (+ addr 3) (const 'small-unit-atk)))
  (if (= 1 lvl)
    (store-byte (+ addr 2) (const 'medium-unit-hp))
    (store-byte (+ addr 3) (const 'medium-unit-atk)))
  (if (= 2 lvl)
    (store-byte (+ addr 2) (const 'big-unit-hp))
    (store-byte (+ addr 3) (const 'big-unit-atk))))

(func remove-unit (addr)
  (store addr #xFFFFFFFF))

;; ============================================================================
;;                                    AI
;; ============================================================================

(func get-random-unit (units) =>
  (locals addr pos)
  (set-local addr units)
  (set-local pos #xFF)
  (while (= pos #xFF)
    (set-local addr (+ units (* 4 (call 'random-num 8))))
    (set-local pos (load-byte addr)))
  (return addr))

;; scan 9 tiles for ennemy units
(func scan-for-ennemy (pos) =>
  (locals i unit tile result)
  (set-local i 0)
  (set-local unit 0)
  (set-local tile pos)
  (set-local result #xFF)
  (for i 15 1
    (set-local tile (+ (+ (% i 5)
                          (* (const 'board-width) (/ i 5)))
                       pos))
    (if (call 'is-ennemy-unit? tile)
      (set-local result tile)
      (break)))
  (return result))

;; scan 9 tiles for free space to move
(func scan-for-space (pos) =>
  (locals i tile result)
  (set-local i 0)
  (set-local result #xFF)
  (for i 15 1
    (set-local tile (+ (+ (% i 5)
                          (* (const 'board-width) (/ i 5)))
                       pos))
    (if (and (not (call 'is-blocking-tile? tile))
             (not (call 'is-unit? tile)))
      (set-local result tile)
      (break)))
  (return result))

(func clear-ai-moves ()
  (store (mem 'game 'ai-moves) #xFFFFFFFF)
  (store (+ 4 (mem 'game 'ai-moves)) #xFFFFFFFF)
  (store (+ 8 (mem 'game 'ai-moves)) #xFFFFFFFF)
  (store (+ 12 (mem 'game 'ai-moves)) #xFFFFFFFF))

;; fill the AI pile with actions to execute for the turn
(func prepare-ai-moves ()
  (locals pos scan-start ennemy free-tile)
  ;; put the cursor on a random unit
  (set-local pos (load-byte (call 'get-random-unit (mem 'game 'current-red-units))))
  (store-byte (mem 'game 'ai-cursor-pos) pos)

  ;; choose what to do
  (call 'clear-ai-moves)
  (call 'push-ai-move (const 'key-a)) ;; select current unit

  ;; we set the scanning position 2 tiles left from current position
  (set-local scan-start (call 'col-left (call 'col-left pos)))
  (call 'log-num pos)
  (call 'log-num scan-start)
  (set-local ennemy (call 'scan-for-ennemy scan-start))
  (if (!= ennemy #xFF)
    (then
      (call 'ai-add-moves-between pos ennemy)
      (call 'push-ai-move (const 'key-a)))
    (else
      (set-local free-tile (call 'scan-for-space scan-start))
      (if (!= free-tile #xFF)
        (then (call 'ai-add-moves-between pos free-tile)
              (call 'push-ai-move (const 'key-a)))
        (else
          ;; retry with another unit
          (call 'prepare-ai-moves))))))

;; push keys to the ai pile until we get to the wanted pos
(func ai-add-moves-between (start target)
  (locals move-count hdir vdir x y tx ty)
  (set-local move-count 3)
  (set-local x (% start (const 'board-width)))
  (set-local y (/ start (const 'board-width)))
  (set-local tx (% target (const 'board-width)))
  (set-local ty (/ target (const 'board-width)))
  (if (< x tx)
    (then (set-local hdir (const 'key-right)))
    (else (set-local hdir (const 'key-left))))
  (if (< y ty)
    (then (set-local vdir (const 'key-down)))
    (else (set-local vdir (const 'key-up))))
  ;; horizontal
  (while (and (> move-count 0) (!= x tx))
    (call 'push-ai-move hdir)
    (if (= hdir (const 'key-left))
      (then (set-local x (- x 1)))
      (else (set-local x (+ x 1))))
    (set-local move-count (- move-count 1)))
  ;; vertical
  (while (and (> move-count 0) (!= y ty))
    (call 'push-ai-move vdir)
    (if (= vdir (const 'key-up))
      (then (set-local y (- y 1)))
      (else (set-local y (+ y 1))))
    (set-local move-count (- move-count 1))))

;; pick an action and execute it
(func ai-move ()
  (locals move)
  (set-local move (call 'pop-ai-move))
  (if (= move #xFF)
    (then
      (call 'cancel)
      (call 'end-red-turn))
    (else (call 'ai-keydown move))))

(func push-ai-move (key)
  (locals i move)
  (set-local i 0)
  (for i (const 'ai-moves-len) 1
    (set-local move (load-byte (+ (mem 'game 'ai-moves) i)))
    (if (= move #xFF) ;; we can add to the pile
      (store-byte (+ (mem 'game 'ai-moves) i) key)
      (break))))

(func pop-ai-move () =>
  (locals i move result)
  (set-local i 0)
  (set-local result #xFF)
  (for i (const 'ai-moves-len) 1
    (set-local move (load-byte (+ (mem 'game 'ai-moves) i)))
    (if (= move #xFF)
      (if (> i 0)
        ;; erase precedent move
        (store-byte (+ (mem 'game 'ai-moves) (- i 1)) #xFF))
      (break))
    (set-local result move))
  (return result))

;; ============================================================================
;;                                GAME LOGIC
;; ============================================================================

(func check-blue-victory () =>
  (return (not (call 'any-units-left? (mem 'game 'current-red-units)))))

(func check-red-victory () =>
  (return (not (call 'any-units-left? (mem 'game 'current-blue-units)))))

(func enter ()
  (locals cursor-pos current-action)
  (set-local cursor-pos (load-byte (call 'get-cursor)))
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
  (store-byte (mem 'game 'selection) pos)
  (call 'update-move-pile pos))

(func cancel ()
  (store-byte (mem 'game 'selection) (const 'no-selection))
  (store-byte (mem 'game 'current-action) (const 'action-none))
  ;; reset move-pile
  (store (mem 'game 'move-pile) #xFFFFFFFF)
  (store (+ 4 (mem 'game 'move-pile)) #xFFFFFFFF))

(func move (pos)
  (store-byte (call 'get-selected-unit) pos)
  (call 'cancel)
  (call 'end-turn))

(func attack (pos)
  (locals unit atk target target-lvl target-hp)
  (set-local unit (call 'get-selected-unit))
  (set-local atk (load-byte (+ unit 3)))
  (set-local target (call 'get-unit pos))
  (set-local target-lvl (load-byte (+ target 1)))
  (set-local target-hp (load-byte (+ target 2)))
  (if (<= target-hp atk)
    (then (call 'remove-unit target)
          (call 'earn-coins (+ target-lvl 1)))
    (else (store-byte (+ target 2) (- target-hp atk))))
  (call 'cancel)
  (call 'end-turn))

(func earn-coins (amount)
  (locals coins-addr)
  (set-local coins-addr (call 'get-coins))
  (store-byte coins-addr (+ (load-byte coins-addr) amount)))

(func upgrade ()
  (locals coins unit-addr lvl)
  (set-local coins (load-byte (call 'get-coins)))
  (set-local unit-addr (call 'get-selected-unit))
  (set-local lvl (load-byte (+ 1 unit-addr)))
  (if (and (> coins 0) (< lvl 2))
    (store-byte (+ 1 unit-addr) (+ 1 lvl))
    (call 'init-unit unit-addr)
    (store-byte (call 'get-coins) (- coins 1))
    (call 'end-turn))
  (call 'cancel))

(func end-turn ()
  (if (call 'is-blue-turn?)
    (then (call 'end-blue-turn))
    (else (call 'end-red-turn))))

(func end-blue-turn ()
  (if (call 'check-blue-victory)
    (then
      (call 'next-level))
    (else
      (store-byte (mem 'game 'turn) (const 'red-turn))
      (call 'prepare-ai-moves))))

(func end-red-turn ()
  (if (call 'check-red-victory)
    (then
      (call 'game-over))
    (else
      (store-byte (mem 'game 'turn) (const 'blue-turn)))))

(func hello ()
  (call 'log (mem 'message-hello) 12))

(func render ()
  (call 'fill-screen (mem 'palette 'black))
  (call 'show-level (call 'get-current-level))
  (call 'show-level-number 98 201 (load-byte (mem 'game 'level)))
  (call 'show-coins 6 3 (load-byte (mem 'game 'blue-coins)))
  (call 'show-coins 178 3 (load-byte (mem 'game 'red-coins)))
  (call 'show-cursor-top (load-byte (call 'get-cursor)))
  (call 'show-path)
  (call 'show-current-units)
  (call 'show-cursor-bot (load-byte (call 'get-cursor)))
  (call 'show-unit-stats (call 'get-unit-under-cursor))
  (if (call 'has-selection?)
    (call 'show-unit-stats (call 'get-selected-unit)))
  (call 'show-action))

(func player-keydown (key)
  (if (call 'is-blue-turn?)
    (call 'keydown key)))

(func ai-keydown (key)
  (if (call 'is-red-turn?)
    (call 'keydown key)))

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

(func update (frame)
  (if (and (= (% frame 10) 0)
           (call 'is-red-turn?))
    (call 'ai-move)))

(export "memory" (memory 0))
(export "init" (func $init))
(export "render" (func $render))
(export "keydown" (func $player-keydown))
(export "update" (func $update))
(export "hello" (func $hello))
