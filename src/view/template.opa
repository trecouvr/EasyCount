

package easycount.template

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap
WB = WBootstrap

import easycount.view.header



Template = {{
    
    page(content : xhtml) =
        Resource.styled_page("EasyCount", ["/res/header.css"], WB.Layout.fixed(View_Header.xhtml<+>content))
    
    page_onready(get_content : ->xhtml) =
        id = Dom.fresh_id()
        content = <div id=#{id} onready={_->Dom.transform([#{id} <- get_content()])}></div>
        page(content)

}}
