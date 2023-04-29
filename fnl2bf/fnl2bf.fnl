(local bf {})

"This is a Fennel library for working with Brainfuck code at a higher level.

## Naming conventions:
symbol | meaning
---|---
`!` | modifies the current cell
`\\` | requires manual initialization of cells that are not specified as a parameter

Parameters beginning with `temp` are always pointers to cells."

(set bf.factors [
  [0 0 1]
  [0 0 2]
  [0 0 3]
  [0 0 4]
  [0 0 5]
  [3 2 0]
  [3 2 1]
  [4 2 0]
  [3 3 0]
  [5 2 0]
  [5 2 1]
  [4 3 0]
  [4 3 1]
  [7 2 0]
  [5 3 0]
  [4 4 0]
  [4 4 1]
  [6 3 0]
  [6 3 1]
  [5 4 0]
  [7 3 0]
  [7 3 1]
  [6 4 -1]
  [6 4 0]
  [5 5 0]
  [5 5 1]
  [9 3 0]
  [7 4 0]
  [7 4 1]
  [6 5 0]
  [6 5 1]
  [8 4 0]
  [8 4 1]
  [7 5 -1]
  [7 5 0]
  [6 6 0]
  [6 6 1]
  [6 6 2]
  [8 5 -1]
  [8 5 0]
  [8 5 1]
  [7 6 0]
  [7 6 1]
  [11 4 0]
  [9 5 0]
  [9 5 1]
  [8 6 -1]
  [8 6 0]
  [7 7 0]
  [10 5 0]
  [10 5 1]
  [13 4 0]
  [9 6 -1]
  [9 6 0]
  [11 5 0]
  [8 7 0]
  [8 7 1]
  [8 7 2]
  [10 6 -1]
  [10 6 0]
  [10 6 1]
  [9 7 -1]
  [9 7 0]
  [8 8 0]
  [8 8 1]
  [11 6 0]
  [11 6 1]
  [11 6 2]
  [10 7 -1]
  [10 7 0]
  [10 7 1]
  [9 8 0]
  [9 8 1]
  [9 8 2]
  [15 5 0]
  [11 7 -1]
  [11 7 0]
  [13 6 0]
  [10 8 -1]
  [10 8 0]
  [9 9 0]
  [9 9 1]
  [12 7 -1]
  [12 7 0]
  [12 7 1]
  [12 7 2]
  [11 8 -1]
  [11 8 0]
  [11 8 1]
  [10 9 0]
  [13 7 0]
  [13 7 1]
  [13 7 2]
  [12 8 -2]
  [12 8 -1]
  [12 8 0]
  [12 8 1]
  [14 7 0]
  [11 9 0]
  [10 10 0]
  [10 10 1]
  [10 10 2]
  [13 8 -1]
  [13 8 0]
  [15 7 0]
  [15 7 1]
  [12 9 -1]
  [12 9 0]
  [12 9 1]
  [11 10 0]
  [11 10 1]
  [14 8 0]
  [14 8 1]
  [14 8 2]
  [13 9 -2]
  [13 9 -1]
  [13 9 0]
  [13 9 1]
  [12 10 -1]
  [12 10 0]
  [11 11 0]
  [11 11 1]
  [11 11 2]
  [14 9 -2]
  [14 9 -1]
  [14 9 0]
  [14 9 1]
  [16 8 0]
  [13 10 -1]
  [13 10 0]
  [13 10 1]
  [12 11 0]
  [12 11 1]
  [15 9 -1]
  [15 9 0]
  [17 8 0]
  [17 8 1]
  [14 10 -2]
  [14 10 -1]
  [14 10 0]
  [14 10 1]
  [13 11 -1]
  [13 11 0]
  [12 12 0]
  [12 12 1]
  [12 12 2]
  [12 12 3]
  [15 10 -2]
  [15 10 -1]
  [15 10 0]
  [15 10 1]
  [19 8 0]
  [17 9 0]
  [14 11 0]
  [14 11 1]
  [13 12 0]
  [13 12 1]
  [13 12 2]
  [16 10 -1]
  [16 10 0]
  [16 10 1]
  [18 9 0]
  [18 9 1]
  [15 11 -1]
  [15 11 0]
  [15 11 1]
  [14 12 -1]
  [14 12 0]
  [13 13 0]
  [17 10 0]
  [19 9 0]
  [19 9 1]
  [19 9 2]
  [16 11 -2]
  [16 11 -1]
  [16 11 0]
  [16 11 1]
  [16 11 2]
  [15 12 -1]
  [15 12 0]
  [15 12 1]
  [14 13 0]
  [14 13 1]
  [14 13 2]
  [17 11 -2]
  [17 11 -1]
  [17 11 0]
  [17 11 1]
  [21 9 0]
  [19 10 0]
  [16 12 -1]
  [16 12 0]
  [16 12 1]
  [15 13 -1]
  [15 13 0]
  [14 14 0]
  [14 14 1]
  [18 11 0]
  [18 11 1]
  [20 10 0]
  [20 10 1]
  [17 12 -2]
  [17 12 -1]
  [17 12 0]
  [17 12 1]
  [17 12 2]
  [16 13 -1]
  [16 13 0]
  [19 11 0]
  [15 14 0]
  [15 14 1]
  [15 14 2]
  [15 14 3]
  [18 12 -2]
  [18 12 -1]
  [18 12 0]
  [18 12 1]
  [18 12 2]
  [20 11 -1]
  [20 11 0]
  [17 13 0]
  [17 13 1]
  [16 14 -1]
  [16 14 0]
  [15 15 0]
  [15 15 1]
  [19 12 -1]
  [19 12 0]
  [19 12 1]
  [23 10 0]
  [21 11 0]
  [21 11 1]
  [18 13 -1]
  [18 13 0]
  [18 13 1]
  [18 13 2]
  [17 14 -1]
  [17 14 0]
  [17 14 1]
  [16 15 0]
  [16 15 1]
  [22 11 0]
  [22 11 1]
  [22 11 2]
  [19 13 -2]
  [19 13 -1]
  [19 13 0]
  [19 13 1]
  [19 13 2]
  [18 14 -2]
  [18 14 -1]
  [18 14 0]
  [18 14 1]
  [17 15 -1]
  [17 15 0]
])

