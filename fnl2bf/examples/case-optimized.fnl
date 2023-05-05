(local bf (require :fnl2bf))

(fn case-optimized [[init1 init2]]
  (..
    ","

    (bf.case2! 2 1 :init init1
      "9" (bf.print2! "nine" 1 init1)
      "8" (bf.print2! "eight" 1 init1)
      "7" (bf.print2! "seven" 1 init1)
      "6" (bf.print2! "six" 1 init1)
      "5" (bf.print2! "five" 1 init1)
      "4" (bf.print2! "four" 1 init1)
      "3" (bf.print2! "three" 1 init1)
      "2" (bf.print2! "two" 1 init1)
      "1" (bf.print2! "one" 1 init1)
      "0" (bf.print2! "zero" 1 init1)

      ["A" "B" "C" "D" "E" "F" "G" "H" "I"
       "J" "K" "L" "M" "N" "O" "P" "Q" "R"
       "S" "T" "U" "V" "W" "X" "Y" "Z"]
      (bf.print2! "uppercase letter" 1 init1)

      ["a" "b" "c" "d" "e" "f" "g" "h" "i"
       "j" "k" "l" "m" "n" "o" "p" "q" "r"
       "s" "t" "u" "v" "w" "x" "y" "z"]
      (bf.print2! "lowercase letter" 1 init1)

      ;; default
      (bf.print2! "unknown character" 1 init1))


    ","
    (bf.inc (- (string.byte "0")))

    (bf.shortest
      (bf.case! 1 :init init2
        9 (bf.print2! "nine"  1 init2)
        8 (bf.print2! "eight" 1 init2)
        7 (bf.print2! "seven" 1 init2)
        6 (bf.print2! "six"   1 init2)
        5 (bf.print2! "five"  1 init2)
        4 (bf.print2! "four"  1 init2)
        3 (bf.print2! "three" 1 init2)
        2 (bf.print2! "two"   1 init2)
        1 (bf.print2! "one"   1 init2)
        0 (bf.print2! "zero"  1 init2))
      (bf.case! 1 :init init2
        0 (bf.print2! "zero"  1 init2)
        1 (bf.print2! "one"   1 init2)
        2 (bf.print2! "two"   1 init2)
        3 (bf.print2! "three" 1 init2)
        4 (bf.print2! "four"  1 init2)
        5 (bf.print2! "five"  1 init2)
        6 (bf.print2! "six"   1 init2)
        7 (bf.print2! "seven" 1 init2)
        8 (bf.print2! "eight" 1 init2)
        9 (bf.print2! "nine"  1 init2)))))

(print
  (bf.optimize2
    (case-optimized
      (bf.optimize-parms case-optimized [[1 255] [1 255]] true "case-optimized.jl"))))
