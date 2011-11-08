

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap
WB = WBootstrap


import easycount.user.view
import easycount.user.form
import easycount.user.session
import easycount.group.view
import easycount.group.form
import easycount.view.header



page_onready(get_content : ->xhtml) : xhtml =
    id = Dom.fresh_id()
    <div id=#{id} onready={_->Dom.transform([#{id} <- get_content()])}></div>

template(content : xhtml, style : list(string)) =
    Resource.styled_page("EasyCount", style, WB.Layout.fixed(content))

urls : Parser.general_parser(http_request -> resource) =
    parser
    | "/" -> _req -> template(home, ["/res/header.css"])
    | "/favicon.gif" ->  _req -> @static_resource("res/logo-40.png")
    | "/logo-128.png" ->  _req -> @static_resource("res/logo-128.png")
    | "/logo-256.png" ->  _req -> @static_resource("res/logo-256.png")
    | "/logo-512.png" ->  _req -> @static_resource("res/logo-512.png")
    | "/group/view/" name=(.*) -> _req -> template(Group_View_Group.html("{name}"), [])
    | "/user/new" -> _req -> template(page_onready(->NewUserForm.show()), [])
    | "/user/login" -> _req -> template(page_onready(->LoginUserForm.show()), [])
    | "/user/compte" -> _req -> template(User_View_Account.html(), [])
    end


home : xhtml =
    View_Header.xhtml
    <+>
    <p id=#login_button ><a href="/user/login">Login</a></p>

server = Server.make(Resource.add_auto_server(@static_resource_directory("res"),urls))
