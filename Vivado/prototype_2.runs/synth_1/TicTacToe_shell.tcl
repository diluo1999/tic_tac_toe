# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir P:/22summer/engs031/group_12/prototype2/Di/Vivado/prototype_2.cache/wt [current_project]
set_property parent.project_path P:/22summer/engs031/group_12/prototype2/Di/Vivado/prototype_2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo p:/22summer/engs031/group_12/prototype2/Di/Vivado/prototype_2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  P:/22summer/engs031/group_12/prototype2/Di/VHDL/VGA_driver.vhd
  P:/22summer/engs031/group_12/prototype2/Di/VHDL/game_logic.vhd
  P:/22summer/engs031/group_12/prototype2/Di/VHDL/input_conditioning.vhd
  P:/22summer/engs031/group_12/prototype2/Di/VHDL/pixel_generation.vhd
  P:/22summer/engs031/group_12/prototype2/Di/VHDL/system_clock_generator.vhd
  P:/22summer/engs031/group_12/prototype2/Di/VHDL/TicTacToe_shell.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc P:/22summer/engs031/group_12/prototype2/Di/Vivado/protytype_2_constraints.xdc
set_property used_in_implementation false [get_files P:/22summer/engs031/group_12/prototype2/Di/Vivado/protytype_2_constraints.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top TicTacToe_shell -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef TicTacToe_shell.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file TicTacToe_shell_utilization_synth.rpt -pb TicTacToe_shell_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
