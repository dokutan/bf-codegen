(local bf (require :fnl2bf))

(print
  (..
    (bf.print! "Hello world!\n")

    ;; set current cell to the ASCII value of '1'
    (bf.set (string.byte "1" 1))

    ;; move one cell to the right
    (bf.ptr 1)

    ;; set current cell to 9
    (bf.set 9)

    (bf.loop
      ;; move one cell to the left
      (bf.at -1
        ".+") ; print, increment current cell and move back

      (bf.inc -1) ; decrement current cell)
      )
    
    (bf.print! "\n")))
