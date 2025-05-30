(local bf (require :fnl2bf))

(var tests-passed 0)
(var tests-failed 0)

(lambda test [testid code before after ?output]
  "Assert that the brainfuck code `code` turns the memory from `before` into `after`."
  (var test-result :success)
  (let [code
        (-> code (string.gsub "0" "") (string.gsub "%[%-%]" "0"))

        luacode
        (faccumulate [luacode "ptr = 1\n"
                      i 1 (length code)]
          (..
            luacode
            (match (string.sub code i i)
              "[" "while data[ptr] ~= 0 do\n"
              "]" "end\n"
              "<" "ptr = ptr-1\n"
              ">" "ptr = ptr+1\n"
              "+" "data[ptr] = (data[ptr]+1) % 256\n"
              "-" "data[ptr] = (data[ptr]-1) % 256\n"
              "." "output = output .. string.char(data[ptr])"
              "0" "data[ptr] = 0\n"
              _   "")))

        data
        (faccumulate [data (tostring (. before 1))
                      i 2  (length before)]
          (.. data "," (. before i)))

        luacode
        (..
          "data = {" data "}\n"
          "output = ''\n"
          luacode
          "return data,output")

        (data output)
        ((load luacode))]

    (var show-after? false)
    (for [i 1 (length after)]
      (when (= :number (type (. after i)))
        (when (not= (. data i) (. after i))
          (print (.. "test '" testid "' failed at " i " (got " (. data i) ", expected " (. after i) ")"))
          (set test-result :failure)
          (set show-after? true))))
    (when show-after?
      (print (.. "expected: [" (table.concat after " ") "]"))
      (print (.. "received: [" (table.concat data " ") "]")))

    (when (not= output (or ?output ""))
      (print (.. "test '" testid "' failed (output was '" output "', expected '" (or ?output "") "')"))
      (set test-result :failure))

    (case test-result
      :success (set tests-passed (+ 1 tests-passed))
      :failure (set tests-failed (+ 1 tests-failed)))))

(for [i 1 255]
  (test
    (.. "inc2 " i)
    (bf.inc2 i 1)
    [0 0]
    [i 0]))

(for [i 1 255 10]
  (for [j 1 255 10]
    (test
      (.. "inc2-2 " i " " j)
      (bf.inc2-2 i j 1 2)
      [0 0 0]
      [i j 0])))

(test "zero? 0" (bf.zero? 1 2) [0 0 0] [0 0 1])
(test "zero? 1" (bf.zero? 1 2) [1 0 0] [1 0 0])
(test "zero? 9" (bf.zero? 1 2) [9 0 0] [9 0 0])

(test "=! 0 0" (bf.=! 1) [0 0] [1 0])
(test "=! 5 5" (bf.=! 1) [5 5] [1 0])
(test "=! 5 4" (bf.=! 1) [5 4] [0 0])

(test "not=! 0 0" (bf.not=! 1) [0 0] [0 0])
(test "not=! 5 5" (bf.not=! 1) [5 5] [0 0])
(test "not=! 5 4" (bf.not=! 1) [5 4] [1 0])

(test "<°! 0 0" (bf.<°!) [0 0 0 0] [0 0 0 0])
(test "<°! 5 5" (bf.<°!) [5 5 0 0] [0 0 0 0])
(test "<°! 5 4" (bf.<°!) [5 4 0 0] [0 0 0 0])
(test "<°! 4 5" (bf.<°!) [4 5 0 0] [1 0 0 0])
(test "<°! 3 5" (bf.<°!) [3 5 0 0] [1 0 0 0])

(test "swap" (bf.swap 1 2) [3 5 0] [5 3 0])

(test "mul!" (bf.mul! 1 2 3) [5 7 0 0] [35 7 0 0])

(for [i 1 15]
  (test (.. "square " i) (bf.square 1 2) [i 0 0] [(* i i) 0 0]))

(test "multiply-add!" (bf.multiply-add! 15 1) [3 5] [0 50])

