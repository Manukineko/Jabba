
hud = new Jabba()
element = hud.CreateQuotaCounterElement()//new JabbaQuotaCounterElement(hud)
element.SetQuota(6789)
value = 0

timer = new JabbaTimerElement()
timer.SetTimeFormat([JT.DAYS,JT.HOURS,JT.MIN, JT.SEC, JT.HUN])
//timer.CreateTimerText()