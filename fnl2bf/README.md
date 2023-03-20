# fnl2bf.fnl

This is a Fennel library for working with Brainfuck code at a higher level.

## Naming conventions:
symbol | meaning
---|---
`!` | modifies the current cell
`\` | requires manual initialization of cells that are not specified as a parameter

Parameters beginning with `temp` are always pointers to cells.

## `bf.shortest` (λ)
```(bf.shortest ...)```

Returns the shortest argument

## `bf.shortest-in` (λ)
```(bf.shortest-in tbl)```

Returns the shortest element from `tbl`

## `bf.loop` (λ)
```(bf.loop ...)```

A loop: [...]

## `bf.at` (λ)
```(bf.at distance ...)```

Move pointer by `distance`, insert body, move back

## `bf.ptr` (λ)
```(bf.ptr distance ?from)```

Move pointer by `distance`. If `?from` is not nil, assume the ptr starts at `?from`

## `bf.inc` (λ)
```(bf.inc value)```

Add `value` to current cell

## `bf.inc2` (λ)
```(bf.inc2 value temp0)```

Add `value` to the current cell, using `temp0`. `temp0` must be 0.

## `bf.inc3` (λ)
```(bf.inc3 value temp0 temp1)```

Add `value` to the current cell, using `temp0` and `temp1`.
`temp0` and `temp1` must be 0.

## `bf.zero` (λ)
```(bf.zero)```

Set current cell to 0

## `bf.set` (λ)
```(bf.set value)```

Set current cell to value

## `bf.set2` (λ)
```(bf.set2 value temp0)```

Set current cell to value, using `temp0`. `temp0` must be 0.

## `bf.add!` (λ)
```(bf.add! to)```

Destructively add current cell to `to`

## `bf.mul!` (λ)
```(bf.mul! y temp0 temp1)```

current cell <- current cell * cell at `y`.
`temp0` and `temp1` must to be 0.
`y` is not modified.

## `bf.divmod\!` (λ)
```(bf.divmod\!)```

Current cell divided/module by the next cell to the right.
Uses 5 cells to the right of the current cell, cells must be initialized as shown:
- Before: `>n d 1 0 0 0`
- After:  `>0 d-n%d n%d n/d 0 0`

## `bf.divmod-by!` (λ)
```(bf.divmod-by! value)```

Current cell divided/modulo by value. Uses 5 cells to the right of the current cell.

## `bf.mov!` (λ)
```(bf.mov! to)```

Destructively move current cell to `to`

## `bf.mov` (λ)
```(bf.mov to temp)```

Move current cell to `to`, using `temp`

## `bf.not=!` (λ)
```(bf.not=! y)```

current cell <- current cell != cell at `y`. Sets `y` to 0.

## `bf.if=` (λ)
```(bf.if= value temp0 temp1 ...)```

If current cell == `value`, then ...
The body is run at `temp0` and should not change the ptr.

## `bf.if2=` (λ)
```(bf.if2= value temp0 temp1 temp2 ...)```

If current cell == `value`, then ...
The body is run at `temp0` and should not change the ptr.
`temp2`must be 0.

## `bf.if-not=` (λ)
```(bf.if-not= value temp0 ...)```

If current cell ≠ `value`, then ...
The body is run at the current cell.
Sets the current cell to 0.

## `bf.do-times` (λ)
```(bf.do-times n temp ...)```

Run the body `n` times.

## `bf.print!` (λ)
```(bf.print! str ?initial)```

Print `str` using the current cell.
The value of the current cell is assumed to be `?initial`, if given.

## `bf.print2!` (λ)
```(bf.print2! str temp0 ?initial)```

Print `str` using the current cell and `temp0`, `temp0` must be 0.
The value of the current cell is assumed to be `?initial`, if given.

## `bf.string!` (λ)
```(bf.string! str move)```

Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.

## `bf.string2!` (λ)
```(bf.string2! str move temp0 initial)```

Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.
`initial` can be any number between 1 and 255.

## `bf.optimize` (λ)
```(bf.optimize code ?steps)```

Remove useless combinations of brainfuck commands from `code`