(λ bf.shortest [...]
  "Returns the shortest argument"
  (let [t [...]]
    (table.sort t (λ [a b] (< (length a) (length b))))
    (. t 1)))

(λ bf.shortest-in [tbl]
  "Returns the shortest element from `tbl`"
  (let [t tbl]
    (table.sort t (λ [a b] (< (length a) (length b))))
    (. t 1)))

(λ bf.loop [...]
  "A loop: [...]"
  (.. "[" (table.concat [...] "") "]"))

(λ bf.at [distance ...]
  "Move pointer by `distance`, insert body, move back"
  (..
    (bf.ptr distance)
    (table.concat [...] "")
    (bf.ptr (- distance))))

(λ bf.ptr [distance ?from]
  "Move pointer by `distance`. If `?from` is not nil, assume the ptr starts at `?from`"
  (if
    (not= ?from nil) (bf.ptr (- distance ?from))
    (> distance 0)   (string.rep ">" distance)
    (< distance 0)   (string.rep "<" (- distance))
    ""))

(λ bf.inc [value]
  "Add `value` to current cell"
  (if
    (> value 255)
    (bf.inc (% value 256))

    (< value -255)
    (bf.inc (- (% (- value) 256)))

    (> (math.abs value) 127)
    (if
      (> value 0) (string.rep "-" (- 256 value))
      (< value 0) (string.rep "+" (- 256 (- value)))
      "")

    (if
      (> value 0) (string.rep "+" value)
      (< value 0) (string.rep "-" (- value))
      "")))

(λ bf.inc2 [value temp0]
  "Add `value` to the current cell, using `temp0`. `temp0` must be 0."
  (let [_inc2
        (fn [value sign]
          (..
            (bf.inc (* sign (. bf.factors value 3)))
            (bf.at temp0
              (bf.inc (. bf.factors value 2))
              (bf.loop
                (bf.at (- temp0)
                  (bf.inc (* sign (. bf.factors value 1))))
                "-"))))]

    (if (<= 1 (math.abs value) 255)
      (bf.shortest
        (bf.inc value)
        (if
          (> value 0)
          (_inc2 value 1)

          (< value 0)
          (_inc2 (- value) -1)

          "")
        (if
          (> value 0)
          (_inc2 (- (- value 256)) -1)

          (< value 0)
          (_inc2 (+ value 256) 1)

          ""))
      (bf.inc value))))

