(local utils  (require :ucm.utils))
(local render (require :ucm.render))


(local M {})
  
(fn M.get-find-entry-display [entry]
  "Get a Telescope entry for entries server by `/list` endpoint"
  (match entry [_ {:contents {:namedTerm {:termName name :termType tpe}}}]             (render.trm-typed name tpe)
               [_ {:contents {:namedType {:typeName name} :typeDef {:contents tpe}}}]  (render.tpe-typed name tpe)
               other (utils.notify other)))

(fn M.get-find-entry-name [entry]
  "Get a Telescope entry for entries server by `/find` endpoint"
  (match entry [_ {:contents {:namedTerm {:termName name :termType t}}}] name
               [_ {:contents {:namedType {:typeName name }}}] (.. name " type")
               other (utils.notify other)))


;; A made-up special namespace that represnents a parent-level
(set M.up-namespace {:contents {:namespaceName ".." :namespaceHash nil :namespaceSize nil} :tag "Subnamespace"})

(fn M.from-list-root-payload [list]
  "Extarct a list of children from outermost `/list` payload"
  (match list {:namespaceListingChildren namespaceListingChildren
               :namespaceListingFQN      namespaceListingFQN
               :namespaceListingHash     _namespaceListingHash}
     (if (= namespaceListingFQN "")
         namespaceListingChildren
         (do (table.insert namespaceListingChildren M.up-namespace) namespaceListingChildren))))

(fn M.get-list-entry-display [entry]
  "Get a Telescope entry for entries server by `/list` endpoint"
  (match entry
           {:contents {:termName termName
                       :termHash _termHash
                       :termTag  _termTag
                       :termType _termType}
            :tag tag}
            [(render.colored "󰊕" tag) termName ""]

           {:contents {:namespaceName namespaceName
                       :namespaceHash _namespaceHash 
                       :namespaceSize namespaceSize}
            :tag tag}
            [(render.colored "" tag) namespaceName (render.colored (tostring namespaceSize) :SubnamespaceSize)]

           {:contents {:namespaceName ".."
                       :namespaceHash nil 
                       :namespaceSize nil}
            :tag _tag} ["" ".." ""]

           {:contents {:typeHash _typeHash
                       :typeName typeName
                       :typeTag _typeTag}
            :tag tag}
            [(render.colored "" tag) typeName ""]

           {:contents {:patchName name}
            :tag "PatchObject"}
            ["󱞪" name ""]

           other
           (utils.notify { :msg "Pattern match failed" :value other })))

(fn M.get-list-entry-name [entry]
  "Get a name of an entry served by a `/list` endpoint"
  (match entry
           {:contents {:termName termName
                       :termHash _termHash
                       :termTag  _termTag
                       :termType _termType}
            :tag _tag}
            termName

           {:contents {:namespaceName "/"
                       :namespaceHash _namespaceHash 
                       :namespaceSize _namespaceSize}
            :tag "Subnamespace"}
            nil

           {:contents {:namespaceName namespaceName
                       :namespaceHash _namespaceHash 
                       :namespaceSize _namespaceSize}
            :tag "Subnamespace"}
            namespaceName

           {:contents {:namespaceName ".."
                       :namespaceHash nil 
                       :namespaceSize nil}
            :tag "Subnamespace"}
            ".."

           {:contents {:typeHash _typeHash
                       :typeName typeName
                       :typeTag _typeTag}
            :tag "TypeObject"} 
            typeName

           {:contents {:patchName name}
            :tag "PatchObject"} 
            name

           other (utils.notify { :msg "Pattern match failed" :value other })))

(fn M.get-project-name [project]
  "Get name of a project served by `/projects` endpoint"
  (match project {:name name :hash _hash :owner _owner} name))

M
