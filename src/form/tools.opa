

package easycount.form.tools

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap

Form_Tools = {{
    WB = WBootstrap
    
    id_notifications : string = "id_notif"
    
    /**
    Make a notification
    */
    notice(outcome : outcome(xhtml,xhtml)) : void =
        (title,t,content) = match outcome with
        | {~success} -> ("OK", {success}, success)
        | {~failure} -> ("Error", {error}, failure)
        end
        WBalert = WB.Message.make(
            {alert={~title description=<>{content}</>} closable=true},
            t
        )
        Dom.transform([#{id_notifications} <- WBalert])



}}
