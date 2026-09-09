# quest-tool -- prints a greeting and the answer to everything.
#
# usage:
#   janet app/main.janet <name>

(defn greeting
  "Return a greeting for `name`."
  [name]
  (string "hello, " name))

(defn base-value
  "Starting point used to compute the answer."
  []
  41)

(defn the-answer
  "The answer to life, the universe, and everything."
  []
  (+ (base-value) 1))

(defn run
  [args]
  (def name (if (>= (length args) 2) (get args 1) "world"))
  (print (greeting name))
  (print (the-answer)))

(when (= (dyn :current-file) (get (dyn :args) 0))
  (run (dyn :args)))
