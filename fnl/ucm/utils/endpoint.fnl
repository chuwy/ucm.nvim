(local str           (require :nfnl.string))
(local curl          (require :plenary.curl))

(local config        (require :ucm.config))
(local utils         (require :ucm.utils))


(fn endswith [s suffix]
  "Check if string s ends with a suffix"
  (or (str.blank? suffix) (= (s:sub (- 0 (length suffix))) suffix)))


(local M {})

(fn M.get []
  "endpoint._endpoint have a priority over config.endpoint"
  (let [endpoint (. M :_endpoint)
        known (if  endpoint endpoint config.endpoint)]
    (if (= known nil)
        known
        (if (endswith known "/") known (.. known "/")))))

(fn M.set [s]
  (let [link   (if s.args s.args s)
        result (if (endswith link "/") link (.. link "/"))]
    (set M._endpoint result)))

(fn M.check-endpoint [endpoint callback]
  (if (= endpoint nil)
      (vim.ui.input {:prompt "endpoint is missing! Please, provide an URI (you can get it via ucm `api`): " } (M.check-endpoint-url callback))))

(fn M.check-endpoint-url [callback]
  "Try to fetch something from endpoint"
  (lambda [endpoint] (curl.get endpoint {
            :callback (lambda [r]
                        (if (and (= r.status 200) (= r.exit 0))
                            (do (M.set endpoint) (callback))
                            (utils.notify (.. "The endpoint " endpoint " is invalid. Try resetting it with :UcmSetApi"))))
  })))

(fn M.wrap [f & args]
  "A decorator for any function that depends on api endpoint. It makes sure the endpoint is always set to a valid url"
  (M.check-endpoint (M.get) (lambda [] (f args))))

M

