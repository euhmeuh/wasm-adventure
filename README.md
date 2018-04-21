# wasm-adventure
My adventure into the marvelous world of Web Assembly

## Demo

Try the live version here: https://euhmeuh.github.io/wasm-adventure/

## How to compile and play

* Run `./make`
* Open `index.html` in your favorite (Web Assembly compatible) browser

## How to generate wat (WebAssemblyText) code from Racket

* Run `racket src/game.rkt > build/game.wat`

## How to compile wat to wasm manually (you need the wat2wasm toolkit)

* Run `wat2wasm build/game.wat -o build/game.wasm`

## Motivations

Is it possible (and enjoyable) to write a game directly in web assembly's text format?  
Eventually, would it be cool to generate wat from Scheme code using the Racket lang system?

## Lisp Game Jam 2018

This is an entry for the 2018 edition of the [Lisp Game Jam](https://itch.io/jam/lisp-game-jam-2018)

## Discoveries so far

* Wasm has two text formats: linear (stack machine) and S-expression style
* Writing directly in Wasm is tedious after a while (very verbose)
* I can use Racket to write my own DSL (Domain Specific Language) in order to program in a higher level language
* I can implement recurrent patterns into higher level procedures (see `for`)
* I can name constants and implement helpers (see `mem`)
* I can draw to a screen by using javascript's Uint8Array and pushing data to a canvas
* I can make a game?
