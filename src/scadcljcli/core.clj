(ns scadcljcli.core
  (:gen-class)
  (:refer-clojure :exclude [use import])
  (:require [clojure.tools.cli :as cli]
            [clojure.java.io :as io]
            [scad-clj.scad :refer :all]
            [scad-clj.model :refer :all]))

(def cli-options
  [["-o" "--output FILE" "Output file (optional, defaults to stdout)"]
   ["-h" "--help" "Show this help"]])

(defn load-and-evaluate [file]
  (binding [*ns* (create-ns 'user)]
    (require '[scad-clj.model :refer :all])
    (require '[scad-clj.scad :refer :all])
    (load-file file)))

(defn process-file [input-file output-file]
  (let [scad-code (write-scad (load-and-evaluate input-file))]
    (if output-file
      (spit output-file scad-code)
      (println scad-code))))

(defn -main [& args]
  (let [{:keys [options arguments errors summary]} 
        (cli/parse-opts args cli-options)]
    (cond
      (:help options)
      (do
        (println "Usage: scadcljcli [options] input-file")
        (println summary))
      
      errors
      (do 
        (doseq [err errors]
          (println err))
        (System/exit 1))
      
      (empty? arguments)
      (do
        (println "Error: No input file provided")
        (println "Usage: scadcljcli [options] input-file")
        (println summary)
        (System/exit 1))
      
      :else
      (process-file 
        (first arguments) 
        (:output options)))))
