
hud = new Jabba()
element = hud.CreateQuotaCounterElement()//new JabbaQuotaCounterElement(hud)
element.SetQuota(6789)
value = 0

timer = new JabbaTimerElement()
currentTime = get_timer()
previousTime = currentTime
elapsedTime = (currentTime - previousTime) / 1000