

package easycount.facture.form

import stdlib.widgets.formbuilder
import stdlib.widgets.bootstrap

import easycount.data
import easycount.user.session
import easycount.form.tools

NewFactureForm = {{
    WB = WBootstrap
    
    
    id_montant : string = "input_montant"
    id_implication(ref : User.ref) : string = 
        ref_cleaned = 
            String.replace("@","at",
            String.replace(".","p",
            "{ref}"))
        "input_inplication_{ref_cleaned}"
    
    field_montant : xhtml =
        <p>
        <label for={id_montant}>Amount</label>
        <div class="input"><input id=#{id_montant}></input></div>
        </p>
    
    field_implication(ref : User.ref) : xhtml =
        <p>
        <label for={id_implication(ref)}>Implication of {ref}</label>
        <div class="input"><input id=#{id_implication(ref)}></input></div>
        </p>
    
    
    /**
    Transform parts into value of money.
    @param montant the total amount
    @param repartition the distribution of parts computed by parse_repartition(..)
    */
    do_repartition(montant : float, repartition : list({ nb_parts: float; user_ref : User.ref })) : outcome(map(User.ref, float),string) =
        tot_parts = List.fold(v,acc -> acc+v.nb_parts, repartition, 0.0)
        if tot_parts <= 0.0 then
            {failure="Someone must pay !"}
        else
            {success=Map.From.assoc_list(List.map(v -> (v.user_ref, montant * v.nb_parts / tot_parts), repartition))}
    
    
    /**
    Compute the process fonction of the form.
    @param ref the reference of the current group
    @param edit a function to call if success to update a table
    */
    process(ref : Group.ref, users : list(User.ref), edit : (Facture.t -> void))(_) : void =
    (
        get_nb_parts(user_ref) : float =
            value = Dom.get_value(#{id_implication(user_ref)})
            if value == "" then
                0.0
            else
                match Parser.float(value) with
                    | {none} -> do jlog("error 2") 0.0
                    | {~some} -> do jlog("ok : {some}") some
                    end
        montant = Dom.get_value(#{id_montant})
        repartition = List.map(
            user_ref -> 
                {~user_ref 
                nb_parts = get_nb_parts(user_ref)
                }
            ,
            users
        )
        notice =
            match Parser.float(montant) with
            | {none} -> {failure=<>Amount must be a number</>}
            | {some=montant} ->
                match do_repartition(montant, repartition) with
                | {~failure} -> {failure=<>{failure}</>}
                | {success=real_repartition} ->
                    new_facture = {
                        date=Date.now() 
                        ~montant 
                        emeteur=User.current_user_ref()
                        concerned=real_repartition
                    }
                    match Group_Data.add_facture(ref, new_facture) with
                    | {~success} -> do edit(success) {success=<>Spending added</>}
                    | {~failure} -> {failure=<>{failure}</>}
                    end
            end
        
        do Form_Tools.notice(notice)
        void
    )
    
    /**
    Select all group
    */
    select_all_group(users : list(User.ref)) : void =
        List.iter(
            user_ref -> Dom.set_value(#{id_implication(user_ref)}, "1"),
            users
        )
    
    /**
    Get form.
    @param ref the reference of current group
    @param edit a function to update a table of spendings
    @return xhtml
    */
    show(ref : Group.ref, users : list(User.ref), edit : (Facture.t -> void)) : xhtml =
    (
        <>
        <div id=#{Form_Tools.id_notifications}></div>
        <form>
        {field_montant}
        <br/>
        {List.fold(user_ref,acc -> <>{acc}{field_implication(user_ref)}</>, users, <></>)}
        </form>
        {WB.Button.make({button="All Group" callback=(_e->select_all_group(users))}, [])}
        {WB.Button.make({button="Add" callback=process(ref, users, edit)}, [])}
        </>
    )
}}

