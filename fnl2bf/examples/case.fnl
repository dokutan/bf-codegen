(local bf (require :fnl2bf))

(print
  (..
    ","

    (bf.case2! 2 1
      "9" (bf.print2! "nine" 1)
      "8" (bf.print2! "eight" 1)
      "7" (bf.print2! "seven" 1)
      "6" (bf.print2! "six" 1)
      "5" (bf.print2! "five" 1)
      "4" (bf.print2! "four" 1)
      "3" (bf.print2! "three" 1)
      "2" (bf.print2! "two" 1)
      "1" (bf.print2! "one" 1)
      "0" (bf.print2! "zero" 1)

      ["A" "B" "C" "D" "E" "F" "G" "H" "I"
       "J" "K" "L" "M" "N" "O" "P" "Q" "R"
       "S" "T" "U" "V" "W" "X" "Y" "Z"]
      (bf.print2! "uppercase letter" 1)

      ["a" "b" "c" "d" "e" "f" "g" "h" "i"
       "j" "k" "l" "m" "n" "o" "p" "q" "r"
       "s" "t" "u" "v" "w" "x" "y" "z"]
      (bf.print2! "lowercase letter" 1)

      ;; default
      (bf.print2! "unknown character" 1))))

(print
  (..
    ","
    (bf.inc (- (string.byte "0")))

    (bf.case! 1
      9 (bf.print2! "nine" 1)
      8 (bf.print2! "eight" 1)
      7 (bf.print2! "seven" 1)
      6 (bf.print2! "six" 1)
      5 (bf.print2! "five" 1)
      4 (bf.print2! "four" 1)
      3 (bf.print2! "three" 1)
      2 (bf.print2! "two" 1)
      1 (bf.print2! "one" 1)
      0 (bf.print2! "zero" 1))))
