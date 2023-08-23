(local actions       (require :telescope.actions))
(local state         (require :telescope.actions.state))
(local pickers       (require :telescope.pickers))
(local finders       (require :telescope.finders))
(local conf       (. (require :telescope.config) :values))

(local ucm-state  (require :ucm.state))
(local utils      (require :ucm.utils))
(local http       (require :ucm.model.http))
(local payloads   (require :ucm.model.payloads))


(fn attach-mappings [bufnr _]
  "A callback for a chosen branch"
  (do (actions.select_default:replace (lambda []
                                          (let [selection (state.get_selected_entry)
                                                branch    (payloads.get-branch-name (. selection :value))]
                                              (do (actions.close bufnr)
                                                  (ucm-state.set-branch branch)
                                                  (utils.notify (.. "Working on " (ucm-state.get-project-branch-path)))))))
      true))

(fn entry-maker [branch]
  (let [branch-name (payloads.get-branch-name branch)]
    {:value branch :display branch-name :ordinal branch-name}))

(local M {})

(fn M.picker [opts]
  (let [opts (or opts {})
        project (ucm-state.get-project)]
       (if
         (= project nil)
         {:find (lambda [_] (utils.notify "You must pick a project first: `:Telescope ucm projects`"))} 
         (pickers.new opts {:prompt_title (.. "Branches of " project)
                            :finder (finders.new_table { :results (http.branches project) :entry_maker entry-maker })
                            :attach_mappings attach-mappings
                            :sorter (conf.generic_sorter opts) }))))

M
