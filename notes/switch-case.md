# switch case

This document shows how a switch case like control structure can be implemented in brainfuck. All examples branch depending on the value of the current cell, afterwards the current cell is set to zero.

## 1. example
```
>[-]+< set temporary cell to any non-zero value

-  decrement by option 1 (1)
[
  - decrement by option 2 minus option 1 (2 minus 1)
  [
    --- decrement by option 3 minus option 2 (5 minus 2)
    [
      [-] no match: set current cell to zero
      >
      [
        default option
        [-] set temp to zero
      ]
      <
    ]
    >
    [
      option 3: current cell was 5
      [-] set temp to zero
    ]
    <
  ]
  >
  [
    option 2: current cell was 2
    [-] set temp to zero
  ]
  <
]
>
[
  option 1: current cell was 1
  [-] set temp to zero
]
<
```

## 2. example: fallthrough
```
>[-]+<

- decrement by 1
[
  - decrement by 2 minus 1
  [
    - decrement by 3 minus 2
    [
      [-]
      >
      [
        default option
        [-]
      ]
      <
    ]
  ]
  >
  [
    current cell was 2 or 3
    [-]
  ]
  <
]
>
[
  current cell was 1
  [-]
]
<
```

## Other improvements
- Use a second temporary cell to efficiently decrement the current cell by large values using a loop
- Reuse the value of the temporary cell, choosing the right value can make the code for each case more efficient.
- Use a shorter way of zeroing the temporary cell if possible, e.g. `-` or `>`
