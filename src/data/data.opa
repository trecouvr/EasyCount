

package easycount.data

import stdlib.core.date



@abstract type User.ref = string
type User.t = {
    name : string
    password : string
    groups : list(Group.ref)
}


type Group.ref = string
type Group.t = {
    name : string
    users : list(User.ref)
    factures : list(Facture.t)
}


type Facture.t = {
    date : Date.date
    montant : float
    emeteur : User.ref
    concerned : map(User.ref, float)
}

db /users : map(User.ref, User.t)
db /groups : map(Group.ref, Group.t)
