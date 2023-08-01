(local config (require :ucm.config))


(local M {})

(fn M.setup [opts]
  (do
    (set config.endpoint opts.endpoint)))

M
