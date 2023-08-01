(local actions       (require :telescope.actions))
(local action_set    (require :telescope.actions.set))
(local state         (require :telescope.actions.state))
(local pickers       (require :telescope.pickers))
(local entry_display (require :telescope.pickers.entry_display))
(local finders       (require :telescope.finders))
(local conf       (. (require :telescope.config) :values))

(local model     (require :ucm.model.init))
(local payloads  (require :ucm.model.payloads))
(local http      (require :ucm.model.http))
(local render    (require :ucm.render))
(local ucm-state (require :ucm.state))
(local utils     (require :ucm.utils))


(local display-items [ { :width 1 } {:width 48} { :remaining true } ])

(fn insert [bufnr item]
  (actions.close bufnr)
  (match item {:value {:tag "TermObject" :contents { :termName name :termHash hash }}}
                (vim.api.nvim_put (render.term (model.get-term name hash)) "" false true)
              {:value {:tag "TypeObject" :contents { :typeName name :typeHash hash }}}
                (vim.api.nvim_put (render.type (model.get-type name hash)) "" false true)
               other (utils.notify other)))

(fn handle [current_picker finder bufnr item] 
  (match item {:value {:tag "TypeObject"}} (insert bufnr item)
              {:value {:tag "TermObject"}} (insert bufnr item)
              {:value {:tag "PatchObject"}} nil
              {:value {:tag "Subnamespace"}} (do (ucm-state.set-path item) (current_picker:refresh finder { :reset_prompt: true :multi: current_picker._multi }))
              other (utils.notify other)))


(local displayer (entry_display.create { :separator " " :items display-items }))

(fn make-display [entry]
  (displayer (payloads.get-list-entry-display (. entry :value))))

(fn list-entry-maker [item]
  { :value item :display make-display :ordinal (payloads.get-list-entry-name item) }) 

(fn attach-mappings [bufnr _]
  "A callback for a chosen project"
  (do (action_set.select:replace_if (lambda [] true)
                                    (lambda [] 
                                      (let [selection      (state.get_selected_entry)
                                            current_picker (state.get_current_picker bufnr)
                                            finder         (. current_picker :finder)]
                                        (handle current_picker finder bufnr selection))))
      true))


(local M {})

(fn M.picker [opts]
  (let [opts (or opts {})
        get (lambda [] (payloads.from-list-root-payload (http.list (ucm-state.list-path-get))))]
       (pickers.new opts {:prompt_title "Namespaces"
                          :finder (finders.new_dynamic { :fn get :entry_maker list-entry-maker })
                          :attach_mappings attach-mappings
                          :sorter (conf.generic_sorter opts) })))

M
