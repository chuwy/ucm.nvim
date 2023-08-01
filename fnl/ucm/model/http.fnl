(local str      (require :nfnl.string))

(local curl     (require :plenary.curl))

(local utils    (require :ucm.utils))
(local endpoint (require :ucm.utils.endpoint))


(local M {})

(fn request [service q]
  (let [url (.. (endpoint.get) service)
        res (curl.get url { :query q })]
    (vim.json.decode res.body)))


(fn M.get-term [hash]
  (do (request (..  "definitions/terms/by-hash/" (utils.strip-hash hash) "/summary"))))
(fn M.get-type [hash]
  (request (..  "definitions/types/by-hash/" (utils.strip-hash hash) "/summary")) )
(fn M.get-definition [fqn]
  (request "getDefinition" {:names fqn}) )

(fn M.projects []
  (request :projects))

(fn M.list [path relative-to]
  (let [query (if (str.blank? path) nil { :namespace path :relativeTo relative-to })]
    (request :list query)))

(fn M.find [query]
  (request :find {:query query}))

(fn request-async [service q callback]
  (curl.get (.. (endpoint.get) service) { :query q :callback callback :raw ["--max-time" 10] }))

(fn M.find-async [query relative-to callback]
  (request-async :find { :query query :relativeTo relative-to } callback))
    
M
