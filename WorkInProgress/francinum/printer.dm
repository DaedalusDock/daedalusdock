#define MAX_PAPER 6

//UNFINISHED

/obj/machinery/printer
	name = "printer"
	desc = "It's a printer. Data goes in, Paper comes out."
	net_class = "PNET_LPT"
	anchored = 1
	density = 1
	var/print_id = null
	var/status_message = "CRITICAL ERROR: CONTACT SUPPORT"
	var/paper_stack = MAX_PAPER

/obj/machinery/printer/proc/recalculate_statmessage()

	if(!paper_stack)
		status_message = "NOT READY - PC LOAD LETTER"
		return
	if(!jack)
		status_message = "NOT READY - NO NETWORK"
		return
	status_message = "READY - ID:[print_id]"

/obj/machinery/printer/proc/print()
