
if keyboard_check_pressed(vk_space){
    value += 1000
    //value = clamp(value, 0, 9999)
    element.SetValue(value)
}
if keyboard_check(vk_up){
    value++;
}
if keyboard_check(vk_down){
    value--
}
