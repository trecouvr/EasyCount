
import stdlib.web.client

LoginUserForm = {{
    username   = WFormBuilder.mk_field("Username:", WFormBuilder.text_field)
    passwd     = WFormBuilder.mk_field("Password:", WFormBuilder.passwd_field)

    create_field(field) =
        WFormBuilder.field_html(field, WFormBuilder.default_field_builder, WFormBuilder.empty_style)
    
    process(_) : void =
        name = match WFormBuilder.get_field_value(username) with
        | {~value} -> value
        | _ -> ""
        end
        pass = match WFormBuilder.get_field_value(passwd) with
        | {~value} -> value
        | _-> ""
        end
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
        
        xhtml_form = WFormBuilder.form_html("Login", {Basic}, fields, process)
        
        <>
        <div id=#notice></div>
        <div>{xhtml_form}</div>
        <div><a href="/user/new">Create an account</a></div>
        </>
}}
