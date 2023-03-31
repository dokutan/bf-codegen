(local bf (require :fnl2bf))

;; https://code.golf/12-days-of-christmas#brainfuck

(local move-back "<[<]")

(local space 10)

(local init
  (..
    (bf.string-opt2! "On the " 1) ">"
    (bf.string-opt2! " day of Christmas\nMy true love sent to me\n" 1) ">"
    (bf.string-opt2! (string.reverse "A Partridge in a Pear Tree.\n\n") 1) ">"
    (bf.string-opt2! (string.reverse "Two Turtle Doves, and") 1) ">"
    (bf.string-opt2! (string.reverse "Three French Hens,") 1) ">"
    (bf.string-opt2! (string.reverse "Four Calling Birds,") 1) ">"
    (bf.string-opt2! (string.reverse "Five Gold Rings,") 1) ">"
    (bf.string-opt2! (string.reverse "Six Geese-a-Laying,") 1) ">"
    (bf.string-opt2! (string.reverse "Seven Swans-a-Swimming,") 1) ">"
    (bf.string-opt2! (string.reverse "Eight Maids-a-Milking,") 1) ">"
    (bf.string-opt2! (string.reverse "Nine Ladies Dancing,") 1) ">"
    (bf.string-opt2! (string.reverse "Ten Lords-a-Leaping,") 1) ">"
    (bf.string-opt2! (string.reverse "Eleven Pipers Piping,") 1) ">"
    (bf.string-opt2! (string.reverse "Twelve Drummers Drumming,") 1)
    (string.rep move-back 14)))

(fn print-part [str]
  (..
    ">[.>]" ; On the
    (bf.print! str) (bf.zero)
    ">[.>]" ; day of ...
    ">[>]" (string.rep "+" space) "<" ; move to current end, add space
    "[.<]" ; print
    move-back
    move-back))

(print
  (bf.optimize
    (..
      init
      (print-part "First")
      (print-part "Second")
      (print-part "Third")
      (print-part "Fourth")
      (print-part "Fifth")
      (print-part "Sixth")
      (print-part "Seventh")
      (print-part "Eighth")
      (print-part "Ninth")
      (print-part "Tenth")
      (print-part "Eleventh")
      (print-part "Twelfth"))))
