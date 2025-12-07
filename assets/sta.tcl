#--------------------------------------------------------
#--------------------------------------------------------
  # Post Route Multi-corner STA Automation Script 
#--------------------------------------------------------
           # Author : Tanukasree
#--------------------------------------------------------
#--------------------------------------------------------

# Define list of timing libraries (corners)

set list_of_lib_files(1) "sky130_fd_sc_hd__tt_025C_1v80.lib"
 # set list_of_lib_files(2) "sky130_fd_sc_hd__ff_100C_1v65.lib"
 # set list_of_lib_files(3) "sky130_fd_sc_hd__ff_100C_1v95.lib"
 # set list_of_lib_files(4) "sky130_fd_sc_hd__ff_n40C_1v56.lib"
 # set list_of_lib_files(5) "sky130_fd_sc_hd__ff_n40C_1v65.lib"
 # set list_of_lib_files(6) "sky130_fd_sc_hd__ff_n40C_1v76.lib"
 # set list_of_lib_files(7) "sky130_fd_sc_hd__ss_100C_1v40.lib"
 # set list_of_lib_files(8) "sky130_fd_sc_hd__ss_100C_1v60.lib"
 # set list_of_lib_files(9) "sky130_fd_sc_hd__ss_n40C_1v28.lib"
 # set list_of_lib_files(10) "sky130_fd_sc_hd__ss_n40C_1v35.lib"
set list_of_lib_files(2) "sky130_fd_sc_hd__ss_n40C_1v40.lib"
 # set list_of_lib_files(12) "sky130_fd_sc_hd__ss_n40C_1v44.lib"
 # set list_of_lib_files(13) "sky130_fd_sc_hd__ss_n40C_1v76.lib"
set list_of_lib_files(3) "sky130_fd_sc_hd__ff_n40C_1v95.lib"
#---------------------------------------------
#  Load design libraries 
#---------------------------------------------

 read_liberty /home/tanukasree/OpenSTA/examples/timing_libs/avsdpll.lib
 read_liberty /home/tanukasree/OpenSTA/examples/timing_libs/avsddac.lib

#---------------------------------------------
#  Loop through each .lib file (corner)
#---------------------------------------------

 for {set i 1} {$i <= [array size list_of_lib_files]} {incr i} {

# Read design and constraints

 read_liberty /home/tanukasree/OpenSTA/examples/timing_libs/$list_of_lib_files($i)
 read_verilog /home/tanukasree/OpenROAD-flow-scripts/flow/designs/sky130hd/vsdbabysoc/vsdbabysoc_post_place.v
 link_design vsdbabysoc
 current_design
 read_sdc /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/4_cts.sdc
 read_spef /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/6_final.spef

 # Perform timing checks
 check_setup -verbose

#-----------------------------------------
# Generate detailed reports
#-----------------------------------------

 report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits {4} > /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/min_max_$list_of_lib_files($i).txt

#---------------------------------------------------
# Save key metrics (WNS, TNS, Setup & Hold Slack )
#---------------------------------------------------

 exec echo "$list_of_lib_files($i)" >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_worst_max_slack.txt
 report_worst_slack -max -digits {4} >> //home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_worst_max_slack.txt

 exec echo "$list_of_lib_files($i)" >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_worst_min_slack.txt
 report_worst_slack -min -digits {4} >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_worst_min_slack.txt

 exec echo "$list_of_lib_files($i)" >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_tns.txt
 report_tns -digits {4} >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_tns.txt

 exec echo "$list_of_lib_files($i)" >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_wns.txt
 report_wns -digits {4} >> /home/tanukasree/OpenROAD-flow-scripts/flow/results/sky130hd/vsdbabysoc/base/sta_output/route/sta_wns.txt
 }
