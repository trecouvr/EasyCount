

import nostdlib.tablebuilder


User_View_Account = {{

    @publish
    get_all_groups() =
        ref = User.current_user_ref()
        Option.switch(
            user -> user.groups
            ,
            [],
            User_Data.get(ref)
        )
    
    @client
    table_groups_list() : TableBuilder.t(string) =
        columns = [
            TableBuilder.mk_column(
                <>Groupe</>,
                r,_c -> <a href="/group/view/{r}">{r}</a>,
                some(r1, r2 -> String.ordering(r1, r2)),
                none
            )
        ]
        spec = TableBuilder.mk_spec(columns, get_all_groups())
        TableBuilder.make(spec)
    
    add_group(table : TableBuilder.t(string))(group : Group.t) : void =
        TableBuilder.add(table.channel, group.name)
    
    html() : xhtml =
        xhtml() = 
            table = table_groups_list()
            (<>
            <h1>My Account</h1>
            <p>Welcome {User.current_user_ref()}.</p>
            <h3>Create a new group</h3>
            {NewGroupForm.show(add_group(table))}
            <h3>My groups</h3>
            {table.xhtml}
            </>)
        
        <div id=#content onready={_->Dom.transform([#content <- xhtml()])}></div>




}}
