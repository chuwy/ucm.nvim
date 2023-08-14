(local actions       (require :telescope.actions))
(local action_set    (require :telescope.actions.set))
(local state         (require :telescope.actions.state))
(local pickers       (require :telescope.pickers))
(local entry_display (require :telescope.pickers.entry_display))
(local conf       (. (require :telescope.config) :values))

(local model     (require :ucm.model.init))
(local payloads  (require :ucm.model.payloads))
(local http      (require :ucm.model.http))
(local render    (require :ucm.render))
(local ucm-state (require :ucm.state))
(local utils     (require :ucm.utils))
(local debouncer (require :ucm.utils.debouncer))


(local display-items [ { :width 1 } { :width 48 } {:remaining true} ])

(fn run [get-fn name hash render-fn]
  (vim.cmd "norm! ggO")
  (vim.api.nvim_put (render-fn (get-fn name hash (ucm-state.get-relative-to))) "" false true))

(fn insert [bufnr item]
  (actions.close bufnr)
  (match item {:namedTerm {:termName name :termHash hash}}
                (run model.get-term name hash render.term)
              {:namedType {:typeName name :typeHash hash}}
                (run model.get-type name hash render.type)
               other (utils.notify other)))

(fn handle [bufnr item] 
  (let [value (. item :value)]
    (match value [_ {:tag :FoundTermResult :contents contents}] (insert bufnr contents)
                 [_ {:tag :FoundTypeResult :contents contents}] (insert bufnr contents)
                 other (utils.notify {:msg "find.handle match failed" :value other}))
    ))


(local displayer (entry_display.create { :separator " " :items display-items }))

(fn make-display [entry]
  (displayer (payloads.get-find-entry-display (. entry :value))))

(fn entry-maker [item]
  { :value item :display make-display :ordinal (payloads.get-find-entry-name item) })

(fn attach-mappings [bufnr _]
  "A callback for a chosen entry"
  (do (action_set.select:replace_if (lambda [] true)
                                    (lambda [] 
                                      (let [selection      (state.get_selected_entry)]
                                        (handle bufnr selection))))
      true))


(local M {})

(fn safe-iterate [body]
  "An attempt to solve a 'dead coroutine' problem when shutting down jobs, but doesn't really works out"
  (let [(success? result) (pcall vim.json.decode body)]
    (ipairs (if success? result []) )))

(fn async-fn [on-result on-complete]
  (let [relative-to (ucm-state.get-relative-to)]
    (if (= relative-to nil)
        (utils.notify "You project/branch are not selected. The search can be very slow. Pick one with `Telescope ucm list`"))
    (lambda [prompt]
        (let [process-body (lambda [res] (each [key value (safe-iterate res.body)] (on-result key value)) (on-complete))]
            (if (< (length prompt) 3)
                nil
                (http.find-async prompt (ucm-state.get-relative-to) process-body))))))

(fn M.picker [opts]
  (let [opts (or opts {})]
       (pickers.new opts {:prompt_title "Find"
                          :finder (debouncer.async_finder { :async_fn async-fn :entry_maker entry-maker })
                          :attach_mappings attach-mappings
                          :sorter (conf.generic_sorter opts) })))

M
