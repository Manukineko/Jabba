
if keyboard_check_pressed(vk_space){
    value += 1000
    counter.SetValue(1)
    //value = clamp(value, 0, 9999)
    
}
if keyboard_check(vk_up){
    value++;
}
if keyboard_check(vk_down){
    value--
}
if keyboard_check_pressed(ord("H")){
    quotaSimple.ToggleHide()
    show_debug_message("hide:"+string(quotaSimple.isHidden))
}

quotaSimple.SetValue(value)
quotaExt.SetValue(value)
gaugeBar.SetValue(value)
timer.UpdateTime(get_timer()/1000)
caroussel.Update()

//currentTime = get_timer()
//elapsedTime = (currentTime - previousTime) / 1000
//timer.UpdateTime(currentTime)

hud.FeedbackPlayer()