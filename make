#!/bin/bash

SRC_DIR=src
BUILD_DIR=build

racket $SRC_DIR/game.rkt > $BUILD_DIR/game.wat
wat2wasm $BUILD_DIR/game.wat -o $BUILD_DIR/game.wasm
