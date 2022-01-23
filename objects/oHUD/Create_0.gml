
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

caroussel = hud.CreateCarrouselElement()
caroussel.SetPosition(200,200).addItem("item 1", sItem1)
caroussel.addItem("item 2", sItem2)
caroussel.addItem("item 3", sItem3)
caroussel.addItem("item 4", sItem4)
caroussel.addItem("item 5", sItem5)
