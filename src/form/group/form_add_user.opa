

package easycount.group.form

import stdlib.widgets.completion
import stdlib.widgets.bootstrap

import easycount.form.tools


AddUserGroupForm = {{
    WB = WBootstrap
    
    
    id_input : string = "input_name"
    
    /**
    Add a user to the current group, using the value in the input field.
    @param ref the reference of current group
    @param id the id of input
    */
    add_user(ref : Group.ref) : void =
        notice = match Group_Data.add_user(ref,Dom.get_value(#{id_input})) with
        | {~success} -> {success=<>{success}</>}
        | {~failure} -> {failure=<>{failure}</>}
        do Form_Tools.notice(notice)
        void
    
    @publish
    list_nom(in) = 
        in = String.to_lower(in)
        Db.stringmap_fold_range(
            @/users,
            (acc,ref ->
                if String.has_prefix(in, ref) then
                    List.add({input=in display=<>{ref}</> item=ref}, acc)
                else
                    acc
            ),
            [],
            "", none, (_->true)
        )
    
    xhtml(ref : Group.ref) : xhtml =
        onselect(item) = Dom.set_value(#{id_input}, item)
        <div id=#{Form_Tools.id_notifications}></div>
        <+>
        WCompletion.html({WCompletion.default_config with suggest = list_nom}, onselect, id_input, {input = "" display = <></> item = ""})
        <+>
        WB.Button.make({button="Add" callback=(_->add_user(ref))}, [])


}}
