all:
	dune exec -- ./builddot.exe > modules.dot
	dot -Granksep=12 -Tpdf modules.dot -o modules.pdf
	INCLUDEROOTNODE=1 dune exec -- ./builddot.exe > modules_with_root.dot
	twopi -Granksep=12 -Tpdf modules_with_root.dot -o modules_radial.pdf
