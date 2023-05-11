all:
	dune exec -- ./builddot.exe > modules.dot
	dot -Tpdf modules.dot -o modules.pdf
