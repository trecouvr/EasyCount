





NewFactureForm = {{
    
    montant = WFormBuilder.mk_field("Amount:", WFormBuilder.text_field)
    repartition = WFormBuilder.mk_field("Distribution:", WFormBuilder.text_field)

    create_field(field) =
        WFormBuilder.field_html(field, WFormBuilder.default_field_builder, WFormBuilder.empty_style)
    
    parse_repartition(s : string) =
    (
        name_parser =
            parser
            | " "* nom=Rule.alphanum_string " "* nb_parts=Rule.integer? " "* -> {~nom ~nb_parts}
            end
        repartition_parser = 
            parser
            | result=(name_parser)* -> result
            end
        r = Option.switch(
            l_s -> 
                some(List.fold(
                v,acc ->
                    Option.switch(
                        r -> List.add({nom = "{r.nom}" nb_parts=Option.switch((opt -> String.to_float("{opt}")), 1.0, r.nb_parts)}, acc),
                        acc,
                        Parser.try_parse(name_parser,"{v}")
                    ),
                l_s,
                []
            )),
            none,
            Parser.try_parse(repartition_parser,s)
        )
        do jlog("{r}")
        r
    )
    
    do_repartition(montant : float, repartition) : map(User.ref, float) =
        tot_parts = List.fold(v,acc -> acc+v.nb_parts, repartition, 0.0)
        Map.From.assoc_list(List.map(v -> (v.nom, montant * v.nb_parts / tot_parts), repartition))
    
    process(ref : Group.ref, edit : (Facture.t -> void))(_) : void =
    (
        montant = match WFormBuilder.get_field_value(montant) with
        | {~value} -> value
        | _ -> ""
        end
        repartition = match WFormBuilder.get_field_value(repartition) with
        | {~value} -> value
        | _ -> ""
        end
        notice = Option.switch(
            montant ->
                Option.switch(
                    repartition ->
                        match Group_Data.add_facture(
                            ref, 
                            {
                                date=Date.now() 
                                ~montant 
                                emeteur=User.current_user_ref() 
                                concerned=do_repartition(montant, repartition)
                            }) with
                        | {~success} -> do edit(success) "Expediture added"
                        | {~failure} -> failure
                        end,
                    "erreur de formatage de la repartition",
                    parse_repartition(repartition)
                ),
            "le montant n'est pas un float",
            Parser.float(montant)
        )
        
        do Dom.transform([#notice <- <>{notice}</>])
        void
    )
        

    show(ref : Group.ref, edit : (Facture.t -> void)) : xhtml =
    (
        fields = <>
            {create_field(montant)}
            {create_field(repartition)}
            <input type="submit" value="Ajouter" />
        </>
        
        xhtml_form = WFormBuilder.form_html("ajouter", {Basic}, fields, process(ref,edit))
        
        <>
        <div id=#notice></div>
        {xhtml_form}
        </>
    )
}}

