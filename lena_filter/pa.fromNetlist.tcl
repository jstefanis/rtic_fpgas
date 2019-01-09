
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name lena_filter -dir "/home/tigon/Nextcloud/vibot-master/realtime-image-processing/lena-filter/lena_filter/planAhead_run_2" -part xc7a100tcsg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/tigon/Nextcloud/vibot-master/realtime-image-processing/lena-filter/lena_filter/average_image_filter.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/tigon/Nextcloud/vibot-master/realtime-image-processing/lena-filter/lena_filter} {ipcore_dir} }
add_files [list {ipcore_dir/fifo_memcache.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fifo_jd.ncf}] -fileset [get_property constrset [current_run]]
set_param project.pinAheadLayout  yes
set_property target_constrs_file "average_image_filter.ucf" [current_fileset -constrset]
add_files [list {average_image_filter.ucf}] -fileset [get_property constrset [current_run]]
link_design
