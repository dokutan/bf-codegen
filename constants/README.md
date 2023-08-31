# constants
This directory contains programs that perform a brute force search for the shortest brainfuck program that increments/decrements/initializes one or multiple cells with given values.

All programs require a brainfuck implementation with 8-bit wrapping cells.

See also: https://esolangs.org/wiki/Brainfuck_constants

## inc2.jl
Searches for programs that increment/decrement a single cell using a loop and a second cell with a known arbitrary value as a loop counter.

Example:
```
->++[<+++>++]
```

Output parameters:
- i1: value that gets added to the cell before the loop
- il: value that gets added to the loop counter before the loop
- L: initial value of the loop counter
- a1: value that gets added to the cell during the loop
- al: value that gets added to the loop counter during the loop

TODO: update and document the output format

## inc2-2.jl
Searches for programs that increment/decrement two cells using a loop and a third cell, that must be zero, as a loop counter. 
