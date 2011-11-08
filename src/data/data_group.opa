

package easycount.data







Group_Data = {{
    
    empty = {name="" users=[] factures=[]}
    
    get(ref : Group.ref) : option(Group.t) =
        ?/groups[ref]
    
    get_users(ref : Group.ref) =
        /groups[ref]/users
    
    can_view(ref : Group.ref, ref_user : User.ref) : bool =
        List.exists(_ == ref_user, /groups[ref]/users)
    
    add(name : string, user_ref : User.ref) : outcome(Group.t,string) =
        if Db.exists(@/groups[name]) then
            {failure = "Name already used"}
        else
            new_group = {empty with ~name users=[user_ref]}
            do /groups[name] <- new_group
            groups = /users[user_ref]/groups
            do /users[user_ref]/groups <- List.add(name,groups)
            {success = new_group}
    
    add_facture(ref : Group.ref, facture : Facture.t) : outcome(Facture.t,string) =
        users_ingroup = /groups[ref]/users
        if List.exists(nom -> not(List.exists(_ == nom, users_ingroup)), Map.To.key_list(facture.concerned)) then
            {failure = "a user isn't in the group or has been missplelled"}
        else
            l = /groups[ref]/factures
            do /groups[ref]/factures <- List.add(facture, l)
            {success = facture}
    
    add_user(ref : Group.ref, new_user : User.ref) : outcome(string,string) =
        Option.switch(
            _ ->
                l = /groups[ref]/users
                do /groups[ref]/users <- List.add_uniq(String.ordering, new_user, l)
                l = /users[new_user]/groups
                do /users[new_user]/groups <- List.add_uniq(String.ordering, ref,l)
                {success = "user added"}
            ,
            {failure = "This user isn't in the database, he should register before"},
            User_Data.get(new_user)
        )
    
    
    
}}
