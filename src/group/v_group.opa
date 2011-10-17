


import easycount.chart

Group_View_Group = {{
    
    
    @publish
    get_all_factures(ref : Group.ref) =
        Option.switch(
            group -> group.factures,
            [],
            Group_Data.get(ref)
        )
    
    /**
    Compute common jar and show it.
    @param ref the reference of current group
    */
    show_pot_commun(ref : Group.ref) : void =
        pot_commun = pot_commun(ref)
        xhtml_pot_commun =
            if Map.size(pot_commun) < 2 then
                <div>Advice : You are alone in this group, you should invite somebody.</div>
            else
                random_color() =
                    s = Int.to_hex(Random.int(255))^Int.to_hex(Random.int(255))^Int.to_hex(Random.int(255))
                    Int.repeat(s -> s^"0", s, 6-String.length(s))
                names = Map.To.key_list(pot_commun)
                datas = Map.To.val_list(pot_commun)
                colors = Int.repeat(
                    accu -> List.append([random_color()],accu),
                    [],
                    Map.size(pot_commun)
                )
                chart = Chart.xhtml({Chart.default with ~datas ~colors ~names})
                <>
                {chart}
                <ul>{Map.fold(nom,montant,acc -> <>{acc}<li>{nom} : {montant}</li></>, pot_commun, <></>)}</ul>
                </>
        Dom.transform([#pot_commun <- xhtml_pot_commun])
    
    /**
    Compute common jar.
    @param ref the reference of current group
    @return a map (user->money-state)
    */
    pot_commun(ref : Group.ref) : map(User.ref, float) =
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
        /**
        Map with all users in the group.
        */
        basic_map(group : Group.t) : map(User.ref,float) = 
            Map.From.assoc_list(List.map(v -> (v,0.0), group.users))
        
        Option.switch(
            group ->
                List.fold(
                    facture,pot -> add_facture(facture, pot),
                    group.factures,
                    basic_map(group)
                )
            ,
            Map.empty,
            Group_Data.get(ref)
        )
    
    /**
    Create a TableBuilder for expeditures.
    @param ref the ref of current group
    @return the table
    */
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
    
    /**
    Add a user to the current group, using the value in the input field.
    @param ref the reference of current group
    @param id the id of input
    */
    add_user(ref : Group.ref, id : string) : void =
        notice = match Group_Data.add_user(ref,Dom.get_value(#{id})) with
        | {~success} -> do show_pot_commun(ref) success
        | {~failure} -> failure
        end
        Dom.transform([#notice_add <- notice])
    
    /**
    Add an expediture to the table
    @param ref the reference of current group
    @param table the table
    @param facture the expediture
    */
    table_add_facture(ref : Group.ref, table : TableBuilder.t(Facture.t))(facture : Facture.t) : void =
        do TableBuilder.add(table.channel, facture)
        do show_pot_commun(ref)
        void
    
    
    /**
    View of group.
    @param ref the reference of the group to see
    @return the view
    */
    html(ref : Group.ref) : xhtml =
        xhtml() = 
            table = table_factures(ref)
            (<>
            <h1>Groupe {ref}</h1>
            <div><a href="/user/compte">My account</a></div>
            <h3>Common jar</h3>
            <div id=#pot_commun onready={_->show_pot_commun(ref)}></div>
            <h3>Add an expediture</h3>
            {NewFactureForm.show(ref, table_add_facture(ref, table))}
            <h3>Add somebody in the group</h3>
            <div id=#notice_add></div>
            <input id=#new_user/>
            <button onclick={_->add_user(ref,"new_user")}>Add</button>
            <h3>Accounts</h3>
            {table.xhtml}
            </>)
        
        if Group_Data.can_view(ref, User.current_user_ref()) then
            <div id=#content onready={_->Dom.transform([#content <- xhtml()])}>Groupe {ref}</div>
        else
            <div>You can't access to this group</div>


        
    
}}
