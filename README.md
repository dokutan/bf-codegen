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

### notes
Notes regarding the code in this repo.

### useful links
These sites contain additional information tht might be useful for writing (or generating) brainfuck:
- https://brainfuck.org
- https://esolangs.org/wiki/Brainfuck_algorithms
- https://esolangs.org/wiki/Brainfuck_constants
- https://brainfuckhowto.blogspot.com
- https://www.codingame.com/profile/1aa3b57d313d36f2b421bf8a30a7dfef2532691/playgrounds
- https://github.com/primo-ppcg/BF-Crunch
- https://codegolf.stackexchange.com/questions/9178/bitwise-operators-in-brainfuck
- https://github.com/bf-enterprise-solutions

## License
GNU Affero General Public License v3.0
