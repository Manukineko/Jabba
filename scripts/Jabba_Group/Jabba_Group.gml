function JabbaGroup() constructor {
    x = 0
    y = 0
    angle = 0
    width = 0
    height = 0
    alpha = 0
    hide = 0
    
    memberList = []
    
    static AddMember = function(_struct){
        array_push(memberList, _struct)
    }
    
    static SetPosition = function(_x, _y, _relative){
        var _i = 0; repeat(array_length(memberList)){
            memberList[_i].SetPosition(_x,_y, _relative)
        }
        
        if _relative{
            x += _x
            y += _y
            return self
        }
        
        x = _x
        y = _y
        
        return self
    }
}