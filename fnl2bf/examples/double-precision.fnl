(local bf (require :fnl2bf))

;; It is possible double the precision of the interpreter, using 4 8-bit cells to represent a 16-bit cell.
;; See https://esolangs.org/wiki/Brainfuck_bitwidth_conversions for details.


(local double-precision-example
  (..
    
    ;; bf.double applies the "1→2 No Copy" conversion
    ;; this results in:
    ;; 255(low) 0(reserved) 0(reserved) 255(high)
    ;; ^
    (bf.double "-")
    
    ;; Any function that doesn't rely on 8-bit wrapping cells can be used with bf.double:
    (bf.double
      (bf.zero)
      (bf.inc 10))
    
    ;; this is equivalent to (bf.ptr 4) or ">>>>"
    (bf.D.ptr 1)

    ;; it is shorter to avoid bf.double if possible
    (bf.inc2 100 1)

    (bf.double
      "<"
      (bf.mul! 1 2 3))
    
    ;; bf.print-cell° only works for 8-bit cells, use bf.D.print-cell° instead:
    (bf.D.print-cell°)

    ;; shorter than (bf.double (bf.zero))
    (bf.D.zero)
    
    (bf.print! "\n")))

(print double-precision-example)
