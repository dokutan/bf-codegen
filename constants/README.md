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

### Output
Running this program produces the file inc2.csv, this file contains no header and the following columns:
```
r,L,i1,il,a1,al
```

### Output parameters:
- r: value that gets added to the current cell by the whole program
- i1: value that gets added to the current cell before the loop
- il: value that gets added to the loop counter before the loop
- L: initial value of the loop counter
- a1: value that gets added to the current cell during the loop
- al: value that gets added to the loop counter during the loop


## inc2-2.jl
Searches for programs that increment/decrement two cells using a loop and a third cell, that must be zero, as a loop counter. 

### Output
Running this program produces the file inc2.csv, this file contains no header and the following columns:
```
r1,r2,i1,i2,il,a1,a2,al
```

### Output parameters:
- r1: value that gets added to the current cell by the whole program
- r2: value that gets added to the second cell by the whole program
- i1: value that gets added to the current cell before the loop
- i2: value that gets added to the second cell before the loop
- il: value that gets added to the loop counter before the loop
- a1: value that gets added to the current cell during the loop
- a2: value that gets added to the second cell during the loop
- al: value that gets added to the loop counter during the loop
