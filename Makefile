all:
	dune exec -- ./builddot.exe > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules.pdf
	INCLUDEROOTNODE=1 dune exec -- ./builddot.exe > modules_with_root.dot
	twopi -Goverlap=false -Tpdf modules_with_root.dot -o modules_radial.pdf
	neato -Goverlap=false -Tpdf modules_with_root.dot -o modules_neato.pdf
