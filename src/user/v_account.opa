

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
    xhtml_groups_list() : xhtml =
        columns = [
            TableBuilder.mk_column(
                <>Groupe</>,
                r,_c -> <a href="/group/view/{r}">{r}</a>,
                some(r1, r2 -> String.ordering(r1, r2)),
                none
            )
        ]
        spec = TableBuilder.mk_spec(columns, get_all_groups())
        table = TableBuilder.make(spec)
        table.xhtml
    
    html() : xhtml =
        xhtml() = (<>
        <h1>Mon Compte</h1>
        <p>Bievenue {User.current_user_ref()}.</p>
        <div>
            <h3>Créer un groupe</h3>
            {NewGroupForm.show()}
        </div>
        {xhtml_groups_list()}
        </>)
        
        <div id=#content onready={_->Dom.transform([#content <- xhtml()])}></div>




}}
