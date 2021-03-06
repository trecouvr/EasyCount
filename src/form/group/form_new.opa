

package easycount.group.form

import stdlib.widgets.formbuilder

import easycount.data
import easycount.user.session
import easycount.form.tools



NewGroupForm = {{
    
    name   = WFormBuilder.mk_field("Groupname:", WFormBuilder.text_field)
    form = WFormBuilder.mk_form()

    create_field(field) =
        WFormBuilder.render_field(form, field)
    
    process(edit : (Group.t->void))(_) : void =
        check = parser | retour=([-a-z0-9_. ]*) -> "{retour}"
        clean(s) = String.to_lower(String.remove_accents(s))
        notice = match Parser.try_parse(check, clean(Option.default("",WFormBuilder.get_field_value(name)))) with
        | {none} -> {failure=<>Some caracters are forbidden</>}
        | {some=name} ->
            match Group_Data.add(name,User.current_user_ref()) with
            | {~success} -> do edit(success) {success=<>Group added</>}
            | {~failure} -> {failure = <>{failure}</>}
            end
        
        do Form_Tools.notice(notice)
        void
        

    show(edit : (Group.t -> void)) : xhtml =
        fields = <>
            {create_field(name)}
            <input type="submit" value="Add" />
        </>
        
        xhtml_form = WFormBuilder.render_form(form, fields, process(edit))
        
        <>
        <div id=#{Form_Tools.id_notifications}></div>
        {xhtml_form}
        </>
}}
