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


