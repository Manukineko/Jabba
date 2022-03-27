if !instance_exists(oEditor){
	if keyboard_check_pressed(vk_space){
	    value += irandom(100)
	    combo = value_wrap_selector(combo,+1,[0,1,2,3,4,5])
	    
	    counter.SetValue(combo)
	    //value = clamp(value, 0, 9999)
	    
	}
	if keyboard_check(vk_up){
	    life++
	    life = min(life,100)
		gaugeBar1.SetValue(life)
	}
	if keyboard_check(vk_down){
	    life--
	    life = max(life,0)
		gaugeBar1.SetValue(life)
	}
	if keyboard_check_pressed(ord("H")){
	    hud.ToggleHide()
	    show_debug_message("hide:"+string(hud.isHidden))
	}
	
	if keyboard_check_pressed(vk_left){
	    item = value_wrap_selector(item, -1, [0,1,2,3,4])
	    caroussel.SetValue(item)
	}
	
	if keyboard_check_pressed(vk_right){
	    item = value_wrap_selector(item, +1, [0,1,2,3,4])
	    caroussel.SetValue(item)
	}
}

quotaSimple.SetValue(value)
quotaExt.SetValue(value)
//gaugeBar1.SetValue(life)
timer.SetTime(get_timer()/1000)
//caroussel.Update()

//currentTime = get_timer()
//elapsedTime = (currentTime - previousTime) / 1000
//timer.UpdateTime(currentTime)

//hud.FeedbackPlayer()