(λ bf.inc3 [value temp0 temp1]
  "Add `value` to the current cell, using `temp0` and `temp1`.
  `temp0` and `temp1` must be 0."
  (if (<= 1 (math.abs value) 255)
    (bf.shortest
      (bf.inc2 value temp0)
      (bf.inc2 value temp1)

      (if
        (> value 0)
        (..
          (bf.inc2 (. bf.factors value 3) temp0)
          (bf.at temp0
            (bf.inc2 (. bf.factors value 2) (- temp1 temp0))
            (bf.loop
              (bf.at (- temp0)
                (bf.inc2 (. bf.factors value 1) temp1))
              "-")))

        (< value 0)
        (bf.inc2 value temp0) ; TODO

        ""))
    (bf.inc value)))

(λ bf.zero []
  "Set current cell to 0"
  (bf.loop "-"))

(λ bf.set [value ?initial]
  "Set current cell to value"
  (if ?initial
    (bf.inc (- value ?initial))
    (..
      (bf.zero)
      (bf.inc value))))

(λ bf.set2 [value temp0 ?initial]
  "Set current cell to value, using `temp0`. `temp0` must be 0."
  (if ?initial
    (bf.inc2 (- value ?initial) temp0)
    (..
      (bf.zero)
      (bf.inc2 value temp0))))

(λ bf.add! [to]
  "Destructively add current cell to `to`"
  (bf.loop
    (bf.at to
      "+")
    "-"))

(λ bf.sub! [to]
  "Destructively subtract current cell from `to`"
  (bf.loop
    (bf.at to
      "-")
    "-"))

(λ bf.mul! [y temp0 temp1]
  "current cell <- current cell * cell at `y`.
   `temp0` and `temp1` must to be 0.
   `y` is not modified."
  (..
    (bf.add! temp1)

    (bf.ptr temp1)
    (bf.loop
      (bf.ptr y temp1)
      (bf.loop
        (bf.ptr 0 y) "+"
        (bf.ptr temp0) "+"
        (bf.ptr y temp0) "-")

      (bf.ptr temp0 y)
      (bf.loop
        (bf.ptr y temp0) "+"
        (bf.ptr temp0 y) "-")

      (bf.ptr temp1 temp0) "-")

    (bf.ptr 0 temp1)))

(λ bf.divmod\! []
  "Current cell divided/module by the next cell to the right.
   Uses 5 cells to the right of the current cell, cells must be initialized as shown:
   - Before: `>n d 1 0 0 0`
   - After:  `>0 d-n%d n%d n/d 0 0`"
  (..
    "[->-[>+>>]>[[-<+>]+>+>>]<<<<<]"
    (bf.at 2 "-")))

(λ bf.divmod-by! [value]
  "Current cell divided/modulo by value. Uses 5 cells to the right of the current cell."
  (..
    ;; prepare temp cells
    (bf.at 5 (bf.zero))
    (bf.at 4 (bf.zero))
    (bf.at 3 (bf.zero))
    (bf.shortest
      (..
        (bf.at 2 (bf.zero))
        (bf.at 1 (bf.set2 value 1))
        (bf.at 2 "+"))
      (..
        (bf.at 2 (bf.set 1))
        (bf.at 1 (bf.set value))))

    (bf.divmod\!)))

(λ bf.invert [temp ?init]
  "Equivalent to current cell <- (256 - current cell)."
  (..
    (if ?init (bf.at temp (bf.zero)) "")
    (bf.loop
      (bf.at temp "-")
      "-")
    (bf.at temp
      (bf.loop
        (bf.at (- temp) "-")
        "+"))
    ))

(λ bf.mov! [to]
  "Destructively move current cell to `to`"
  (..
    (bf.at to
      (bf.zero))
    (bf.add! to)))

(λ bf.mov [to temp ?init]
  "Copy value of the current cell to `to`, using `temp`.
   `temp` and `to` must be manually set to 0, unless `?init` is true."
  (..
    (if ?init
      (..
        (bf.at to   (bf.zero))
        (bf.at temp (bf.zero)))
      "")

    (bf.loop
      (bf.ptr to)
      "+"
      (bf.ptr (- temp to))
      "+"
      (bf.ptr (- temp))
      "-")

    ;; restore original value
    (bf.ptr temp)
    (bf.add! (- temp))
    (bf.ptr (- temp))))

