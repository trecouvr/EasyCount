
package easycount.user.view

import stdlib.widgets.bootstrap

import nostdlib.tablebuilder
import easycount.group.form
import easycount.data
import easycount.user.session


User_View_Account = {{
    WB = WBootstrap
    
    /**
    Get all groups the current user is in.
    */
    @publish
    get_all_groups() =
    (
        ref = User.current_user_ref()
        Option.switch(
            user -> user.groups
            ,
            [],
            User_Data.get(ref)
        )
    )
    
    /**
    Compute the table of current-user's groups.
    @return table a TableBuilder.t
    */
    @client
    table_groups() : TableBuilder.t(string) =
    (
        columns = [
            TableBuilder.mk_column(
                <>Groupe</>,
                r,_c -> <a href="/group/view/{String.replace(" ","%20",r)}">{r}</a>,
                some(r1, r2 -> String.ordering(r1, r2)),
                none
            )
        ]
        spec = TableBuilder.mk_spec(columns, get_all_groups())
        TableBuilder.make(spec)
    )
    
    
    /**
    Add a group to the table.
    @param table the table
    @param group the group to add
    */
    table_add_group(table : TableBuilder.t(string))(group : Group.t) : void =
    (
        TableBuilder.add(table.channel, group.name)
    )
    
    
    /**
    The view of the account.
    @return xhtml
    */
    html() : xhtml =
    (
        xhtml() = 
        (
            table = table_groups()
            WB.Typography.header(1, none, <>My Account</>)
            <+>
            <p>Welcome {User.current_user_ref()}.</p>
            <+>
            WB.Typography.header(3, none, <>Create a new group</>)
            <+>
            WB.List.ordered([
                <>Create a group</>,
                <>Invite people</>,
                <>Manage your acounts</>,
            ])
            <+>
            NewGroupForm.show(table_add_group(table))
            <+>
            WB.Typography.header(3, none, <>Groups you are member of</>)
            <+>
            table.xhtml
        )
        
        <div id=#content onready={_->Dom.transform([#content <- xhtml()])}></div>
    )



}}
