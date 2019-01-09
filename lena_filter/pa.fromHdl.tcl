
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name lena_filter -dir "/home/tigon/Nextcloud/vibot-master/realtime-image-processing/lena-filter/lena_filter/planAhead_run_1" -part xc7a100tcsg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "average_image_filter.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {average_image_filter.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {ipcore_dir/fifo_jd.ngc}]
set_property top average_image_filter $srcset
add_files [list {average_image_filter.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fifo_memcache.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fifo_jd.ncf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc7a100tcsg324-3
