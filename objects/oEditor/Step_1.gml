
activeElement = HUDObject.elementsList[element]

switch (state){
    case JabbaEd.unselected:
        if keyboard_check_pressed(vk_left){
            element--
			element = number_wrap(element,0,elementSize, false)
			xx = HUDObject.elementsList[element].x
            yy = HUDObject.elementsList[element].y
        }
        else if keyboard_check_pressed(vk_right){
            element++
			element = number_wrap(element,0,elementSize, false)
			xx = HUDObject.elementsList[element].x
            yy = HUDObject.elementsList[element].y
        }
        if keyboard_check_pressed(vk_space){
            state = JabbaEd.selected
            
            
            
			
        }
    break
    
    case JabbaEd.selected:
    var _xpos, _ypos
        if keyboard_check_pressed(vk_left){
            xx -= 1
            _xpos = xx-HUDObject.margin.left
        }
        else if keyboard_check_pressed(vk_right){
            xx += 1
        }
        if keyboard_check_pressed(vk_up){
            yy -= 1
        }
        else if keyboard_check_pressed(vk_down){
            yy += 1
        }
		if keyboard_check_pressed(vk_space){
            state = JabbaEd.unselected
        }
        HUDObject.elementsList[element].SetPosition(xx, yy)
       
	break
}

x = xx
y = yy

str = "X :"+string(xx)+"\nY :"+string(yy)