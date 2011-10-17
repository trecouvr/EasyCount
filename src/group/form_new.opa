





NewGroupForm = {{
    
    name   = WFormBuilder.mk_field("Nom du groupe:", WFormBuilder.text_field)

    create_field(field) =
        WFormBuilder.field_html(field, WFormBuilder.default_field_builder, WFormBuilder.empty_style)
    
    process(_) : void =
        name = match WFormBuilder.get_field_value(name) with
        | {~value} -> value
        | _ -> ""
        end
        notice = 
            match Group_Data.add(name) with
            | {~success} -> success
            | {~failure} -> failure
            end
        
        do Dom.transform([#notice <- <>{notice}</>])
        void
        

    show() : xhtml =
        fields = <>
            {create_field(name)}
            <input type="submit" value="Register" />
        </>
        
        xhtml_form = WFormBuilder.form_html("register", {Basic}, fields, process)
        
        <>
        <div id=#notice></div>
        {xhtml_form}
        </>
}}
