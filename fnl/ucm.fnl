(local uv vim.loop)

(local config (require :ucm.config))

(local ucm-state (require :ucm.state))
(local utils     (require :ucm.utils))
(local path      (require :ucm.utils.path))

(fn get-state-file []
  (path.path_join (vim.fn.stdpath "data") "ucm.json"))

(fn create-state-file []
  (let [state-file (get-state-file)]
    (uv.fs_open (get-state-file) "w" 438
              (lambda [?err ?fd]
                (if (not= ?err nil)
                    (vim.schedule (lambda [] (utils.notify (.. "Could not create an ucm.nvim state file at " state-file))))
                    (uv.fs_write ?fd "{}" (lambda [] uv.fs_close ?fd)))))))

(fn notify-state-file-error [err]
  (vim.schedule (lambda [] (utils.notify "ucm.nvim state file error. " err))) )

(fn state-file-set [data]
  (let [parsed  (vim.json.decode data)
        project-branch (. parsed :project-branch)
        project        (if (= project-branch nil) nil (. project-branch :project))
        branch         (if (= project-branch nil) nil (. project-branch :branch))]
    (do 
      (ucm-state.set-project project)
      (ucm-state.set-branch  branch))))


(fn read-state-file []
  (uv.fs_open (get-state-file) "r" 438
              (lambda [?err ?fd]
                (if (= ?err nil)
                    (uv.fs_fstat ?fd
                                 (lambda [?err stat]
                                   (if (= ?err nil)
                                       (uv.fs_read ?fd stat.size 0
                                                   (lambda [?err data]
                                                     (if (= ?err nil)
                                                         (do (state-file-set data) (uv.fs_close ?fd))
                                                         (notify-state-file-error ?err))))
                                       (notify-state-file-error ?err))))
                    (create-state-file)))))

(local M {})

(fn M.setup [opts]
  (do
    (read-state-file)
    (set config.endpoint opts.endpoint)))

(fn M.save-state []
  (let [data {:project-branch (ucm-state.get-project-branch)}]
    (uv.fs_open (get-state-file) "w" 438
              (lambda [?open-err ?fd]
                (let [close (lambda [] uv.fs_close ?fd)]
                  (if (= ?open-err nil)
                      (uv.fs_write ?fd (vim.json.encode data) close)))))))
  
M
