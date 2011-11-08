

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap
WB = WBootstrap


import easycount.user.view
import easycount.user.form
import easycount.user.session
import easycount.group.view
import easycount.group.form



page_onready(get_content : ->xhtml) : xhtml =
    id = Dom.fresh_id()
    <div id=#{id} onready={_->Dom.transform([#{id} <- get_content()])}></div>

urls : Parser.general_parser(http_request -> resource) =
    parser
    | "/" -> _req -> template(<h1>EasyCount</h1><p>Good accounts make good friends!</p><p><a href="/user/login">Login</a></p>)
    | "/favicon.gif" ->  _req -> @static_resource("res/logo-40.png")
    | "/group/view/" name=(.*) -> _req -> template(Group_View_Group.html("{name}"))
    | "/user/new" -> _req -> template(page_onready(->NewUserForm.show()))
    | "/user/login" -> _req -> template(page_onready(->LoginUserForm.show()))
    | "/user/compte" -> _req -> template(User_View_Account.html())
    end

template(content : xhtml) =
    Resource.html("EasyCount", WB.Layout.fixed(content))


server = Server.make(Resource.add_auto_server(@static_resource_directory("res"),urls))
