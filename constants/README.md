# constants
This directory contains programs that perform a brute force search for the shortest brainfuck program that increments/decrements/initializes one or multiple cells with given values.

All programs require a brainfuck implementation with 8-bit wrapping cells.

See also: https://esolangs.org/wiki/Brainfuck_constants

## csv-to-lua.sh
Convert inc2.csv to inc2-factors.lua and inc2-2.csv to inc2-2-factors.lua for use with fnl2bf.

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
Running this program produces the file inc2-2.csv, this file contains no header and the following columns:
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

## inc2-3.jl
Searches for programs that increment/decrement three cells using a loop and a fourth cell, that must be zero, as a loop counter. 

### Output
Running this program produces the file inc2-3.csv, this file contains no header and the following columns:
```
r1,r2,r3,i1,i2,i3,il,a1,a2,a3,al
```

### Output parameters:
- r1: value that gets added to the current cell by the whole program
- r2: value that gets added to the second cell by the whole program
- r3: value that gets added to the third cell by the whole program
- i1: value that gets added to the current cell before the loop
- i2: value that gets added to the second cell before the loop
- i3: value that gets added to the third cell before the loop
- il: value that gets added to the loop counter before the loop
- a1: value that gets added to the current cell during the loop
- a2: value that gets added to the second cell during the loop
- a3: value that gets added to the third cell during the loop
- al: value that gets added to the loop counter during the loop

## inc2-n.jl
Searches for the optimal parameters i1,a1 for all possible il,al to increment a cell with one loop: `i1 > il [ < a1 > al ]`.
Similar to inc2.jl, without the initial value of the loop counter L, the loop counter must either be initialized as 0, or an il chosen to make use the initial value.
Intended to make building programs that increment multiple cells easier.

### Output
Running this program produces the file inc2-n.csv, this file contains no header and the following columns:
```
r,il,al,i1,a1
```

### Output parameters:
- r: value that gets added to the current cell by the whole program
- il: initial value of the loop counter before the loop
- al: value that gets added to the loop counter during the loop
- i1: value that gets added to the current cell before the loop
- a1: value that gets added to the current cell during the loop

```
0 ≤ (r, il) ≤ 255
-20 ≤ (al, i1, a1) ≤ 20
```

## inc2-n-build-bf.jl
Uses `inc2-n.csv` to generate brainfuck programs that initialize/add to multiple cells.
