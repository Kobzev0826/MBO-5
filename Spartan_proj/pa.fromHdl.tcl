
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Spartan_proj -dir "C:/Xilinx/projects/MBO-5/Spartan_proj/planAhead_run_4" -part xc3s500ecp132-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "MBO_testpin.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {MBO_testpin.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
add_files [list {mbo_top.ngc}]
set_property top MBO_testpin $srcset
add_files [list {MBO_testpin.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500ecp132-5
