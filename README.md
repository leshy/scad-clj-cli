# scadcljcli

a quick cmdline clojure - openscad compiler using scad-clj project
- https://github.com/farrellm/scad-clj
- http://adereth.github.io/blog/2014/04/09/3d-printing-with-clojure/

basic usage
``` sh
scadcljcli inputfile.clj -o outputfile.scad
```

compile & run locally
``` sh
git clone https://github.com/leshy/scad-clj-cli
ce scad-clj-cli
lein uberjar
java -jar target/scadcljcli-0.1.0-SNAPSHOT-standalone.jar test.clj
```

run via nix (recommended)
``` sh
echo "(cube 10 10 10)" > test.clj
nix run github:leshy/scad-clj-cli# test.clj
nix run github:leshy/scad-clj-cli# test.clj | openscad - -o output.png
```

for org-babel:
``` emacs-lisp
  (defun org-babel-execute:scadclj (body params)
    (let* ((output-file (or (cdr (assoc :file params))
                            (org-babel-temp-file "openscad-" ".png")))
           (input-file (org-babel-temp-file "scadclj-" ".clj"))
           (colorscheme (or (cdr (assoc :colorscheme params)) "Starnight"))
           (size (or (cdr (assoc :size params)) "800,600"))
           (camera (cdr (assoc :camera params)))
           (axes (cdr (assoc :axes params)))
           (viewall (cdr (assoc :viewall params)))
           (cmd (concat "nix run github:leshy/scad-clj-cli# "
                        input-file
                        " | openscad -"   ; Read from stdin
                        " -o " output-file 
                        " --colorscheme " colorscheme
                        " --imgsize " size
                        " --projection o"
                        (when camera (concat " --camera " camera))
                        (when axes " --view axes")
                        (when viewall " --viewall"))))
      (with-temp-file input-file
        (insert body))
      (org-babel-eval cmd "")
      (format "[[./%s]]" output-file)))

```

``` org
#+begin_src scadclj :file cube.png :results file link
(cube 10 10 10)
#+end_src
```

`

`

