# EE module dependency graph

![Graph-building system](https://github.com/johnwickerson/ee_modules/actions/workflows/build_dependency_graph.yml/badge.svg)

A dependency graph for the Imperial EE modules.

Each module is a node in the graph, containing the module code, the module title, and its ILOs (intended learning outcomes). An arrow from module A to module B means that one of module A's ILOs is a prerequisite for taking module B.

## Why?

We see several benefits of building this graph:
- It is useful to have all ILOs together in one place, so they can be easily audited for consistency.
- If a module leader ever wants to change/remove an ILO, they can easily see which later modules might be affected.
- If a module leader ever wants to add/change a prerequisite, they can easily see which earlier modules can provide it.

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

## Current limitations
- Does not include modules offered by other departments. So although ELEC60020 (Managing Engineering Projects) builds upon BUSI60037 (Accounting Online) and BUSI60042 (Entrepreneurship Online), these connections are not recorded in the graph.

## Authors
- [John Wickerson](https://github.com/johnwickerson) (`j.wickerson@imperial.ac.uk`)
