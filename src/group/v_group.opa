




Group_View_Group = {{
    
    
    @publish
    get_all_factures(ref : Group.ref) =
        Option.switch(
            group -> group.factures,
            [],
            Group_Data.get(ref)
        )
    
    pot_commun(ref : Group.ref) =
        Option.switch(
            group ->
                List.fold(
                    facture,pot ->
                        Map.fold(
                            nom,montant,pot ->
                                Map.replace_or_add(nom, (last_montant -> Option.switch(v -> v - montant, 0.0-montant, last_montant)), pot)
                            ,
                            facture.concerned,
                            Map.replace_or_add(facture.emeteur, (last_montant -> Option.switch(v -> v + facture.montant, facture.montant, last_montant)), pot)
                        ),
                    group.factures,
                    Map.empty
                )
            ,
            Map.empty,
            Group_Data.get(ref)
        )
    
    @client
    xhtml_factures_list(ref : Group.ref) : xhtml =
        columns = [
            TableBuilder.mk_column(
                <>Transmitter</>,
                r,_c -> <>{r.emeteur}</>,
                some(r1, r2 -> String.ordering(r1.emeteur, r2.emeteur)),
                none
            ),
            TableBuilder.mk_column(
                <>Amount</>,
                r,_c -> <>{r.montant}</>,
                some(r1, r2 -> Float.ordering(r1.montant, r2.montant)),
                none
            ),
            TableBuilder.mk_column(
                <>Date</>,
                r,_c -> <>{Date.to_string_date_only(r.date)}</>,
                some(r1, r2 -> Date.ordering(r1.date, r2.date)),
                none
            ),
            TableBuilder.mk_column(
                <>Distribution</>,
                r,_c -> <ul>{Map.fold(k,v,a -> <>{a}<li>{k} : {v}</li></>, r.concerned, <></>)}</ul>,
                none,
                none
            )
        ]
        spec = TableBuilder.mk_spec(columns, get_all_factures(ref))
        table = TableBuilder.make(spec)
        table.xhtml
    
    add_user(ref)() =
        notice = match Group_Data.add_user(ref,Dom.get_value(#new_user)) with
        | {~success} -> success
        | {~failure} -> failure
        end
        Dom.transform([#notice_add <- notice])
    
    html(ref : Group.ref) : xhtml =
        xhtml() = (<>
        <h1>Groupe {ref}</h1>
        <div><a href="/user/compte">My account</a></div>
        {List.fold(v,acc -> acc^"{v} ", Group_Data.get_users(ref), "")}
        <ul>{Map.fold(nom,montant,acc -> <>{acc}<li>{nom} : {montant}</li></>, pot_commun(ref), <></>)}</ul>
        <h3>Add an expediture</h3>
        {NewFactureForm.show(ref)}
        <h3>Add somebody in the group</h3>
        <div id=#notice_add></div>
        <input id=#new_user/>
        <button onclick={_->add_user(ref)()}>Add</button>
        <h3>Accounts</h3>
        {xhtml_factures_list(ref)}
        </>)
        
        <div id=#content onready={_->Dom.transform([#content <- xhtml()])}>Groupe {ref}</div>


        
    
}}
