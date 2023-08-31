# bf-codegen
Tools and macros to generate brainfuck code

## What does this repository contain?
Things i wrote to write brainfuck code.

### brainfuck-print
Searches for a short brainfuck program to print a given string.

### fnl2bf
A Fennel (or Lua) library for working with Brainfuck code at a higher level. Includes macros for common algorithms.

To use this library with Lua, compile the Fennel version to Lua:
```
cd fnl2bf
fennel -c fnl2bf.fnl > fnl2bf.lua
```

### constants
Contains programs that perform a brute force search for the shortest brainfuck program that increments/decrements/initializes one or multiple cells with given values.

### misc
Things that don't fit in any other directory.

## License
GNU Affero General Public License v3.0