(λ bf.swap [y temp0]
  "Swap the current cell with `y`, using `temp0`. `temp0` must be 0."
  (..
    (bf.loop
      "-"
      (bf.ptr temp0) "+"
      (bf.ptr y temp0) "-"
      (bf.ptr 0 y))

    (bf.at y
      (bf.loop
        "-"
        (bf.at (- y) "+")))

    (bf.at temp0
      (bf.loop
        "-"
        (bf.ptr y temp0) "+"
        (bf.ptr 0 y) "+"
        (bf.ptr temp0)))))

(λ bf.not=! [y]
 "current cell <- current cell != cell at `y`. Sets `y` to 0."
 (..
  (bf.loop
    (bf.at y
      "-")
    "-")
  (bf.at y
    (bf.loop
      (bf.zero)
      (bf.at (- y)
        "+")))))

(λ bf.=! [y]
 "current cell <- current cell == cell at `y`. Sets `y` to 0."
 (..
  (bf.loop
    (bf.at y
      "-")
    "-")
  "+"
  (bf.at y
    (bf.loop
      (bf.zero)
      (bf.at (- y)
        "-")))))

(λ bf.<\! [?init]
  "current cell <- current cell < next cell.
  - before: >x y 0 0
  - after: >(x<y) 0 0 0"
  (..
    (if ?init
      (..
        (bf.at 2 (bf.zero))
        (bf.at 3 (bf.zero)))
      "")
    "[->>+<[->-]>[<<[-]>>->]<<<]>[[-]<+>]<"))

(λ bf.if [...]
  "Equivalent to `[...[-]]`. Sets the current cell to 0."
  (bf.loop
    (table.concat [...] "")
    (bf.zero)))

(λ bf.if= [value temp0 temp1 ...]
  "If current cell == `value`, then ...
   The body is run at `temp0` and should not change the ptr."
  (..
    (bf.mov temp0 temp1)
    (bf.at temp1
      (bf.set value))
    (bf.at temp0
      (bf.not=! (- temp1 temp0))
      "-"
      (bf.loop
        (table.concat [...] "")
        (bf.zero)))))

(λ bf.if2= [value temp0 temp1 temp2 ...]
  "If current cell == `value`, then ...
   The body is run at `temp0` and should not change the ptr.
   `temp2`must be 0."
  (..
    (bf.mov temp0 temp1)
    (bf.at temp1
      (bf.set2 value temp2))
    (bf.at temp0
      (bf.not=! (- temp1 temp0))
      "-"
      (bf.loop
        (table.concat [...] "")
        (bf.zero)))))

(λ bf.if-not= [value temp0 ...]
  "If current cell ≠ `value`, then ...
   The body is run at the current cell.
   Sets the current cell to 0."
  (..
    (bf.inc2 (- value) temp0)
    (bf.loop
      (bf.inc2 value temp0)
      (table.concat [...] "")
      (bf.zero))))

(λ bf.do-times [n temp ...]
  "Run the body `n` times."
  (bf.at temp
    (bf.set n)
    (bf.loop
      (bf.at (- temp)
        (table.concat [...] ""))
      "-")))

(λ bf.print! [str ?initial]
  "Print `str` using the current cell.
   The value of the current cell is assumed to be `?initial`, if given."
  (if ?initial

    (faccumulate [result ""
                  i 1 (length str)]
      (.. result
          (bf.shortest
            (bf.inc (- (string.byte str i)
                       (or (string.byte str (- i 1)) ?initial)))
            (bf.set (string.byte str i)))
          "."))

    (..
      (bf.zero)
      (bf.print! str 0))))

(λ bf.print2! [str temp0 ?initial]
  "Print `str` using the current cell and `temp0`, `temp0` must be 0.
   The value of the current cell is assumed to be `?initial`, if given."
  (if ?initial

    (faccumulate [result ""
                  i 1 (length str)]
      (.. result
          (bf.shortest
            (bf.inc2 (- (string.byte str i)
                        (or (string.byte str (- i 1)) ?initial))
                     temp0)
            (bf.set2 (string.byte str i) temp0))
          "."))

    (..
      (bf.zero)
      (bf.print2! str temp0 0))))

(λ bf.string! [str move]
  "Store `str` in memory, starting at the current cell.
   All used cells must be initialized as 0. `move` should be ±1."
  (faccumulate [result ""
                i 1 (length str)]
    (.. result
        (bf.inc2 (string.byte str i) move)
        (bf.ptr move))))