(test "D.popcount°!" (bf.popcount°!) [0   0 0 0 0 0 0] [0 0 0 0 0 0 0])
(test "D.popcount°!" (bf.popcount°!) [200 0 0 0 0 0 0] [0 0 0 0 3 0 0])
(test "D.popcount°!" (bf.popcount°!) [123 0 0 0 0 0 0] [0 0 0 0 6 0 0])
(test "D.popcount°!" (bf.popcount°!) [255 0 0 0 0 0 0] [0 0 0 0 8 0 0])

(test "D.set 1234" (bf.D.set 1234) [0 0 0 0] [(% 1234 256) 0 0 (// 1234 256)])

(test "D.zero?! 0" (bf.D.zero?!) [0 0 0 0] [1 0 0 0])
(test "D.zero?! 1" (bf.D.zero?!) [3 0 0 0] [0 0 0 0])
(test "D.zero?! 2" (bf.D.zero?!) [0 0 0 3] [0 0 0 0])
(test "D.zero?! 3" (bf.D.zero?!) [3 0 0 3] [0 0 0 0])

(test
  "D.digits°"
  (bf.D.digits°)
  [(% 12345 256) 0 0 (// 12345 256) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [(% 12345 256) 0 0 (// 12345 256) 0 0 0 0 5 4 3 2 1 0])

(test
  "D.digits° ?+1"
  (bf.D.digits° true)
  [(% 12340 256) 0 0 (// 12340 256) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [(% 12340 256) 0 0 (// 12340 256) 0 0 0 0 1 5 4 3 2 0])

(test "shiftl°! 1" (bf.shiftl°!) [1 0] [0 2])
(test "shiftl°! 2" (bf.shiftl°!) [2 0] [0 4])
(test "shiftl°! 128" (bf.shiftl°!) [128 0] [0 0])

(test "rotatel°! 1" (bf.rotatel°!) [1 0 0 0 0] [2 0 0 0 0])
(test "rotatel°! 2" (bf.rotatel°!) [2 0 0 0 0] [4 0 0 0 0])
(test "rotatel°! 128" (bf.rotatel°!) [128 0 0 0 0] [1 0 0 0 0])

(test "rotatel°! 1 by 2" (bf.rotatel°! 2) [1 0 0 0 0 0] [4 0 0 0 0 0])
(test "rotatel°! 2 by 2" (bf.rotatel°! 2) [2 0 0 0 0 0] [8 0 0 0 0 0])
(test "rotatel°! 128 by 2" (bf.rotatel°! 2) [128 0 0 0 0 0] [2 0 0 0 0 0])

(test "rotater°! 1" (bf.rotater°!) [1 0 0 0 0 0] [128 0 0 0 0 0])
(test "rotater°! 2" (bf.rotater°!) [2 0 0 0 0 0] [1 0 0 0 0 0])
(test "rotater°! 128" (bf.rotater°!) [128 0 0 0 0 0] [64 0 0 0 0 0])

(test "rotater°! 1 by 2" (bf.rotater°! 2) [1 0 0 0 0 0] [64 0 0 0 0 0])
(test "rotater°! 2 by 2" (bf.rotater°! 2) [2 0 0 0 0 0] [128 0 0 0 0 0])
(test "rotater°! 128 by 2" (bf.rotater°! 2) [128 0 0 0 0 0] [32 0 0 0 0 0])

(test "array1.sumr" (bf.array1.sumr) [0 1 2 3 4 0] [0 0 0 0 10 0])
(test "array1.suml" (.. ">>>>>" (bf.array1.suml)) [0 1 2 3 4 0] [0 10 0 0 0 0])

(test "array1.map" (.. ">>>>>" (bf.array1.map 1 "+++")) [0 1 2 3 4 0 0] [0 4 5 6 7 0 0])

(test "print-cell° 0" (bf.print-cell°) [0 0 0 0 0 0 0 0 0 0] [0 0 0 0 0 0 0 0 0 0] "0")
(test "print-cell° 10" (bf.print-cell°) [10 0 0 0 0 0 0 0 0 0] [10 0 0 0 0 0 0 0 0 0] "10")
(test "print-cell° 255" (bf.print-cell°) [255 0 0 0 0 0 0 0 0 0] [255 0 0 0 0 0 0 0 0 0] "255")

(test "D.print-cell° 0"
  (bf.D.print-cell°)
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "0")

(test "D.print-cell° 255"
  (bf.D.print-cell°)
  [255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "255")

(test "D.print-cell° 7682"
  (bf.D.print-cell°)
  [2 0 0 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [2 0 0 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "7682")

(test "D.print-cell° 65535"
  (bf.D.print-cell°)
  [255 0 0 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [255 0 0 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "65535")

(test "Q.print-cell° 0"
  (.. ">" (bf.Q.print-cell°))
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "0")

(test "Q.print-cell° 255"
  (.. ">" (bf.Q.print-cell°))
  [0 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "255")

(test "Q.print-cell° 7682"
  (.. ">" (bf.Q.print-cell°))
  [0 2 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 2 30 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  "7682")

;; this is slow:
;; (test "Q.print-cell° 65535"
;;   (.. ">" (bf.Q.print-cell°))
;;   [0 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
;;   [0 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
;;   "65535")

(test "bf.arrayN.shiftr"
  (.. (bf.ptr 12) (bf.arrayN.shiftr 2 3))
  [0 0 0 1 0 0 1 2 2 1 3 3 0 0 0 0]
  [0 0 0 0 0 0 1 0 0 1 2 2 1 3 3 0])

(test "bf.arrayN.shiftl"
  (.. (bf.ptr 5) (bf.arrayN.shiftl 2 3))
  [0 0 0 0 0 0 1 0 0 1 2 2 1 3 3 0]
  [0 0 0 1 0 0 1 2 2 1 3 3 0 0 0 0])

(test "bf.arrayN.split"
  (.. (bf.ptr 12) (bf.arrayN.split 2))
  [0 0 0 1 0 0 1 2 2 1 3 3 0 1]
  [1 0 0 1 2 2 0 0 0 1 3 3 0 0])

(test "bf.arrayN.split mirrored"
  (.. (bf.ptr 1) (bf.mirror (bf.arrayN.split 2)))
  [1 0 3 3 1 2 2 1 0 0 1 0 0 0]
  [0 0 3 3 1 0 0 0 2 2 1 0 0 1])

(test "bf.arrayN.get 2"
  (.. (bf.ptr 15) (bf.arrayN.get 2))
  [0 0 0 0 0 0 1 0 0 1 8 9 1 3 3 0 1 0 0]
  [0 0 0 0 0 0 1 0 0 1 8 9 1 3 3 0 0 8 9])

(test "bf.arrayN.get 3"
  (.. (bf.ptr 20) (bf.arrayN.get 3))
  [0 0 0 0 0 0 0 0 1 0 0 0 1 7 8 9 1 3 3 3 0 1 0 0 0 0]
  [0 0 0 0 0 0 0 0 1 0 0 0 1 7 8 9 1 3 3 3 0 0 0 7 8 9])

(test "bf.arrayN.set 2"
  (.. (bf.ptr 15) (bf.arrayN.set 2))
  [0 0 0 0 0 0 1 0 0 1 2 2 1 3 3 0 1 8 9]
  [0 0 0 0 0 0 1 0 0 1 8 9 1 3 3 0 0 0 0])

(test "bf.arrayN.set 3"
  (.. (bf.ptr 20) (bf.arrayN.set 3))
  [0 0 0 0 0 0 0 0 1 0 0 0 1 2 2 2 1 3 3 3 0 1 7 8 9]
  [0 0 0 0 0 0 0 0 1 0 0 0 1 7 8 9 1 3 3 3 0 0 0 0 0])

(print (.. tests-passed "/" (+ tests-passed tests-failed) " tests passed"))

(if (not= 0 tests-failed)
  (os.exit 1))
