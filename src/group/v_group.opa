




Group_View_Group = {{
    
    
    @publish
    get_all_factures(ref : Group.ref) =
        Option.switch(
            group -> group.factures,
            [],
            Group_Data.get(ref)
        )
    
    show_pot_commun(ref : Group.ref) : void =
        Dom.transform([#pot_commun <- <ul>{Map.fold(nom,montant,acc -> <>{acc}<li>{nom} : {montant}</li></>, pot_commun(ref), <></>)}</ul>])
    
    pot_commun(ref : Group.ref) =
        add_to_pay(nom, montant : float, pot) =
            Map.replace_or_add(nom, (last_montant -> Option.switch(v -> v - montant, 0.0-montant, last_montant)), pot)
        add_payed(nom, montant : float, pot) = 
            Map.replace_or_add(nom, (last_montant -> Option.switch(v -> v + montant, montant, last_montant)), pot)
        add_facture(facture, pot) = 
            Map.fold(
                nom,montant,pot ->
                    add_to_pay(nom, montant, pot),
                    facture.concerned,
                    add_payed(facture.emeteur, facture.montant, pot)
            )
        Option.switch(
            group ->
                List.fold(
                    facture,pot -> add_facture(facture, pot),
                    group.factures,
                    Map.empty
                )
            ,
            Map.empty,
            Group_Data.get(ref)
        )
    
    @client
    table_factures(ref : Group.ref) : TableBuilder.t(Facture.t) =
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
        table
    
    add_user(ref : Group.ref)() =
        notice = match Group_Data.add_user(ref,Dom.get_value(#new_user)) with
        | {~success} -> do show_pot_commun(ref) success
        | {~failure} -> failure
        end
        Dom.transform([#notice_add <- notice])
    
    add_facture(ref : Group.ref, table : TableBuilder.t(Facture.t))(facture : Facture.t) : void =
        do TableBuilder.add(table.channel, facture)
        do show_pot_commun(ref)
        void
    
    
    html(ref : Group.ref) : xhtml =
        xhtml() = 
            table = table_factures(ref)
            (<>
            <h1>Groupe {ref}</h1>
            <div><a href="/user/compte">My account</a></div>
            <h3>Common jar</h3>
            <div id=#pot_commun onready={_->show_pot_commun(ref)}></div>
            <h3>Add an expediture</h3>
            {NewFactureForm.show(ref, add_facture(ref, table))}
            <h3>Add somebody in the group</h3>
            <div id=#notice_add></div>
            <input id=#new_user/>
            <button onclick={_->add_user(ref)()}>Add</button>
            <h3>Accounts</h3>
            {table.xhtml}
            </>)
        
        if Group_Data.can_view(ref, User.current_user_ref()) then
            <div id=#content onready={_->Dom.transform([#content <- xhtml()])}>Groupe {ref}</div>
        else
            <div>You can't access to this group</div>


        
    
}}
