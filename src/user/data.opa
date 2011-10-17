




User_Data = {{
    
    
    @stringifier(User.ref)
    ref_to_string(ref : User.ref) : string =
        "{ref}"
    
    add(name : string, password : string) : outcome(string, string) =
    (
        if Db.exists(@/users[name]) then
            {failure = "Nom déjà utilisé"}
        else
            do /users[name] <- {~name ~password groups=[]}
            {success = "Utilisateur ajouté"}
    )
    
    get(ref : User.ref) : option(User.t) =
        ?/users[ref]
    
}}
