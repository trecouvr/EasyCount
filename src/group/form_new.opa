





NewGroupForm = {{
    
    name   = WFormBuilder.mk_field("Groupname:", WFormBuilder.text_field)
    form = WFormBuilder.mk_form()

    create_field(field) =
        WFormBuilder.render_field(form, field)
    
    process(edit : (Group.t->void))(_) : void =
        name = Option.default("",WFormBuilder.get_field_value(name))
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
        
        xhtml_form = WFormBuilder.render_form(form, fields, process(edit))
        
        <>
        <div id=#notice></div>
        {xhtml_form}
        </>
}}
