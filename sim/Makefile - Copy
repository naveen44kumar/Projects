RTL = ../axi_if/*
WORK = work
SVTB_TOP = ../top/axi_top.sv
SVTB_PKG = ../test/axi_pkg.sv

INC = +incdir+../tb \
      +incdir+../test \
      +incdir+../axi_master \
      +incdir+../axi_slave

VSIMOPT = -vopt -voptargs=+acc
VSIMCOV = -coverage -sva

# Batch run template
define RUN_TEMPLATE
-c -do "log -r /*; coverage save -onexit $(1); run -all; exit"
endef

help:
	@echo "============================================================"
	@echo " make clean      -> clean logs and intermediate files"
	@echo " make sv_cmp     -> compile AXI UVM testbench"
	@echo " make run_test   -> run inc_test"
	@echo " make run_test1  -> run fixed_test"
	@echo " make run_test2  -> run wrap_test"
	@echo " make regress    -> run all tests + merge coverage"
	@echo " make cov        -> open coverage report"
	@echo "============================================================"

sv_cmp:
	vlib $(WORK)
	vmap work $(WORK)
	vlog -work $(WORK) $(RTL) $(INC) $(SVTB_PKG) $(SVTB_TOP)

run_test: sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) \
	     $(call RUN_TEMPLATE,mem_cov1) \
	     -wlf inc_wave.wlf -l test1.log \
	     -sv_seed random work.top +UVM_TESTNAME=inc_test
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1

run_test1: sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) \
	     $(call RUN_TEMPLATE,mem_cov2) \
	     -wlf fixed_wave.wlf -l test2.log \
	     -sv_seed random work.top +UVM_TESTNAME=fixed_test
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2

run_test2: sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) \
	     $(call RUN_TEMPLATE,mem_cov3) \
	     -wlf wrap_wave.wlf -l test3.log \
	     -sv_seed random work.top +UVM_TESTNAME=wrap_test
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3

regress: clean run_test run_test1 run_test2 report cov

report:
	vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

cov:
	cmd.exe /C start msedge "file:///$(shell cygpath -w $(PWD))/covhtmlreport/index.html"

view_wave1:
	vsim -gui -view inc_wave.wlf -do "view wave; add wave -r /*;"

view_wave2:
	vsim -gui -view fixed_wave.wlf -do "view wave; add wave -r /*;"

view_wave3:
	vsim -gui -view wrap_wave.wlf -do "view wave; add wave -r /*;"

clean:
	rm -rf transcript* *log* fcover* covhtml* mem_cov* *.wlf modelsim.ini work
