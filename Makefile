all:
	dune exec -- ./builddot.exe > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules.pdf
	INCLUDEROOTNODE=1 dune exec -- ./builddot.exe > modules_with_root.dot
# use twopi to place the nodes then neato to curve the edges
	twopi -Granksep=3.5 -Txdot modules_with_root.dot | \
		neato -n -Gsplines=true -Tpdf -o modules_radial.pdf

analogue:
	dune exec -- ./builddot.exe -theme analogue > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_analogue.pdf

devices:
	dune exec -- ./builddot.exe -theme devices > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_devices.pdf

fields:
	dune exec -- ./builddot.exe -theme fields > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_fields.pdf

power:
	dune exec -- ./builddot.exe -theme power > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_power.pdf

control:
	dune exec -- ./builddot.exe -theme control > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_control.pdf

robotics:
	dune exec -- ./builddot.exe -theme robotics > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_robotics.pdf

ml:
	dune exec -- ./builddot.exe -theme ml > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_ml.pdf

signals:
	dune exec -- ./builddot.exe -theme signals > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_signals.pdf

comms:
	dune exec -- ./builddot.exe -theme comms > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_comms.pdf

digital:
	dune exec -- ./builddot.exe -theme digital > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_digital.pdf

computing:
	dune exec -- ./builddot.exe -theme computing > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_computing.pdf

maths:
	dune exec -- ./builddot.exe -theme maths > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_maths.pdf

prof:
	dune exec -- ./builddot.exe -theme prof > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_prof.pdf

themes: analogue devices fields power control robotics ml signals comms digital computing maths prof

table:
	dune exec -- ./buildtable.exe > table.html
