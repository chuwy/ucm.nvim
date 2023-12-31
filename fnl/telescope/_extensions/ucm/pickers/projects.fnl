(local actions       (require :telescope.actions))
(local state         (require :telescope.actions.state))
(local pickers       (require :telescope.pickers))
(local finders       (require :telescope.finders))
(local conf       (. (require :telescope.config) :values))

(local ucm-state  (require :ucm.state))
(local http       (require :ucm.model.http))
(local payloads   (require :ucm.model.payloads))

(local branches  (require :telescope._extensions.ucm.pickers.branches))

(fn attach-mappings [bufnr _]
  "A callback for a chosen project"
  (do (actions.select_default:replace (lambda []
                                          (let [selection (state.get_selected_entry)]
                                              (do (ucm-state.set-project (payloads.get-project-name (. selection :value)))
                                                  (actions.close bufnr)
                                                  (: (branches:picker {}) :find)))))   ;; TODO: might need to pass actual opts
      true))

(fn entry-maker [project]
  (let [project-name (payloads.get-project-name project)]
    {:value project :display project-name :ordinal project-name}))

(local M {})

(fn M.picker [opts]
  (let [opts (or opts {})]
       (pickers.new opts {:prompt_title "Unison Projects"
                          :finder (finders.new_table { :results (http.projects) :entry_maker entry-maker })
                          :attach_mappings attach-mappings
                          :sorter (conf.generic_sorter opts) })
           )
  )

M
