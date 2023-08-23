(local utils    (require :ucm.utils))
(local payloads (require :ucm.model.payloads))


(fn parse-project-branch [path]
  (let [sliced (vim.list_slice (utils.split-string path ".") 1 4)]
    (match sliced
         ["__projects" project "branches" branch] {:project project :branch branch}
         ["__projects" project "branches"]        {:project project :branch nil}
         ["__projects" project]                   {:project project :branch nil}
         _                                        {:project nil     :branch nil})))


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
  (set M.project-branch {:project project-name :branch nil}))
(fn M.set-branch [branch-name]
  (set M.project-branch.branch branch-name))

(fn M.list-path-get []
  (table.concat M.list-path "."))

(fn M.list-path-get-fqn [name]
  (table.concat (vim.list_extend M.list-path [name]) "."))

;; TODO: care about project/branch here?!
(fn M.set-path [selection]
  (let [value (. selection :value)
        name  (payloads.get-list-entry-name value)]
    (if (= name "..")
      (table.remove M.list-path)
      (if (not= M.list-path [])
          (table.insert M.list-path name)))

    (let [project-branch (parse-project-branch (M.list-path-get))]
     (set M.project-branch project-branch))))
    

M