(λ bf.string-opt1! [str move]
  "Slightly optimized version of `bf.string!`.
   Store `str` in memory, starting at the current cell.
   All used cells must be initialized as 0. `move` should be ±1."
  (faccumulate [result ""
                i 1 (length str)]
    (.. result
        ;; current byte = last byte ?
        (if (and (> i 1) (= (string.byte str i) (string.byte str (- i 1))))

          ;; try copying the last byte
          (bf.shortest
            (bf.at (- move)
              (bf.mov move (* 2 move)))
            (bf.inc2 (string.byte str i) move))

          ;; else
          (bf.inc2 (string.byte str i) move))
        (bf.ptr move))))

(λ bf.string-opt2! [str move]
  "Better optimized version of `bf.string!`.
   Store `str` in memory, starting at the current cell.
   All used cells must be initialized as 0. `move` should be ±1."

  (fn count [str i]
    "Count how many initial bytes of `str` share the same `bf.factors.1`"
    (if
      (= nil i)
      (count str 2)

      (> i (length str))
      (- i 1)

      (=
        (. bf.factors (string.byte str 1 1) 1)
        (. bf.factors (string.byte str i i) 1))
      (count str (+ i 1))

      (- i 1)))

  (fn iterate [result str]
    (if (= "" str)
      result
      (let [this (string.byte str 1 1)]
        (iterate
          (..
            result

            ;; initialize all current cells with factors.3
            (bf.ptr (- move))
            (faccumulate [r "" i 1 (count str)]
              (..
                r
                (bf.ptr move)
                (bf.inc (. bf.factors (string.byte str i i) 3))))

            ;; add factors.2 × factors.1
            (bf.at move
              (bf.inc (. bf.factors this 1))
              (bf.loop
                (faccumulate [r "" i (count str) 1 -1]
                  (..
                    r
                    (bf.at (- (* (- (count str) i -1) move))
                      (bf.inc (. bf.factors (string.byte str i i) 2)))))
                "-"))

            ;; move to the next position
            (bf.ptr move))

          (string.sub str (+ 1 (count str)))))))

  (iterate "" str))

(λ bf.string2! [str move temp0 initial]
  "TODO! remove when bf.string2-opt! works
  Store `str` in memory, starting at the current cell.
  All used cells must be initialized as 0. `move` should be ±1.
  `initial` can be any number between 1 and 255."
  (let [result
        (..
          (bf.ptr temp0)
          (bf.set (. bf.factors initial 1)) ; set temp0 to factor.1

          (bf.loop ; while temp0 > 0
            (bf.ptr (- temp0))

            ;; add factor.2 to each string cell
            (string.rep
              (..
                (bf.inc (. bf.factors initial 2))
                (bf.ptr move))
              (length str))
            (bf.ptr (* (length str) (- move)))

            (bf.ptr temp0) ; decrement temp0
            "-")

          (bf.ptr (- temp0)))]

    (..
      ;; change each string cell from the initial value
      (faccumulate [result result
                    i 1 (length str)]
        (.. result
            (bf.inc (% (- (string.byte str i)
                         (* (. bf.factors initial 1)
                            (. bf.factors initial 2)))
                      256))
            (bf.ptr move)))

      ;; move back to the initial cell, TODO: replace with loop if possible
      (bf.ptr (* (length str) (- move))))))

(λ bf.string2-opt! [str move initial]
  "TODO! fails for some `initial` values
   Store `str` in memory, starting at the current cell.
   All used cells must be initialized as 0. `move` should be ±1.
   `initial` can be any number between 1 and 255."
  (let [initial (if (= initial (string.byte str 1 1)) 0 initial)
        str-
        (faccumulate [r "" i 1 (length str)]
          (..
            r
            (string.char
              (if (< (string.byte str i i) initial)
                (+ 256 (- (string.byte str i i) initial))
                (- (string.byte str i i) initial)))))]

    (..
      (bf.string! str- move)

      (if (= 0 initial)
        ""
        (..
          (bf.ptr (* -1 (length str) move))
          (bf.loop
            (bf.inc initial)
            (bf.ptr move)))))))

(λ bf.optimize [code ?steps]
  "Remove useless combinations of brainfuck commands from `code`"
  (faccumulate [result code
                _ 1 (or ?steps 100)]
    (-> result
      (string.gsub "[%+%-]+%[%-%]" "[-]")
      (string.gsub "%[%[%-%]%]" "[-]")
      (string.gsub "<>" "")
      (string.gsub "><" "")
      (string.gsub "%+%-" "")
      (string.gsub "%-%+" "")
      (string.gsub "%]%[%-%]" "]"))))

