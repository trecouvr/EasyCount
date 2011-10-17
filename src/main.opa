



page(get_content : ->xhtml) : xhtml =
    id = Dom.fresh_id()
    <div id=#{id} onready={_->Dom.transform([#{id} <- get_content()])}></div>
    



urls =
    parser
    | "/" -> Resource.html("EsayCount", <h1>EasyCount</h1><p>Good accounts make good friends!</p><p><a href="/user/login">Login</a></p>)
    | "/group/view/" name=(.*) -> Resource.html("EsayCount", Group_View_Group.html("{name}"))
    | "/user/new" -> Resource.html("EasyCount", page(->NewUserForm.show()))
    | "/user/login" -> Resource.html("EasyCount", page(->LoginUserForm.show()))
    | "/user/compte" -> Resource.html("EasyCount", <>{User_View_Account.html()}</>)
    end


server = Server.simple_server(urls)
