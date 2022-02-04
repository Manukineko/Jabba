
#macro HUDObject oHUD.hud


enum JabbaEd{
    unselected,
    selected,
    save
}

xx = x
yy = y
state = JabbaEd.unselected
element = 0
elementSize = 0
with(HUDObject){
    other.elementSize = elementsListSize
}