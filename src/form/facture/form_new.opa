

package easycount.facture.form

import stdlib.widgets.formbuilder

import easycount.data
import easycount.user.session
import easycount.form.tools

NewFactureForm = {{
    
    montant = WFormBuilder.mk_field("Amount:", WFormBuilder.text_field)
    repartition = WFormBuilder.mk_field("Distribution:", WFormBuilder.text_field)
    form = WFormBuilder.mk_form()

    create_field(field) =
        WFormBuilder.render_field(form, field)
    
    /**
    Parse the formatted string to get distribution of the spending.
    Get users concerned and their parts.
    @param s the formatted-string
    @return an option, if succeed a list of {nom nb_parts}
    */
    parse_repartition(s : string) : option(list({ nb_parts: float; nom: string })) =
    (
        name_parser =
            parser
            | " "* nom=([-a-zA-Z0-9_.@]*) " "* nb_parts=Rule.integer? " "* -> {~nom ~nb_parts}
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
    
    /**
    Transform parts into value of maney.
    @param montant the total amount
    @param repartition the distribution of parts computed by parse_repartition(..)
    */
    do_repartition(montant : float, repartition : list({ nb_parts: float; nom: string })) : map(User.ref, float) =
        tot_parts = List.fold(v,acc -> acc+v.nb_parts, repartition, 0.0)
        Map.From.assoc_list(List.map(v -> (User_Data.string_to_ref(v.nom), montant * v.nb_parts / tot_parts), repartition))
    
    /**
    Compute the process fonction of the form.
    @param ref the reference of the current group
    @param edit a function to call if success to update a table
    */
    process(ref : Group.ref, edit : (Facture.t -> void))(_) : void =
    (
        montant = Option.default("",WFormBuilder.get_field_value(montant))
        repartition = Option.default("",WFormBuilder.get_field_value(repartition))
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
                        | {~success} -> do edit(success) {success=<>Spending added</>}
                        | {~failure} -> {failure=<>{failure}</>}
                        end,
                    {failure=<>erreur de formatage de la repartition</>},
                    parse_repartition(repartition)
                ),
            {failure=<>le montant n'est pas un float</>},
            Parser.float(montant)
        )
        
        do Form_Tools.notice(notice)
        void
    )
    
    /**
    Get form.
    @param ref the reference of current group
    @param edit a function to update a table of spendings
    @return xhtml
    */
    show(ref : Group.ref, edit : (Facture.t -> void)) : xhtml =
    (
        fields = <>
            <p>For the distribution you have to format your string, ex :<br/>
            "marco polo" means marco and polo participates with equal part.<br/>
            "marco 2 polo 1" means marco must pay 2 parts and polo 1 parts.<br/>
            You can put as many spaces as you want.
            </p>
            {create_field(montant)}
            {create_field(repartition)}
            <input type="submit" value="Add" />
        </>
        
        xhtml_form = WFormBuilder.render_form(form, fields, process(ref,edit))
        
        <>
        <div id=#{Form_Tools.id_notifications}></div>
        {xhtml_form}
        </>
    )
}}

