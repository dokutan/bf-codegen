(local bf {})

(fn bf.loop [...]
  "A loop: [...]"
  (.. "[" (table.concat [...] "") "]"))

(fn bf.at [distance ...]
  "Move pointer by `distance`, insert body, move back"
  (..
    (bf.ptr distance)
    (table.concat [...] "")
    (bf.ptr (- distance))))

(fn bf.ptr [distance]
  "Move pointer by `distance`"
  (if
    (> distance 0) (string.rep ">" distance)
    (< distance 0) (string.rep "<" (- distance))
    ""))

(fn bf.inc [value]
  "Add `value` to current cell"
  (if
    (> value 0) (string.rep "+" value)
    (< value 0) (string.rep "-" (- value))
    ""))

(fn bf.zero []
  "Set current cell to 0"
  (bf.loop "-"))

(fn bf.set [value]
  "Set current cell to value"
  (..
    (bf.zero)
    (bf.inc value)))

(fn bf.add! [to]
  "Destructively add current cell to `to`"
  (bf.loop
    (bf.ptr to)
    "+"
    (bf.ptr (- to))
    "-"))

(fn bf.mov! [to]
  "Destructively move current cell to `to`"
  (..
    (bf.at to
      (bf.zero))
    (bf.add! to)))

(fn bf.mov [to temp]
  "Move current cell to `to`, using `temp`"
  (..
    (bf.loop
      (bf.ptr to)
      "+"
      (bf.ptr (- temp to))
      "+"
      (bf.ptr (- temp))
      "-")

    ;; restore original value
    (bf.ptr temp)
    (bf.add! (- temp))
    (bf.ptr (- temp))))

(fn bf.not=! [y]
 "current cell <- current cell != y"
 (..
  (bf.loop
    (bf.at y
      "-")
    "-")
  (bf.at y
    (bf.loop
      (bf.zero)
      (bf.at (- y)
        "+")))))

(fn bf.if= [value temp0 temp1 ...]
  "If current cell == `value`, then ..."
  (..
    (bf.mov temp0 temp1)
    (bf.at temp1
      (bf.set value))
    (bf.at temp0
      (bf.not=! (- temp1 temp0))
      "-"
      (bf.loop
        (table.concat [...] "")
        (bf.zero)))))

(fn bf.print! [str]
  "Print `str` using the current cell"
  (faccumulate [result (bf.zero)
                i 1 (length str)]
    (.. result
        (bf.inc (- (string.byte str i) 
                   (or (string.byte str (- i 1)) 0)))
        ".")))

(fn bf.optimize [code]
  "Remove useless combinations of brainfuck commands from `code`"
  (faccumulate [result code
                _ 1 100]
    (-> result
      (string.gsub "<>" "")
      (string.gsub "><" "")
      (string.gsub "%+%-" "")
      (string.gsub "%-%+" "")
      (string.gsub "%]%[%-%]" "]"))))

bf