(λ bf.optimize2 [code ?steps]
  "Remove useless combinations of brainfuck commands from `code`.
   More aggressive version of `bf.optimize`."
  (faccumulate [result (bf.optimize code ?steps)
                _ 1 (or ?steps 100)]
    (-> result
      (string.gsub "[<>%+%-]+$" "")
      (string.gsub "^[<>]+" "")
      (string.gsub "^%[%-%]+" ""))))

(λ bf.double [...]
  "
   low reserved reserved high
   ^ptr
    "
  (let [code (table.concat [...])]
    (faccumulate [result ""
                  i 1 (length code)]
      (..
        result
        (match (string.sub code i i)
          ">" ">>>>"
          "<" "<<<<"
          "+" ">+<+[>-]>[->>+<]<<"
          "-" ">+<[>-]>[->>-<]<<-"
          "[" ">+<[>-]>[->+>[<-]<[<]>[-<+>]]<-[+<"
          "]" ">+<[>-]>[->+>[<-]<[<]>[-<+>]]<-]<"
          _ (string.sub code i i))))))

(λ bf.print-cell\ []
  "Print the value of the current cell as a decimal number.
   Requires 6 cells containing 0 to the right of the current cell."
  (..
    ">>++++++++++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>>[-]>>>++++++++++<[->-[>+"
    ">>]>[+[-<+>]>+>>]<<<<<]>[-]>>[>++++++[-<++++++++>]<.<<+>+>[-]]<[<[->-<]++"
    "++++[->++++++++<]>.[-]]<<++++++[-<++++++++>]<.[-]<<[-<+>]<"))

(λ _generic-case [inc-fn temp0 temp0-init ?temp1 args]
  "This function is used to implement both `bf.case!` and `bf.case2!`.
   Do not use this directly."
  (fn _case [initial args]
    (let [[value body & args] args]
      (if
        ;; string: convert to number
        (= :string (type value))
        (do
          (table.insert args 1 body)
          (table.insert args 1 (string.byte value 1 1))
          (_case initial args))

        (..
          (inc-fn (- initial value) ?temp1)
          (bf.loop
            (if (>= (length args) 2)
              (_case value args) ; next case
              (..                ; default case
                (bf.zero)
                (bf.at temp0
                  (bf.if
                    (if (>= (length args) 1)
                      (. args 1)
                      ""))))))
          (if body
            (bf.at temp0
              (bf.if
                body))
            "")))))
  (..
    ;; set temp0
    (if temp0-init
      (bf.at temp0
        (bf.zero)
        (inc-fn temp0-init ?temp1))
      "")

    (_case 0 args)))

(λ _build-case-args [inc-fn temp0 ?temp1 ...]
  "This function generates the `args` for `_generic-case`.
   Do not use this directly."
  (let [result []]
    (var init 1)

    ;; iterate over value+code pairs and fill `result`
    (for [i 1 (length [...]) 2]
      (if
        ;; value is :init : set `temp0-init` of `_generic_case`
        (= :init (. [...] i))
        (set init (. [...] (+ 1 i)))

        ;; value is a table:
        ;; transform '[1 2 3] :foo' into '1 :foo 2 false 3 false'
        (= :table (type (. [...] i)))
        (do
          (table.insert result (+ 1 (length result)) (. [...] i 1))
          (table.insert result (+ 1 (length result)) (. [...] (+ 1 i)))
          (for [j 2 (length (. [...] i))]
            (table.insert result (+ 1 (length result)) (. [...] i j))
            (table.insert result (+ 1 (length result)) false)))

        ;; else
        (do
          (table.insert result (+ 1 (length result)) (. [...] i))
          (table.insert result (+ 1 (length result)) (. [...] (+ 1 i))))))

    (_generic-case inc-fn temp0 init ?temp1 result)))

(λ bf.case! [temp ...]
  "A switch-case-like construct.
   Takes an arbitrary number of value+code pairs and an optional default case.
   The code will be run at `temp`."
  (_build-case-args bf.inc temp :nil ...))

(λ bf.case2! [temp0 temp1 ...]
  "A switch-case-like construct.
   Takes an arbitrary number of value+code pairs and an optional default case.
   The code will be run at `temp0`."
  (_build-case-args bf.inc2 temp0 temp1 ...))

bf
