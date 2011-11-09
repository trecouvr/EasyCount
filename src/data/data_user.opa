

package easycount.data


User_Data = {{
    
    ref_anonymous : User.ref = "anonymous"
    
    string_to_ref(s : string) : User.ref =
        String.to_lower(s)
    
    @stringifier(User.ref)
    ref_to_string(ref : User.ref) : string =
        "{ref}"
    
    @xmlizer(User.ref)
    ref_to_xml(ref : User.ref) : xml =
        <>{"{ref}"}</>
    
    fold(f : User.ref,User.t,'a -> 'a, acc : 'a) : 'a =
        Db.stringmap_fold_range(
            @/users,
            (acc,ref -> f(ref, /users[ref], acc)),
            acc,
            "", none, (_->true)
        )
    
    ordering(r1 : User.ref, r2 : User.ref) = 
        String.ordering(r1,r2)
    
    add(name : string, password : string) : outcome(string, string) =
    (
        if Db.exists(@/users[name]) then
            {failure = "Name '{name}' already used"}
        else
            do /users[name] <- {~name ~password groups=[]}
            {success = "User '{name}' added"}
    )
    
    get(ref : User.ref) : option(User.t) =
        ?/users[ref]
    
}}
