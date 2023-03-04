(local bf {})

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
  [7 3 2]
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
  [8 4 2]
  [7 5 0]
  [6 6 0]
  [6 6 1]
  [6 6 2]
  [6 6 3]
  [8 5 0]
  [8 5 1]
  [7 6 0]
  [7 6 1]
  [11 4 0]
  [9 5 0]
  [9 5 1]
  [9 5 2]
  [8 6 0]
  [7 7 0]
  [10 5 0]
  [10 5 1]
  [13 4 0]
  [13 4 1]
  [9 6 0]
  [11 5 0]
  [8 7 0]
  [8 7 1]
  [8 7 2]
  [8 7 3]
  [10 6 0]
  [10 6 1]
  [10 6 2]
  [9 7 0]
  [8 8 0]
  [8 8 1]
  [11 6 0]
  [11 6 1]
  [11 6 2]
  [11 6 3]
  [10 7 0]
  [10 7 1]
  [9 8 0]
  [9 8 1]
  [9 8 2]
  [15 5 0]
  [15 5 1]
  [11 7 0]
  [13 6 0]
  [13 6 1]
  [10 8 0]
  [9 9 0]
  [9 9 1]
  [9 9 2]
  [12 7 0]
  [12 7 1]
  [12 7 2]
  [12 7 3]
  [11 8 0]
  [11 8 1]
  [10 9 0]
  [13 7 0]
  [13 7 1]
  [13 7 2]
  [13 7 3]
  [19 5 0]
  [12 8 0]
  [12 8 1]
  [14 7 0]
  [11 9 0]
  [10 10 0]
  [10 10 1]
  [10 10 2]
  [10 10 3]
  [13 8 0]
  [15 7 0]
  [15 7 1]
  [15 7 2]
  [12 9 0]
  [12 9 1]
  [11 10 0]
  [11 10 1]
  [14 8 0]
  [14 8 1]
  [14 8 2]
  [14 8 3]
  [14 8 4]
  [13 9 0]
  [13 9 1]
  [17 7 0]
  [12 10 0]
  [11 11 0]
  [11 11 1]
  [11 11 2]
  [11 11 3]
  [11 11 4]
  [14 9 0]
  [14 9 1]
  [16 8 0]
  [16 8 1]
  [13 10 0]
  [13 10 1]
  [12 11 0]
  [12 11 1]
  [12 11 2]
  [15 9 0]
  [17 8 0]
  [17 8 1]
  [17 8 2]
  [17 8 3]
  [14 10 0]
  [14 10 1]
  [14 10 2]
  [13 11 0]
  [12 12 0]
  [12 12 1]
  [12 12 2]
  [12 12 3]
  [12 12 4]
  [12 12 5]
  [15 10 0]
  [15 10 1]
  [19 8 0]
  [17 9 0]
  [14 11 0]
  [14 11 1]
  [13 12 0]
  [13 12 1]
  [13 12 2]
  [13 12 3]
  [16 10 0]
  [16 10 1]
  [18 9 0]
  [18 9 1]
  [18 9 2]
  [15 11 0]
  [15 11 1]
  [15 11 2]
  [14 12 0]
  [13 13 0]
  [17 10 0]
  [19 9 0]
  [19 9 1]
  [19 9 2]
  [19 9 3]
  [25 7 0]
  [16 11 0]
  [16 11 1]
  [16 11 2]
  [16 11 3]
  [15 12 0]
  [15 12 1]
  [14 13 0]
  [14 13 1]
  [14 13 2]
  [14 13 3]
  [14 13 4]
  [17 11 0]
  [17 11 1]
  [21 9 0]
  [19 10 0]
  [19 10 1]
  [16 12 0]
  [16 12 1]
  [16 12 2]
  [15 13 0]
  [14 14 0]
  [14 14 1]
  [18 11 0]
  [18 11 1]
  [20 10 0]
  [20 10 1]
  [20 10 2]
  [20 10 3]
  [17 12 0]
  [17 12 1]
  [17 12 2]
  [23 9 0]
  [16 13 0]
  [19 11 0]
  [15 14 0]
  [15 14 1]
  [15 14 2]
  [15 14 3]
  [15 14 4]
  [15 14 5]
  [18 12 0]
  [18 12 1]
  [18 12 2]
  [18 12 3]
  [20 11 0]
  [17 13 0]
  [17 13 1]
  [17 13 2]
  [16 14 0]
  [15 15 0]
  [15 15 1]
  [15 15 2]
  [19 12 0]
  [19 12 1]
  [23 10 0]
  [21 11 0]
  [21 11 1]
  [21 11 2]
  [18 13 0]
  [18 13 1]
  [18 13 2]
  [18 13 3]
  [17 14 0]
  [17 14 1]
  [16 15 0]
  [16 15 1]
  [22 11 0]
  [22 11 1]
  [22 11 2]
  [22 11 3]
  [22 11 4]
  [19 13 0]
  [19 13 1]
  [19 13 2]
  [25 10 0]
  [25 10 1]
  [18 14 0]
  [18 14 1]
  [18 14 2]
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

