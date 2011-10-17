

type User.state = 
{disconnect} /
{connect : User.ref}

User = {{
    
    state = UserContext.make({disconnect} : User.state)
    
    login(name : string, password : string) : outcome(string,string) = 
    (
        Option.switch(
            u ->
                if u.password == password then
                    do UserContext.change(_s -> {connect=name}, state)
                    {success = "Connection établie"}
                else
                    {failure = "Mauvais mot de passe"}
            ,
            {failure = "L'utilisateur n'existe pas"},
            User_Data.get(name)
        )
    )
    
    is_log() : bool =
    (
        match UserContext.execute(s->s,state) with
        | {connect=_} -> true
        | _ -> false
        end
    )
    
    current_user_ref() : User.ref =
    (
        UserContext.execute(
            s ->
                match s with
                | {connect=ref} -> ref
                | _ -> "anonymous"
                end
            , state
        )
    )



}}
