

import stdlib.widgets.formbuilder

NewUserForm = {{
    username   = WFormBuilder.mk_field("Username:", WFormBuilder.text_field)
    passwd1    = WFormBuilder.mk_field("Password:", WFormBuilder.passwd_field)
    passwd2    = WFormBuilder.mk_field("Password again:", WFormBuilder.passwd_field)
    form = WFormBuilder.mk_form()

    create_field(field) : xhtml =
        WFormBuilder.render_field(form ,field)
    
    process(_) : void =
        name = Option.default("",WFormBuilder.get_field_value(username))
        pass = Option.default("",WFormBuilder.get_field_value(passwd1))
        pass2 = Option.default("",WFormBuilder.get_field_value(passwd2))
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
        
        xhtml_form = WFormBuilder.render_form(form, fields, process)
        
        <>
        <div id=#notice></div>
        <div>{xhtml_form}</div>
        <div><a href="/user/login">Login</a></div>
        </>
}}
