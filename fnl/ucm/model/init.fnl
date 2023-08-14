(local http  (require :ucm.model.http))
(local utils (require :ucm.utils))


(local M {})

;; TODO - if there's only one key-value - get it (e.g. `Any` type)

(fn M.get-term [name hash relative-to]
  (. (. (http.get-definition name relative-to) :termDefinitions) hash))

(fn M.get-type [name hash relative-to]
  (let [definitions (. (http.get-definition name relative-to) :typeDefinitions)]
    (utils.find-by-key definitions (lambda [key] (utils.starts-with key hash)))))

M
