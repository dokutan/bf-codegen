#!/usr/bin/env fennel
(local fennel (require :fennel))

(local forms {:fn     true
              :lambda true
              :λ      true
              :macro  true})

(fn ??. [t k ...]
  "Type-safe table lookup, returns nil if `t` is not a table"
  (if (not= 0 (length [...]))
    (when (= :table (type t))
      (??. (. t k) (table.unpack [...])))
    (when (= :table (type t))
      (. t k))))

(fn format-docs [form name args docstring]
  "Format one documentation entry."
  (string.format
    "## `%s` (%s)\n```(%s%s%s)```\n\n%s\n"
    name
    form
    name
    (if (not= "" args) " " "")
    args
    docstring))

(fn format-filename [filename]
  "Return the document title given the filename."
  (string.format
    "# %s\n"
    filename))

(fn print-docs [ast]
  "Print documentation for `ast`"
  (if
    (= :string (type ast))
    (print (.. ast "\n"))

    (. forms (??. ast 1 1))
    (let [print? (. forms (??. ast 1 1))]
      (when print? ;(and pos (= :string (type (??. ast pos))))
        (print
          (format-docs
            ;; form
            (??. ast 1)
            ;; name
            (??. ast 2)
            ;; args
            (table.concat
              (icollect [_ v (pairs (??. ast 3))]
                (. v 1))
              " ")
            ;; docstring
            (if (= :string (type (??. ast 4)))
              (string.gsub (??. ast 4) "\n[ \t]+" "\n")
              "*no docstring*")))))))


(each [_ file (ipairs arg)]
  (print (format-filename file))
  (let [file (io.open file)
        str (file:read "*a")
        parse (fennel.parser str)]

    (fn iterate []
      (let [(ok ast) (parse)]
        (when ok
          (do
            (print-docs ast)
            (iterate)))))
    (iterate)))
