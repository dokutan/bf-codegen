(local bf (require :fnl2bf))

;; There are multiple functions with the same signature to store a string in memory:
;; - string!       uses inc2 to set a cell for each byte in the string
;; - string-opt1!  uses either inc2 or copies (and modifies) the last byte
;; - string-opt2!  builds arbitrarily large loops to set multipe cells in one loop,
;;                 uses the bf.factors list to construct the loops
;; - string-opt3!  uses inc2-2 to set two cells in one loop
;; - string-opt4!  uses inc2-3 to set three cells in one loop
;; - string-opt5!  uses inc2-n to set up to ten (or a specified amount) cells in one loop
;; - string-opt6!  similar to string-opt5!, however the used cells can be initialized with a non-zero value

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
  (print "  string!      " (length (bf.optimize (bf.string! str 1))))
  (print "  string-opt1! " (length (bf.optimize (bf.string-opt1! str 1))))
  (print "  string-opt2! " (length (bf.optimize (bf.string-opt2! str 1))))
  (print "  string-opt3! " (length (bf.optimize (bf.string-opt3! str 1))))
  (print "  string-opt4! " (length (bf.optimize (bf.string-opt4! str 1))))
  (print "  string-opt5! " (length (bf.optimize (bf.string-opt5! str 1))))
  (print))
