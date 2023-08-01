(local actions       (require :telescope.actions))
(local state         (require :telescope.actions.state))
(local pickers       (require :telescope.pickers))
(local finders       (require :telescope.finders))
(local conf       (. (require :telescope.config) :values))

(local http      (require :ucm.model.http))
(local payloads  (require :ucm.model.payloads))


(fn attach-mappings [bufnr _]
  "A callback for a chosen project"
  (do (actions.select_default:replace (lambda []
                                          (let [selection (state.get_selected_entry)]
                                              (do (actions.close bufnr)
                                                  (vim.api.nvim_put [(. selection :display)] "" false true)))))
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
