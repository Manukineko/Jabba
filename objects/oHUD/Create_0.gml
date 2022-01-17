
hud = new Jabba()
element = hud.CreateQuotaCounterElement()//new JabbaQuotaCounterElement(hud)
element.SetQuota(6789)
element.SetPosition(view_wport[0]-200, 32)
value = 0

timer = hud.CreateTimerElement()
timer.SetTimeFormat([JT.DAYS,JT.HOURS,JT.MIN, JT.SEC, JT.HUN])
timer.SetPosition(view_wport[0]/2, 32)
//timer.CreateTimerText()

counter = hud.CreateCounterElement()
counter.SetPosition(view_wport[0]/2, view_hport[0]-32)
counter.SetFeedback("popout", ["scale", 2])