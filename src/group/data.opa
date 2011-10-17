








Group_Data = {{
    
    empty = {name="" users=[] factures=[]}
    
    get(ref : Group.ref) : option(Group.t) =
        ?/groups[ref]
    
    get_users(ref : Group.ref) =
        /groups[ref]/users
    
    add(name : string) : outcome(string,string) =
        if Db.exists(@/groups[name]) then
            {failure = "Le nom de groupe est déjà utilisé"}
        else
            user_ref = User.current_user_ref()
            do /groups[name] <- {empty with ~name users=[user_ref]}
            groups = List.add(name,/users[name]/groups)
            do /users[user_ref]/groups <- groups
            {success = "Groupe créé"}
    
    add_facture(ref : Group.ref, facture : Facture.t) : outcome(string,string) =
        users_ingroup = /groups[ref]/users
        if List.exists(nom -> not(List.exists(_ == nom, users_ingroup)), Map.To.key_list(facture.concerned)) then
            {failure = "un nom a été mal orthographié ou n'est pas dans ce groupe"}
        else
            l = /groups[ref]/factures
            do /groups[ref]/factures <- List.add(facture, l)
            {success = "dépense ajoutée"}
    
    add_user(ref : Group.ref, new_user : User.ref) : outcome(string,string) =
        Option.switch(
            _ ->
                l = /groups[ref]/users
                do /groups[ref]/users <- List.add_uniq(String.ordering, new_user, l)
                {success = "utilisateur ajouté"}
            ,
            {failure = "Cet utilisateur n'existe pas dans la base de données"},
            User_Data.get(new_user)
        )
}}
