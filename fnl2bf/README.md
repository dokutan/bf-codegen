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

## `bf.inc2-2` (λ)
```(bf.inc2-2 value1 value2 at2 temp)```

Increment the current cell by `value1` and the cell at `at2` by `value2`.
`temp` must be zero.

## `bf.zero` (λ)
```(bf.zero)```

Set current cell to 0

## `bf.set` (λ)
```(bf.set value ?initial)```

Set current cell to value

## `bf.set2` (λ)
```(bf.set2 value temp0 ?initial)```

Set current cell to value, using `temp0`. `temp0` must be 0.

## `bf.add!` (λ)
```(bf.add! to)```

Destructively add current cell to `to`

## `bf.sub!` (λ)
```(bf.sub! to)```

Destructively subtract current cell from `to`

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

## `bf.invert` (λ)
```(bf.invert temp ?init)```

Equivalent to current cell <- (256 - current cell).

## `bf.mov!` (λ)
```(bf.mov! to)```

Destructively move current cell to `to`

## `bf.mov` (λ)
```(bf.mov to temp ?init)```

Copy value of the current cell to `to`, using `temp`.
`temp` and `to` must be manually set to 0, unless `?init` is true.

## `bf.swap` (λ)
```(bf.swap y temp0)```

Swap the current cell with `y`, using `temp0`. `temp0` must be 0.

## `bf.not=!` (λ)
```(bf.not=! y)```

current cell <- current cell != cell at `y`. Sets `y` to 0.

## `bf.=!` (λ)
```(bf.=! y)```

current cell <- current cell == cell at `y`. Sets `y` to 0.

## `bf.<\!` (λ)
```(bf.<\! ?init)```

current cell <- current cell < next cell.
- before: >x y 0 0
- after: >(x<y) 0 0 0

## `bf.if` (λ)
```(bf.if ...)```

Equivalent to `[...[-]]`. Sets the current cell to 0.

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

## `bf.print3!` (fn)
```(bf.print3! str temp0 temp1 ?initial)```

Print `str` using the current cell, `temp0` and `temp1`, `temp0` and `temp1` must be 0.
The value of the current cell is assumed to be `?initial`, if given.
`temp0` can have a non-zero value afterwards.

## `bf.string!` (λ)
```(bf.string! str move)```

Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.

## `bf.string-opt1!` (λ)
```(bf.string-opt1! str move)```

Slightly optimized version of `bf.string!`.
Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.

## `bf.string-opt2!` (λ)
```(bf.string-opt2! str move)```

Better optimized version of `bf.string!`.
Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.

## `bf.string-opt3!` (λ)
```(bf.string-opt3! str move)```

Optimized version of `bf.string!`.
Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.

## `bf.string2!` (λ)
```(bf.string2! str move temp0 initial)```

TODO! remove when bf.string2-opt! works
Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.
`initial` can be any number between 1 and 255.

## `bf.string2-opt!` (λ)
```(bf.string2-opt! str move initial)```

TODO! fails for some `initial` values
Store `str` in memory, starting at the current cell.
All used cells must be initialized as 0. `move` should be ±1.
`initial` can be any number between 1 and 255.

## `bf.optimize` (λ)
```(bf.optimize code ?steps)```

Remove useless combinations of brainfuck commands from `code`

## `bf.optimize2` (λ)
```(bf.optimize2 code ?steps)```

Remove useless combinations of brainfuck commands from `code`.
More aggressive version of `bf.optimize`.

## `bf.double` (λ)
```(bf.double ...)```


low reserved reserved high
^ptr


## `bf.print-cell\` (λ)
```(bf.print-cell\)```

Print the value of the current cell as a decimal number.
Requires 6 cells containing 0 to the right of the current cell.

## `_generic-case` (λ)
```(_generic-case inc-fn temp0 temp0-init ?temp1 args)```

This function is used to implement both `bf.case!` and `bf.case2!`.
Do not use this directly.

## `_build-case-args` (λ)
```(_build-case-args inc-fn temp0 ?temp1 ...)```

This function generates the `args` for `_generic-case`.
Do not use this directly.

## `bf.case!` (λ)
```(bf.case! temp ...)```

A switch-case-like construct.
Takes an arbitrary number of value+code pairs and an optional default case.
The code will be run at `temp`.

## `bf.case2!` (λ)
```(bf.case2! temp0 temp1 ...)```

A switch-case-like construct.
Takes an arbitrary number of value+code pairs and an optional default case.
The code will be run at `temp0`.

## `bf.optimize-parms` (fn)
```(bf.optimize-parms func parms ?progress ?logfile)```

Optimize the independent parameters `parms` of the function `func`.
The goal is to find the parameters producing the shortest result of `func`.
The parameters should not influence each other and must be given as a table of
tables, each containing a minimum and maximum value, e.g. `[[1 100] [0 255]]`.
If `?progress` is true, print the progress to stderr.
If `?logfile` is a filename, a Julia script producing a plot of the result
length is generated.

