modules.pdf:
	dot -Tpdf modules.dot -o modules.pdf

modules.dot:
	dune exec -- ./builddot.exe > modules.dot
