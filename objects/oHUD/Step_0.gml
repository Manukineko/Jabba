
if keyboard_check_pressed(vk_space){
    value += 1000
    //value = clamp(value, 0, 9999)
    
}
if keyboard_check(vk_up){
    value++;
}
if keyboard_check(vk_down){
    value--
}
if keyboard_check_pressed(ord("H")){
    element.ToggleHide()
    show_debug_message("hide:"+string(element.isHidden))
}

element.SetValue(value)
timer.UpdateTime(get_timer()/1000)

//currentTime = get_timer()
//elapsedTime = (currentTime - previousTime) / 1000
//timer.UpdateTime(currentTime)