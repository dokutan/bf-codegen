(local bf (require :fnl2bf))

(print
  (bf.optimize
    (..
      ","
      (bf.loop
        (bf.if= (string.byte "A" 1) 1 2
          (bf.print! "▄ ▄▄▄"))
        (bf.if= (string.byte "B" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄ ▄"))
        (bf.if= (string.byte "C" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄▄▄ ▄"))
        (bf.if= (string.byte "D" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄"))
        (bf.if= (string.byte "E" 1) 1 2
          (bf.print! "▄"))
        (bf.if= (string.byte "F" 1) 1 2
          (bf.print! "▄ ▄ ▄▄▄ ▄"))
        (bf.if= (string.byte "G" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄"))
        (bf.if= (string.byte "H" 1) 1 2
          (bf.print! "▄ ▄ ▄ ▄"))
        (bf.if= (string.byte "I" 1) 1 2
          (bf.print! "▄ ▄"))
        (bf.if= (string.byte "J" 1) 1 2
          (bf.print! "▄ ▄▄▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "K" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄▄▄"))
        (bf.if= (string.byte "L" 1) 1 2
          (bf.print! "▄ ▄▄▄ ▄ ▄"))
        (bf.if= (string.byte "M" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "N" 1) 1 2
          (bf.print! "▄▄▄ ▄"))
        (bf.if= (string.byte "O" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "P" 1) 1 2
          (bf.print! "▄ ▄▄▄ ▄▄▄ ▄"))
        (bf.if= (string.byte "Q" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄ ▄▄▄"))
        (bf.if= (string.byte "R" 1) 1 2
          (bf.print! "▄ ▄▄▄ ▄"))
        (bf.if= (string.byte "S" 1) 1 2
          (bf.print! "▄ ▄ ▄"))
        (bf.if= (string.byte "T" 1) 1 2
          (bf.print! "▄▄▄"))
        (bf.if= (string.byte "U" 1) 1 2
          (bf.print! "▄ ▄ ▄▄▄"))
        (bf.if= (string.byte "V" 1) 1 2
          (bf.print! "▄ ▄ ▄ ▄▄▄"))
        (bf.if= (string.byte "W" 1) 1 2
          (bf.print! "▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "X" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄ ▄▄▄"))
        (bf.if= (string.byte "Y" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "Z" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄ ▄"))
        (bf.if= (string.byte "0" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄▄▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "1" 1) 1 2
          (bf.print! "▄ ▄▄▄ ▄▄▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "2" 1) 1 2
          (bf.print! "▄ ▄ ▄▄▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "3" 1) 1 2
          (bf.print! "▄ ▄ ▄ ▄▄▄ ▄▄▄"))
        (bf.if= (string.byte "4" 1) 1 2
          (bf.print! "▄ ▄ ▄ ▄ ▄▄▄"))
        (bf.if= (string.byte "5" 1) 1 2
          (bf.print! "▄ ▄ ▄ ▄ ▄"))
        (bf.if= (string.byte "6" 1) 1 2
          (bf.print! "▄▄▄ ▄ ▄ ▄ ▄"))
        (bf.if= (string.byte "7" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄ ▄ ▄"))
        (bf.if= (string.byte "8" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄▄▄ ▄ ▄"))
        (bf.if= (string.byte "9" 1) 1 2
          (bf.print! "▄▄▄ ▄▄▄ ▄▄▄ ▄▄▄ ▄"))
        (bf.if= (string.byte " " 1) 1 2
          (bf.print! "    "))
        
        (bf.print! "   ")
        ","))))