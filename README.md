# EE module dependency graphs

![Graph-building system](https://github.com/johnwickerson/ee_modules/actions/workflows/build_dependency_graph.yml/badge.svg)

Dependency graphs for each theme in the Imperial EE syllabus.

In each graph, each module is a node, containing the module code and the module title. An arrow from module A to module B means that one of module A's ILOs is "built upon" by module B. The definition of "built upon" is left open for module leaders to interpret differently; sometimes it means that module B only makes sense once module A has been taken; other times it indicates that modules A and B cover related topics but there isn't a hard prerequisite between them.

There is one dependency graph for each theme. Several modules belong to more than one theme. The modules in each graph are coloured by year. The modules with a thick outline are the "major modules" for that theme. The modules with a thin outline have a less substantial link to that theme. The modules with a dashed outline are not part of that theme but they present material that modules within the theme build upon.

## Why?

We see several benefits of building this graph:
- It is useful to have all ILOs together in one place, so they can be easily audited for consistency.
- If a module leader ever wants to change/remove an ILO, they can easily see which later modules might be affected.
- If a module leader ever wants to add/change a prerequisite, they can easily see which earlier modules can provide it.

## How to view the dependency graphs

- [Analogue Electronics](https://github.com/johnwickerson/ee_modules/raw/main/modules_analogue.pdf)
- [Networks and Communications](https://github.com/johnwickerson/ee_modules/raw/main/modules_comms.pdf)
- [Computer Science and Software Engineering](https://github.com/johnwickerson/ee_modules/raw/main/modules_computing.pdf)
- [Control Engineering](https://github.com/johnwickerson/ee_modules/raw/main/modules_control.pdf)
- [Optical and Semiconductor Devices](https://github.com/johnwickerson/ee_modules/raw/main/modules_devices.pdf)
- [Digital Systems and Computer Architecture](https://github.com/johnwickerson/ee_modules/raw/main/modules_digital.pdf)
- [Fields](https://github.com/johnwickerson/ee_modules/raw/main/modules_fields.pdf)
- [Mathematics and Numerical Tools](https://github.com/johnwickerson/ee_modules/raw/main/modules_maths.pdf)
- [Machine Learning and Artificial Intelligence](https://github.com/johnwickerson/ee_modules/raw/main/modules_ml.pdf)
- [Power Engineering](https://github.com/johnwickerson/ee_modules/raw/main/modules_power.pdf)
- [Professional Engineering](https://github.com/johnwickerson/ee_modules/raw/main/modules_prof.pdf)
- [Robotics](https://github.com/johnwickerson/ee_modules/raw/main/modules_robotics.pdf)
- [Signal Processing](https://github.com/johnwickerson/ee_modules/raw/main/modules_signals.pdf)

**Bonus:** here is a table that shows which modules belong to which themes:

- [Module map](http://htmlpreview.github.io/?https://github.com/johnwickerson/ee_modules/blob/main/table.html)

## How to edit the dependency graphs

- Open the [`modules.yml`](modules.yml) file.
- Click on the `edit` button.
- Make your changes.
- Click on the `Commit changes...` button.
- Wait for a few minutes while the dependency graph is rebuilt with your changes.

## Some technical details
- There is a GitHub Action that fires whenever a commit is pushed to the repository.
- Some custom-written OCaml code converts `modules.yml` into a Graphviz description (`modules.dot`).
- The `twopi` and `neato` graph-layout engines are used to convert the Graphviz description into a PDF file.

## Current limitations
- Does not include modules offered by other departments. So although ELEC60020 (Managing Engineering Projects) builds upon BUSI60037 (Accounting Online) and BUSI60042 (Entrepreneurship Online), these connections are not recorded in the graph.

## Authors
- [John Wickerson](https://github.com/johnwickerson) (`j.wickerson@imperial.ac.uk`)
