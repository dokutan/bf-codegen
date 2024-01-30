# Efficient bitwidth conversions

The following examples use the 1→2 No Copy conversion from https://esolangs.org/wiki/Brainfuck_bitwidth_conversions, other conversions can use the same principles but would obviously need changes to the code. 


## Zero a cell
Zero each part individually:
```bf
[-]>>>[-]<<<
```

## Moving a cell
Move each part individually.

## Incrementing/decrementing a cell
### Incrementing by 1
```bf
>+<+[>-]>[->>+<]<<
```

### Decrementing by 1
```bf
>+<[>-]>[->>-<]<<-
```

### Incrementing by a small n without an additional cell
1. Increment the low byte by n
2. Check if an overflow occured, then increment the high byte
This method is not shorter than incrementing by one twice, but is shorter for e.g. n=3:
```bf
+++                     increment by 3
[>+>+<<-]>>[<<+>>-]     copy the low byte
+<[-[-[[-]>-<]]]>[>+<-] increment the high byte if the low byte is 0;1;2
<<                      return to the initial position
```

### Incrementing/decrementing by n<256
Use one or two normal cells to set an adjacent cell to n (https://esolangs.org/wiki/Brainfuck_constants), then add/subtract n from the 16bit cell using a loop eg. increment by 100:
```bf
<< ++++++++++ [- > ++++++++++ <] > set adjacent cell to 100
[- > >+<+[>-]>[->>+<]<< <] >       add 100 to the 16bit cell
```

### Incrementing/decrementing by multiples of 256 (n%256==0)
Increment/decrement the high byte by n/256, eg. increment by 1024=4×256:
```bf
>>>++++<<<
```

### Incrementing/decrementing by an arbitrary value n
Combine the previous approaches and increment/decrement by n%256 and n/256.
