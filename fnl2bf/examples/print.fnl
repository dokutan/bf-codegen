(local bf (require :fnl2bf))

;; There are multiple functions to print a string:
;; - print!            uses only the current cell
;; - print2!           uses the current cell and one additional cell
;; - print2+!          uses the current cell and one additional cell
;; - print3!           uses the current cell and two additional cells
;; - print-from-memory uses arbitrarily many cells

(local test-strings [
    "Hello world!"
    "123456789"
    "a b c d"
    "A1b2C3"
    "****"
    "*****"
    "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
    "-j!b(x6k,IOo`AnRM+Q.2/qHa}^#3\"g81Dz%4VTPFpY:Jl|5Ge>'B$tu]&N0K7mSrLf[X9iZCyd~svE){h_<@\\w?*=WcU;"
])

(each [_ str (ipairs test-strings)]
  (print str)
  (print "  print!   " (length (bf.optimize (bf.print! str))))
  (print "  print2!  " (length (bf.optimize (bf.print2! str 1))))
  (print "  print2+! " (length (bf.optimize (bf.print2+! str 1))))
  (print "  print3!  " (length (bf.optimize (bf.print3! str 1 2))))
  (print))
