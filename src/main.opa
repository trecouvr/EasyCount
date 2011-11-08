


import easycount.template
import easycount.user.view
import easycount.user.form
import easycount.user.session
import easycount.group.view
import easycount.group.form




urls : Parser.general_parser(http_request -> resource) =
    parser
    | "/" -> _req -> Template.page(home)
    | "/favicon.gif" ->  _req -> @static_resource("res/logo-40.png")
    | "/logo-128.png" ->  _req -> @static_resource("res/logo-128.png")
    | "/group/view/" name=(.*) -> _req -> Template.page(Group_View_Group.html(String.replace("%20"," ","{name}")))
    | "/user/new" -> _req -> Template.page_onready(->NewUserForm.show())
    | "/user/login" -> _req -> Template.page_onready(->LoginUserForm.show())
    | "/user/compte" -> _req -> Template.page(User_View_Account.html())
    end


home : xhtml =
    <p style="text-align: center;"><br/><br/><br/><br/><a href="/user/login">Login</a></p>

server = Server.make(Resource.add_auto_server(@static_resource_directory("res"),urls))
