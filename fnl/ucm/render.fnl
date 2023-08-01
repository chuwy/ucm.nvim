(local nfnl       (require :nfnl.core))

(local utils      (require :ucm.utils))


(local colors {
  :TypeObject       :TelescopeResultsClass
  :TermObject       :TelescopeResultsVariable
  :Subnamespace     :TelescopeResultsConstant

  :SubnamespaceSize "@comment"
})

(local icons {
  :TypeObject       ""
  :TermObject       "󰊕"
  :Subnamespace     ""

  :SubnamespaceSize "󱞪"
})


;; Everything related to rendering terms and types
(local M {})

(fn M.trm [name]
  (let [t :TermObject]
    [[(. icons t) (. colors t)] name]))
(fn M.trm-typed [name tpe]
  (let [t :TermObject
        type (table.concat (M.segments tpe) " ")]
    [[(. icons t) (. colors t)] name [type "@comment"]]))

(fn M.tpe [name]
  (let [t :TypeObject]
    [[(. icons t) (. colors t)] name]))
(fn M.tpe-typed [name tpe]
  (let [t :TypeObject
        type (table.concat (M.segments tpe) " ")]
    [[(. icons t) (. colors t)] name [type "@comment"]]))

(fn M.namespace [name]
  (let [t :Subnamespace]
    [[(. icons t) (. colors t)] name]))

(fn M.colored [s tag]
  [s (. colors tag)])

(fn M.segments [segments]
  (nfnl.reduce (lambda [acc cur]
                 (do  (match cur
                             {:segment "\n"} (vim.list_extend acc [""])
                             {:segment seg}  (vim.list_extend (utils.init acc) [(.. (nfnl.last acc) seg)])))
                 ) [""] segments))

(fn M.term [item]
  (M.segments item.termDefinition.contents))

(fn M.type [item]
  (M.segments item.typeDefinition.contents))

M
