#define MC_BOOL_TRUE "true"
///The max range that two devices can be linked.
#define MC_LINK_RANGE 15

///For use in Initialize(), add inputs to our input list.
#define MC_ADD_INPUT(name, proc) inputs[name] = PROC_REF(proc)

//Config entries
#define MC_CFG_UNLINK_ALL "Unlink All"
#define MC_CFG_LINK "Link Device"

//Mechcomp signals. These are extremely special and thus dont use the COMSIG prefix.

///An output is being removed from our interface's output list (target)
#define MCACT_REMOVE_OUTPUT "mc_remove_output"
///An input is being removed from our interface's input list (target)
#define MCACT_REMOVE_INPUT "mc_remove_input"
///An output is being added to our interface's output list (target)
#define MCACT_ADD_OUTPUT "mc_add_output"
///An input is being added to our interface's input list (target)
#define MCACT_ADD_INPUT "mc_add_input"
///A message as been recieved from an input (message, sender)
#define MCACT_RECEIVE_MESSAGE "mc_message_get"
