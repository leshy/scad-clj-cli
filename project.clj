(defproject scadcljcli "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :global-vars {*warn-on-reflection* false}
  :jvm-opts ["-Dclojure.tools.analyzer.warnings=false"]
  :dependencies [
                 [org.clojure/clojure "1.8.0"]
                 [org.clojure/tools.cli "1.0.219"]  ; Add this line
                 [scad-clj "0.5.2"]]
  :aot [scadcljcli.core]  ; Add this line
  :main scadcljcli.core                  ; Add this line
  :repl-options {:init-ns scadcljcli.core})
