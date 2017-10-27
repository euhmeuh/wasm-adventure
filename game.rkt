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

(func pixel (pos color)
  (- pos color)
  '(drop))

(func fill_pixels (pos len step color)
  (for pos (- len 1) step
    (call 'pixel pos color)))

(func main ()
  (call 'log (mem 'messages) 12))

(export "memory" (memory 0))
(export "main" (func $main))
