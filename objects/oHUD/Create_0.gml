
hud = new Jabba()
quotaSimple = hud.CreateQuotaCounterElement()
quotaSimple.SetQuota(2500).SetPosition(view_wport[0]-200, 64).SetTextAlign(fa_right, fa_middle)


quotaExt = hud.CreateQuotaCounterExtElement()
quotaExt.SetQuota(2500).SetPosition(view_wport[0]-200, 32)
value = 0

timer = hud.CreateTimerElement()
timer.SetTimeFormat([JT.DAYS,JT.HOURS,JT.MIN, JT.SEC, JT.HUN]).SetPosition(view_wport[0]/2, 32)
//timer.CreateTimerText()

counter = hud.CreateCounterElement()
counter.SetPosition(view_wport[0]/2, view_hport[0]-32).SetFeedback("popout", ["scale", 2])

gaugeBar = hud.CreateGaugeBarElement(100)
gaugeBar.SetPosition(view_wport[0]/2, view_hport[0]-64)