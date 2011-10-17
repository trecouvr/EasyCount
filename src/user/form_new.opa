

import stdlib.widgets.formbuilder

NewUserForm = {{
    username   = WFormBuilder.mk_field("Username:", WFormBuilder.text_field)
    passwd1    = WFormBuilder.mk_field("Password:", WFormBuilder.passwd_field)
    passwd2    = WFormBuilder.mk_field("Password again:", WFormBuilder.passwd_field)

    create_field(field) =
        WFormBuilder.field_html(field, WFormBuilder.default_field_builder, WFormBuilder.empty_style)
    
    process(_) : void =
        name = match WFormBuilder.get_field_value(username) with
        | {~value} -> value
        | _ -> ""
        end
        pass = match WFormBuilder.get_field_value(passwd1) with
        | {~value} -> value
        | _-> ""
        end
        pass2 = match WFormBuilder.get_field_value(passwd2) with
        | {~value} -> value
        | _-> ""
        end
        notice = 
        if pass != pass2 then
            "Passwords doesn't match"
        else
            match User_Data.add(name, pass) with
            | {~success} -> do Client.goto("/user/login") success
            | {~failure} -> failure
            end
        
        do Dom.transform([#notice <- <>{notice}</>])
        void
        

    show() : xhtml =
        fields = <>
            {create_field(username)}
            {create_field(passwd1)}
            {create_field(passwd2)}
            <input type="submit" value="Register" />
        </>
        
        xhtml_form = WFormBuilder.form_html("Register", {Basic}, fields, process)
        
        <>
        <div id=#notice></div>
        <div>{xhtml_form}</div>
        <div><a href="/user/login">Login</a></div>
        </>
}}
