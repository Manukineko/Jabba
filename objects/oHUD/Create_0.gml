
hud = new Jabba()
element = hud.CreateQuotaCounterElement()//new JabbaQuotaCounterElement(hud)
element.SetQuota(6789)
value = 0

timer = new JabbaTimerElement()
func = timer.SetFormat([JT.MIN, JT.SEC,JT.HUN])
test = func(60000)
show_debug_message(test)
// currentTime = get_timer()
// previousTime = currentTime
// elapsedTime = (currentTime - previousTime) / 1000