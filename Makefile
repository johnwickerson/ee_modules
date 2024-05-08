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

biomedical:
	dune exec -- ./builddot.exe -theme biomedical > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_biomedical.pdf

fields:
	dune exec -- ./builddot.exe -theme fields > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_fields.pdf

power_systems:
	dune exec -- ./builddot.exe -theme power_systems > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_power_systems.pdf

power_electronics:
	dune exec -- ./builddot.exe -theme power_electronics > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_power_electronics.pdf

control:
	dune exec -- ./builddot.exe -theme control > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_control.pdf

robotics:
	dune exec -- ./builddot.exe -theme robotics > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_robotics.pdf

optimisation:
	dune exec -- ./builddot.exe -theme optimisation > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_optimisation.pdf

ml:
	dune exec -- ./builddot.exe -theme ml > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_ml.pdf

signals:
	dune exec -- ./builddot.exe -theme signals > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_signals.pdf

image_audio:
	dune exec -- ./builddot.exe -theme image_audio > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_image_audio.pdf

comms:
	dune exec -- ./builddot.exe -theme comms > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_comms.pdf

digital:
	dune exec -- ./builddot.exe -theme digital > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_digital.pdf

compsci:
	dune exec -- ./builddot.exe -theme compsci > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_compsci.pdf

maths:
	dune exec -- ./builddot.exe -theme maths > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_maths.pdf

prof:
	dune exec -- ./builddot.exe -theme prof > modules.dot
	dot -Goverlap=false -Tpdf modules.dot -o modules_prof.pdf

themes: analogue devices biomedical fields power_systems power_electronics control robotics optimisation ml signals image_audio comms digital compsci maths prof
