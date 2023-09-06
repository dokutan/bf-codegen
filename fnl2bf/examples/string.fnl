(local bf (require :fnl2bf))

;; There are multiple functions with the same signature to store a string in memory:
;; - string!       uses inc2 to set a cell for each byte in the string
;; - string-opt1!  uses either inc2 or copies (and modifies) the last byte
;; - string-opt2!  builds arbitrarily large loops to set multipe cells in one loop,
;;                 uses the bf.factors list to construct the loops
;; - string-opt3!  uses inc2-2 to set two cells in one loop
;; - string-opt4!  uses inc2-4 to set three cells in one loop

(local test-strings [
    "Hello world!"
    "123456789"
    "a b c d"
    "A1b2C3"
    "****"
    "*****"
])

(each [_ str (ipairs test-strings)]
  (print str)
  (print "  string!      " (length (bf.optimize (bf.string! str 1))))
  (print "  string-opt1! " (length (bf.optimize (bf.string-opt1! str 1))))
  (print "  string-opt2! " (length (bf.optimize (bf.string-opt2! str 1))))
  (print "  string-opt3! " (length (bf.optimize (bf.string-opt3! str 1))))
  (print "  string-opt4! " (length (bf.optimize (bf.string-opt4! str 1))))
  (print))