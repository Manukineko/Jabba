function JabbaGroup() constructor {
    x = 0
    y = 0
    x1 = 0
    x2 = 0
    y1 = 0
    y2 = 0
    xo = 0
    yo = 0
    angle = 0
    width = 0
    height = 0
    alpha = 0
    hide = 0
    
    memberList = []
    
    static AddMember = function(_member){
        if is_array(_member){
            var _i = 0; repeat(array_length(_member)){
                array_push(memberList, _member[_i])
                _i++
            }
        }else if is_struct(_member) array_push(memberList, _member)
        
        __getGroupeOrigin()
        
        return self
    }
    
    static SetPosition = function(_x, _y, _relative){
        var _i = 0; repeat(array_length(memberList)){
            memberList[_i].SetPosition(_x,_y, _relative)
            _i++
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
    
    static __getGroupeOrigin = function(){
        var _xpriority = ds_priority_create()
        var _ypriority = ds_priority_create()
        var _i = 0; repeat(array_length(memberList)){
            ds_priority_add(_xpriority, memberList[_i], memberList[_i].xOrigin)
            ds_priority_add(_ypriority, memberList[_i], memberList[_i].yOrigin)
        }
        
        var _x1 = ds_priority_find_min(_xpriority)
        var _y1 = ds_priority_find_min(_ypriority)
        var _x2 = ds_priority_find_max(_xpriority)
        var _y2 = ds_priority_find_max(_ypriority)
		x1 = _x1.xOrigin
		y1 = _y1.yOrigin
		x2 = _x2.xOrigin
		y2 = _y2.yOrigin
        width = x2 - x1
        height = y2 - y1
        xo = x1 + width/2
        yo = y1 + height/2
        ds_priority_destroy(_xpriority)
        ds_priority_destroy(_ypriority)
    }
    
    //Not Working properly (+ I hate Trigonometry, so later)
    //static SetRotation = function(_angle){
    //    var _i = 0; repeat(array_length(memberList)){
    //        memberList[_i].SetRotation(_angle)
    //        _i++
    //    }
    //}
    
    static DrawGroup = function(){
        draw_rectangle_color(x+x1,y+y1,x+x2,y+y2, c_blue, c_blue, c_blue, c_blue, true)
        draw_circle_color(x,y, 1, c_blue, c_blue, true)
    }
}