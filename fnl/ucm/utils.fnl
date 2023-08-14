(local str   (require :nfnl.string))

(local M {})

;; TODO: make notify optional
;; TODO: add error/warning
(fn M.notify [x]
  ((require "notify") (vim.inspect x)))

(fn strip-prefix [seg prefix]
  (if (= prefix nil) seg (if (M.starts-with seg (.. prefix ".")) (seg:sub (+ (length prefix) 1)) seg)))

 (fn M.starts-with [s suffix]
  "Check if string s ends with a suffix"
  (or (= suffix "") (= (s:sub 1 (length suffix)) suffix)))

(fn M.find-by-key [tbl pred]
  "Find a value in a table, where key matches a predicate"
  (each [key val (pairs tbl)]
    (when (pred key)
      (lua "return val"))))

(fn M.init [xs]
  "Get all elements of the list except last one"
  (if (< (length xs) 2) [] (vim.list_slice xs 1 (- (length xs) 1))))

(fn M.split-string [str sep]
  (local t {})
  (each [str (string.gmatch str (.. "([^" sep "]+)"))] (table.insert t str))
  t)

(fn M.strip-hash [hash]
  "Remove `#` from `#abcdef`"
  (hash:sub 2))

M
