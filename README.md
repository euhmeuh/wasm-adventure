# wasm-adventure
My adventure into the marvelous world of Web Assembly

## Demo

Try the live version here: https://euhmeuh.github.io/wasm-adventure/

## How to compile

* Run `wat2wasm game.wast -o game.wasm`
* Open `index.html` in your favorite (Web Assembly compatible) browser

## How to generate wast code from racket

* Run `racket game.rkt > out.wast`

## Motivations

Is it possible (and enjoyable) to write a game directly in web assembly's text format?  
Eventually, would it be cool to generate wast from Scheme code using the Racket lang syntax?