(λ bf.ptr [distance]
  "Move pointer by `distance`"
  (if
    (> distance 0) (string.rep ">" distance)
    (< distance 0) (string.rep "<" (- distance))
    ""))

(λ bf.inc [value]
  "Add `value` to current cell"
  (if (> (math.abs value) 127)
    (if
      (> value 0) (string.rep "-" (- 256 value))
      (< value 0) (string.rep "+" (- 256 value))
      "")
    (if
      (> value 0) (string.rep "+" value)
      (< value 0) (string.rep "-" (- value))
      "")))

(λ bf.inc2 [value temp0]
  "Add `value` to the current cell, using `temp0`. `temp0` must be 0."
  (if (<= 0 (math.abs value) 255)
    (bf.shortest
      (bf.inc value)

      (if
        (> value 0)
        (..
          (bf.inc (. bf.factors value 3))
          (bf.at temp0
            (bf.inc (. bf.factors value 2))
            (bf.loop
              (bf.at (- temp0)
                (bf.inc (. bf.factors value 1)))
              "-")))

        (< value 0)
        (..
          (bf.inc (- (. bf.factors (- value) 3)))
          (bf.at temp0
            (bf.inc (. bf.factors (- value) 2))
            (bf.loop
              (bf.at (- temp0)
                (bf.inc (- (. bf.factors (- value) 1))))
              "-")))

        ""))
    (bf.inc value)))

(λ bf.zero []
  "Set current cell to 0"
  (bf.loop "-"))

(λ bf.set [value]
  "Set current cell to value"
  (..
    (bf.zero)
    (bf.inc value)))

(λ bf.set2 [value temp0]
  "Set current cell to value, using `temp0`. `temp0` must be 0."
  (..
    (bf.zero)
    (bf.inc2 value temp0)))

(λ bf.add! [to]
  "Destructively add current cell to `to`"
  (bf.loop
    (bf.ptr to)
    "+"
    (bf.ptr (- to))
    "-"))

(λ bf.mov! [to]
  "Destructively move current cell to `to`"
  (..
    (bf.at to
      (bf.zero))
    (bf.add! to)))

(λ bf.mov [to temp]
  "Move current cell to `to`, using `temp`"
  (..
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

(λ bf.not=! [y]
 "current cell <- current cell != y"
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

(λ bf.print! [str ?initial]
  "Print `str` using the current cell.
   The value of the current cell is assumed to be `?initial`, if given."
  (if ?initial

    (faccumulate [result ""
                  i 1 (length str)]
      (.. result
          (bf.inc (- (string.byte str i)
                     (or (string.byte str (- i 1)) ?initial)))
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
          (bf.inc2 (- (string.byte str i)
                      (or (string.byte str (- i 1)) ?initial))
                   temp0)
          "."))

    (..
      (bf.zero)
      (bf.print2! str temp0 0))))

(λ bf.optimize [code]
  "Remove useless combinations of brainfuck commands from `code`"
  (faccumulate [result code
                _ 1 100]
    (-> result
      (string.gsub "<>" "")
      (string.gsub "><" "")
      (string.gsub "%+%-" "")
      (string.gsub "%-%+" "")
      (string.gsub "%]%[%-%]" "]"))))

bf