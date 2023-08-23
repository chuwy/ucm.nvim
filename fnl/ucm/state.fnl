(local payloads (require :ucm.model.payloads))


;; Global mutable state
(local M { })

;; Here we save the path we're at, when using `list` picker
(set M.list-path [])

(set M.project-branch {})

(fn M.get-relative-to []
  (match M.project-branch 
    {:project nil :branch nil}        nil
    {:project project :branch nil}    (.. "__projects." project)
    {:project project :branch branch} (.. "__projects." project ".branches." branch)))

(fn M.get-project-branch []
  M.project-branch)

(fn M.list-path-root? []
  "Are we at the root (`/`)?"
  (= M.list-path []))

(fn M.get-project-branch-path []
  "Just `project/branch` pair"
  (match M.project-branch 
    {:project nil :branch nil}        nil
    {:project project :branch nil}    project
    {:project project :branch branch} (.. project "/" branch)))

(fn M.get-project []
  (if (= M.project-branch nil) nil (. M.project-branch :project)))
(fn M.get-branch []
  (if (= M.project-branch nil) nil (. M.project-branch :branch)))

(fn M.set-project [project-name]
  (if (not= project-name (M.get-project))   ; Reset branch and path only if we change project
      (do
        (set M.project-branch {:project project-name :branch nil})
        (set M.list-path []))))

(fn M.set-branch [branch-name]
  (if (not= branch-name (M.get-branch))   ; Reset branch and path only if we change project
      (do 
          (set M.project-branch.branch branch-name)
          (set M.list-path []))))

(fn M.list-path-get []
  (table.concat M.list-path "."))

(fn M.list-path-get-fqn [name]
  (table.concat (vim.list_extend M.list-path [name]) "."))

(fn M.set-path [selection]
  (let [value (. selection :value)
        name  (payloads.get-list-entry-name value)]
    (if (= name "..")
      (table.remove M.list-path)
      (if (not= M.list-path [])
          (table.insert M.list-path name)))))
    

M
