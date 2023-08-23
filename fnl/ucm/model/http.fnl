(local str      (require :nfnl.string))

(local curl     (require :plenary.curl))

(local utils    (require :ucm.utils))
(local endpoint (require :ucm.utils.endpoint))


(local M {})

(fn url-encoded [project-or-branch]
  (project-or-branch:gsub "/" "%%2F"))

(fn get-service [root service]
  (match root
    {:project project :branch branch} (.. "projects/" (url-encoded project) "/branches/" (url-encoded branch) "/" service)
    _ (utils.notify {:msg "get-service called without proper root (you need to pick a project and a branch)" :root root :service service})))

(fn request [service q]
  (let [url (.. (endpoint.get) service)
        res (curl.get url { :query q })]
    (vim.json.decode res.body)))


(fn M.get-term [hash]
  (do (request (..  "definitions/terms/by-hash/" (utils.strip-hash hash) "/summary"))))
(fn M.get-type [hash]
  (request (..  "definitions/types/by-hash/" (utils.strip-hash hash) "/summary")) )
(fn M.get-definition [root fqn relative-to]
  (request (get-service root :getDefinition) {:names fqn :relativeTo relative-to}) )

(fn M.projects []
  (request :projects))
(fn M.branches [project]
  (request (.. "projects/" (url-encoded project) "/branches")))

(fn M.list [root path]
  "`root` should always be set to {:project X branch Y}"
  (let [query (if (str.blank? path) nil { :namespace path })]
    (request (get-service root :list) query)))

(fn M.find [query]
  (request :find {:query query}))

(fn request-async [service q callback]
  (curl.get (.. (endpoint.get) service) { :query q :callback callback :raw ["--max-time" 10] }))

(fn M.find-async [root query callback]
  (request-async (get-service root :find) { :query query } callback))

M
