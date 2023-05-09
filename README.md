# EE module dependency graph

A dependency graph for the Imperial EE modules.

Each module is a node in the graph, containing the module code, the module title, and its ILOs (independent learning objectives). An arrow from module A to module B means that one of module A's ILOs is a prerequisite for taking module B.

## How to view the dependency graph

- Open the [`modules.pdf`](https://github.com/johnwickerson/ee_modules/raw/main/modules.pdf) file.

## How to edit the dependency graph

- Open the [`modules.yml`](modules.yml) file.
- Click on the `edit` button.
- Make your changes.
- Click on the `Commit changes...` button.
- Wait for a few minutes while the dependency graph is rebuilt with your changes.
- Open the [`modules.pdf`](https://github.com/johnwickerson/ee_modules/raw/main/modules.pdf) file to see the new version.

## Some technical details
- There is a GitHub Action that fires whenever a commit is pushed to the repository.
- Some custom-written OCaml code converts `modules.yml` into a Graphviz description (`modules.dot`).
- The `dot` graph-layout engine is used to convert the Graphviz description into a PDF file (`modules.pdf`).

## Authors
- [John Wickerson](https://github.com/johnwickerson) (`j.wickerson@imperial.ac.uk`)
