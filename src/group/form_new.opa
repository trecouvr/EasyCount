





NewGroupForm = {{
    
    name   = WFormBuilder.mk_field("Groupname:", WFormBuilder.text_field)

    create_field(field) =
        WFormBuilder.field_html(field, WFormBuilder.default_field_builder, WFormBuilder.empty_style)
    
    process(edit : (Group.t->void))(_) : void =
        name = match WFormBuilder.get_field_value(name) with
        | {~value} -> value
        | _ -> ""
        end
        notice = 
            match Group_Data.add(name) with
            | {~success} -> do edit(success) "Group added"
            | {~failure} -> failure
            end
        
        do Dom.transform([#notice <- <>{notice}</>])
        void
        

    show(edit : (Group.t -> void)) : xhtml =
        fields = <>
            {create_field(name)}
            <input type="submit" value="Add" />
        </>
        
        xhtml_form = WFormBuilder.form_html("Add", {Basic}, fields, process(edit))
        
        <>
        <div id=#notice></div>
        {xhtml_form}
        </>
}}
