#lang s-exp "wast.rkt"

(import "console" "log" (log pos len))

(func fill_pixels (pos len step color)
  (for 'pos '(- len 1) 'step
    (call pixel pos color)))

(func main ()
  (call log (mem 'messages) 12))

(export "memory" (memory 0))

(data
  '(width 0 0)
  '(height 4 0)
  '(palette 8 '())
  '(messages 256 "Hello world!")
  '(screen 1024 0))
