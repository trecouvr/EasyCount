

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap
WB = WBootstrap


urls =
    parser
    | "/" -> page(<h1>EasyCount</h1><p>Good accounts make good friends!</p><p><a href="/user/login">Login</a></p>)
    | "/group/view/" name=(.*) -> page_onready(->Group_View_Group.html("{name}"))
    | "/user/new" -> page_onready(->NewUserForm.show())
    | "/user/login" -> page(LoginUserForm.show())
    | "/user/compte" -> page(User_View_Account.html())
    end

page(content : xhtml) =
    Resource.html("EasyCount", WB.Layout.fixed(content))

page_onready(content : ->xhtml) =
    id = Dom.fresh_id()
    Resource.html("EasyCount", WB.Layout.fixed(<div onready={_->Dom.transform([#{id} <- content()])}>Loading...</div>))

server = Server.simple_server(urls)
