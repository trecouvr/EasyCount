

package easycount.user.form

import stdlib.widgets.formbuilder

import easycount.form.tools

NewUserForm = {{
    
    email      = WFormBuilder.mk_field("Email:", WFormBuilder.email_field(<>John@deuf.com</>))
    passwd1    = WFormBuilder.mk_field("Password:", WFormBuilder.passwd_field)
    passwd2    = WFormBuilder.mk_field("Password again:", WFormBuilder.passwd_field)
    form = WFormBuilder.mk_form()

    create_field(field) : xhtml =
        WFormBuilder.render_field(form ,field)
    
    process(_) : void =
        email = Option.default({name=none address={local="" domain=""}},WFormBuilder.get_field_value(email))
        email = email.address.local^"@"^email.address.domain
        pass  = Option.default("",WFormBuilder.get_field_value(passwd1))
        pass2 = Option.default("",WFormBuilder.get_field_value(passwd2))
        notice = 
        if email == "" then
            {failure=<>Email is empty</>}
        else if pass == "" then
            {failure=<>Password is empty</>}
        else if pass != pass2 then
            {failure=<>Passwords doesn't match</>}
        else
            match User_Data.add(String.to_lower(email), pass) with
            | {~success} -> do Client.goto("/user/login") {success=<>{success}</>}
            | {~failure} -> {failure=<>{failure}</>}
            end
        
        do Form_Tools.notice(notice)
        void
        

    show() : xhtml =
        fields = <>
            {create_field(email)}
            {create_field(passwd1)}
            {create_field(passwd2)}
            <input type="submit" value="Register" />
        </>
        
        xhtml_form = WFormBuilder.render_form(form, fields, process)
        
        <>
        <div id=#{Form_Tools.id_notifications}></div>
        <div>{xhtml_form}</div>
        <div><a href="/user/login">Login</a></div>
        </>
}}
