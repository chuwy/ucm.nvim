(local uv vim.loop)

(local telescope (require :telescope))

(local endpoint  (require :ucm.utils.endpoint))

(local list      (require :telescope._extensions.ucm.pickers.list))
(local find      (require :telescope._extensions.ucm.pickers.find))
(local projects  (require :telescope._extensions.ucm.pickers.projects))


; TODO we should also keep track somewhere if it's valid
(fn get-picker [p]
  "Return a lambda that keeps checking if the config.endpoint is set.
   And once it's set and 200 - run the picker"
  (var popup-open? false)
  (lambda [?opts]
    (let [timer (uv.new_timer)
          url   (endpoint.get)]
      (uv.timer_start timer 0 2000 (lambda [] 
    (if (= url nil)
        (if (= popup-open? false)
            (do (set popup-open? true)
                (vim.schedule (lambda [] (endpoint.check-endpoint url (lambda [] nil))))))
        (vim.schedule (lambda [] (timer:stop) (: (p ?opts) :find)))))))) 
  )


(telescope.register_extension { :setup (lambda [] nil)
                                :exports {
                                  :projects (get-picker projects.picker)
                                  :list     (get-picker list.picker)
                                  :find     (get-picker find.picker)
                                }
                              })

