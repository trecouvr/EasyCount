
package easycount.user.session

import stdlib.widgets.bootstrap
import stdlib.web.client

import easycount.data



type User.state = 
{disconnect} /
{connect : User.ref}

User = {{
    WB = WBootstrap
    
    state = UserContext.make({disconnect} : User.state)
    
    login(name : User.ref, password : string) : outcome(string,string) = 
    (
        Option.switch(
            u ->
                if u.password == password then
                    do UserContext.change(_s -> {connect=name}, state)
                    {success = "Connection established"}
                else
                    {failure = "Wrong password"}
            ,
            {failure = "User doesn't exist"},
            User_Data.get(name)
        )
    )
    
    logout() : void =
    (
        UserContext.change(_s -> {disconnect}, state)
    )
    
    /**
    Button logout, after logout, the client go to the login page
    */
    btn_logout : xhtml =
    (
        callback(_e) = 
            do logout()
            Client.goto("/user/login")
        WB.Button.make({button="Logout" ~callback}, [])
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
                | _ -> User_Data.ref_anonymous
                end
            , state
        )
    )



}}
