# wasm-adventure
My adventure into the marvelous world of Web Assembly

## Demo

Try the live version here: https://euhmeuh.github.io/wasm-adventure/

## How to compile and play

* Run `./build`
* Open `index.html` in your favorite (Web Assembly compatible) browser

## How to generate wast code from racket

* Run `racket game.rkt > game.wast`

## How to compile wast manually

* Run `wat2wasm game.wast -o game.wasm`

## Motivations

Is it possible (and enjoyable) to write a game directly in web assembly's text format?  
Eventually, would it be cool to generate wast from Scheme code using the Racket lang syntax?

## Discoveries so far

* Wasm has two text formats: linear (stack machine) and S-expression style
* Writing directly in Wasm is tedious after a while (very verbose)
* I can use Racket to write my own DSL (Domain Specific Language) in order to program in a higher level language
* I can implement recurrent patterns into higher level procedures (see `for`)
* I can name constants and implement helpers (see `mem`)
