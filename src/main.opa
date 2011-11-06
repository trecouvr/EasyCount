

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap
WB = WBootstrap

page_onready(get_content : ->xhtml) : xhtml =
    id = Dom.fresh_id()
    <div id=#{id} onready={_->Dom.transform([#{id} <- get_content()])}></div>

urls =
    parser
    | "/" -> template(<h1>EasyCount</h1><p>Good accounts make good friends!</p><p><a href="/user/login">Login</a></p>)
    | "/group/view/" name=(.*) -> template(Group_View_Group.html("{name}"))
    | "/user/new" -> template(page_onready(->NewUserForm.show()))
    | "/user/login" -> template(page_onready(->LoginUserForm.show()))
    | "/user/compte" -> template(User_View_Account.html())
    end

template(content : xhtml) =
    Resource.html("EasyCount", WB.Layout.fixed(content))


server = Server.simple_server(urls)
