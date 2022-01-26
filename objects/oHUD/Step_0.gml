
if keyboard_check_pressed(vk_space){
    value += 1000
    combo++
    combo = number_wrap(combo,0,10,true)
    
    counter.SetValue(combo)
    //value = clamp(value, 0, 9999)
    
}
if keyboard_check(vk_up){
    life++;
}
if keyboard_check(vk_down){
    life--
}
if keyboard_check_pressed(ord("H")){
    quotaSimple.ToggleHide()
    show_debug_message("hide:"+string(quotaSimple.isHidden))
}

if keyboard_check_pressed(vk_left){
    item--
    item = number_wrap(item,0,4,true)
    caroussel.SetValue(item)
}

if keyboard_check_pressed(vk_right){
    item++
    item = number_wrap(item,0,4,true)
    caroussel.SetValue(item)
}

quotaSimple.SetValue(value)
quotaExt.SetValue(value)
gaugeBar.SetValue(life)
timer.UpdateTime(get_timer()/1000)
caroussel.Update()

//currentTime = get_timer()
//elapsedTime = (currentTime - previousTime) / 1000
//timer.UpdateTime(currentTime)

hud.FeedbackPlayer()