
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
element.SetValue(value)