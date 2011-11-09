

package easycount.user.form

import stdlib.web.client
import stdlib.widgets.formbuilder

import easycount.data
import easycount.user.session


LoginUserForm = {{
    email   = WFormBuilder.mk_field("Email:", WFormBuilder.text_field)
    passwd     = WFormBuilder.mk_field("Password:", WFormBuilder.passwd_field)
    form = WFormBuilder.mk_form()

    create_field(field) =
        WFormBuilder.render_field(form, field)
    
    process(_) : void =
        name = User_Data.string_to_ref(Option.default("",WFormBuilder.get_field_value(email)))
        pass = Option.default("",WFormBuilder.get_field_value(passwd))
        notice = 
            match User.login(name, pass) with
            | {~success} -> do Client.goto("/user/compte") {success=<>{success}</>}
            | {~failure} -> {failure=<>{failure}</>}
            end
        
        do Form_Tools.notice(notice)
        void
        

    show() : xhtml =
        fields = <>
            {create_field(email)}
            {create_field(passwd)}
            <input type="submit" value="Login" />
        </>
        
        xhtml_form = WFormBuilder.render_form(form, fields, process)
        
        <>
        <div id=#{Form_Tools.id_notifications}></div>
        <div>{xhtml_form}</div>
        <div><a href="/user/new">Create an account</a></div>
        </>
}}
