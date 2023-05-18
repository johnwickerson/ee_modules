all:
	dune exec -- ./builddot.exe > modules.dot
	dot -Granksep=12 -Tpdf modules.dot -o modules.pdf
