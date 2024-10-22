# Higher order functions in brainfuck

These algorithms are versions of the `map` and `reduce`/`fold` functions in brainfuck. To allow for shorter code, these operate in-place on zero delimited arrays (i.e. one element per cell, zero is not allowed in the array).

## shift left
Implemented in fnl2bf as `bf.array1.shiftl`. Required for the other algorithms.

- shift by 1: `>[[-<+>]>]<`
- shift by 2: `>[[-<<+>>]>]<<`
- ...

- before: `0, [0], array, 0`
- after:  `0, array, [0], 0`

## shift right
Implemented in fnl2bf as `bf.array1.shiftl`. Required for the other algorithms.

- shift by 1: `<[[->+<]<]>`
- shift by 2: `<[[->>+<<]<]>>`
- ...

- before: `0, array, [0], 0`
- after:  `0, [0], array, 0`

## `map`
Implemented in fnl2bf as `bf.array1.map`.

Map `code` over array in place:
- before: `0, array, [0], 0
- after: `0, array, [0], 0
`code` is run in the following environment: `array, 0 * distance, [current element], array`

distance can be any number >= 1.

```bf
This example increments all cells in an array by 3

< move to last element
[
  [>+<-] move cell right by distance
  
  >
    at distance: insert code
    +++
  <
  
  <]

> move right by distance

>[[-<+>]>]< shift array left by distance
```

## `fold`

Implemented in fnl2bf as `bf.array1.foldr`, see also `bf.array1.foldl`.

Fold from the right, places the result in the leftmost element of the array.
- before: `0, array, [0]`
- after: `[0], result, 0, …, 0`
`code` is run in the following environment `array, [a], b, 0, …`, and must produce `array, [f(a,b)], 0, 0, …`

```bf
This example adds all elements in an array.

<<
[
  insert code:
  >[-<+>]< add b to a

  <
]
```

## `filter`

The `filter` function can be constructed from the `map` function by conditionally removing an element and closing the gap in the array.

```fennel
;; This example removes all elements with value 2 from an array

(bf.array1.map 3
  (bf.if= 2 -2 -3 ; -1 has to be zero for the shift
    ">>"               ; move to current element
    (bf.zero)          ; delete element
    (bf.array1.shiftl) ; close gap in array
    "<[<]<"))
```

```bf
<[[>>>+<<<-]>>>[<<+<+>>>-]<<<[>>>+<<<-]++>[<->-]<[[-]>+<]>-[>>[-]>[[-<+>]>]<<[<]<[-]]<<]>>>>[[-<<<+>>>]>]<<<
```
