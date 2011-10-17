







urls =
    parser
    | "/" -> Resource.html("EsayCount", <>EsayCount</>)
    | "/group/view/" name=(.*) -> Resource.html("EsayCount", Group_View_Group.html("{name}"))
    | "/user/new" -> Resource.html("EasyCount", NewUserForm.show())
    | "/user/login" -> Resource.html("EasyCount", LoginUserForm.show())
    | "/user/compte" -> Resource.html("EasyCount", <>{User_View_Account.html()}</>)
    end


server = Server.simple_server(urls)
