





NewGroupForm = {{
    
    name   = WFormBuilder.mk_field("Groupname:", WFormBuilder.text_field)

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
            <input type="submit" value="Add" />
        </>
        
        xhtml_form = WFormBuilder.form_html("Add", {Basic}, fields, process)
        
        <>
        <div id=#notice></div>
        {xhtml_form}
        </>
}}
