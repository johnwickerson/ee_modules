all:
	dune exec -- ./builddot.exe -theme digital > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules.pdf
	INCLUDEROOTNODE=1 dune exec -- ./builddot.exe -theme digital > modules_with_root.dot
# use twopi to place the nodes then neato to curve the edges
	twopi -Granksep=3.5 -Txdot modules_with_root.dot | \
		neato -n -Gsplines=true -Tpdf -o modules_radial.pdf
