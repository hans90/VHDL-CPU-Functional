start_gui
create_project VHDL-CPU-Functional . -part xa3s50pqg208-4
set_property target_language VHDL [current_project]
set_property ng.output_hdl_format VHDL [get_filesets sim_1]
add_files -norecurse {{../../cpu_defs_pack.vhd} {../../cpu_defs_pack_body.vhd} {../../system.vhd} {../../Tests/INSTR_ADD_TB.vhd}}
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
set_property top INSTR_ADD_TB [get_filesets sim_1]
