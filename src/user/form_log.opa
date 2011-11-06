
import stdlib.web.client

LoginUserForm = {{
    username   = WFormBuilder.mk_field("Username:", WFormBuilder.text_field)
    passwd     = WFormBuilder.mk_field("Password:", WFormBuilder.passwd_field)
    form = WFormBuilder.mk_form()

    create_field(field) =
        WFormBuilder.render_field(form, field)
    
    process(_) : void =
        name = Option.default("",WFormBuilder.get_field_value(username))
        pass = Option.default("",WFormBuilder.get_field_value(passwd))
        notice = 
            match User.login(name, pass) with
            | {~success} -> do Client.goto("/user/compte") success
            | {~failure} -> failure
            end
        
        do Dom.transform([#notice <- <>{notice}</>])
        void
        

    show() : xhtml =
        fields = <>
            {create_field(username)}
            {create_field(passwd)}
            <input type="submit" value="Login" />
        </>
        
        xhtml_form = WFormBuilder.render_form(form, fields, process)
        
        <>
        <div id=#notice></div>
        <div>{xhtml_form}</div>
        <div><a href="/user/new">Create an account</a></div>
        </>
}}
