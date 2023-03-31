(local bf (require :fnl2bf))

;; https://code.golf/arabic-to-roman#brainfuck

(fn arabic->roman []
  (bf.optimize
    (..
      ","
      (bf.loop
        (bf.loop (bf.inc2 -48 1) ">,")

        (bf.ptr -4)
        (bf.loop
          (bf.at -1
            (bf.print2! "M" -1))
          "-")
        
        (bf.ptr 1)
        (bf.case2! -2 -1
          1 (bf.print2! "C" -1)
          2 (bf.print2! "CC" -1)
          3 (bf.print2! "CCC" -1)
          4 (bf.print2! "CD" -1)
          5 (bf.print2! "D" -1)
          6 (bf.print2! "DC" -1)
          7 (bf.print2! "DCC" -1)
          8 (bf.print2! "DCCC" -1)
          9 (bf.print2! "CM" -1))

        (bf.ptr 1)
        (bf.case2! -2 -1
          1 (bf.print2! "X" -1)
          2 (bf.print2! "XX" -1)
          3 (bf.print2! "XXX" -1)
          4 (bf.print2! "XL" -1)
          5 (bf.print2! "L" -1)
          6 (bf.print2! "LX" -1)
          7 (bf.print2! "LXX" -1)
          8 (bf.print2! "LXXX" -1)
          9 (bf.print2! "XC" -1))

        (bf.ptr 1)
        (bf.case2! -2 -1
          1 (bf.print2! "I" -1)
          2 (bf.print2! "II" -1)
          3 (bf.print2! "III" -1)
          4 (bf.print2! "IV" -1)
          5 (bf.print2! "V" -1)
          6 (bf.print2! "VI" -1)
          7 (bf.print2! "VII" -1)
          8 (bf.print2! "VIII" -1)
          9 (bf.print2! "IX" -1))

        (bf.print! "\n")
        (bf.zero)
        ","))))

(print (arabic->roman))
