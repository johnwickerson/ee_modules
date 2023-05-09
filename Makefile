all:
	dot -Tpdf modules.dot -o modules.pdf
	dune exec -- ./builddot.exe > modules.dot
