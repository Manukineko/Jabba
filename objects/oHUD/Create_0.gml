item = 0
combo = 0
life = 0

hud = new Jabba()
quotaSimple = hud.CreateQuotaCounterElement()
quotaSimple.SetQuota(2500).SetPosition(hud.width-200, 64).SetTextAlign(fa_right, fa_middle)


quotaExt = hud.CreateQuotaCounterExtElement()
quotaExt.SetQuota(2500).SetPosition(view_wport[0]-200, 32)
value = 0

timer = hud.CreateTimerElement()
timer.SetTimeFormat([JT.MIN, JT.SEC, JT.HUN]).SetPosition(view_wport[0]/2, 32)
//timer.CreateTimerText()

counter = hud.CreateCounterElement()
counter.SetPosition(view_wport[0]/2, view_hport[0]-128).SetFeedback("popout", ["scale", 2])

gaugeBar = hud.CreateGaugeBarElement(100)
gaugeBar.SetPosition(32,64)//.SetFlip(true)

caroussel = hud.CreateCarrouselElement()
caroussel.SetPosition(view_wport[0]/2, view_hport[0]-128).SetRadius(128,64).SetDepth(0.8).SetDrawDistance(0.5).SetFeedback("none").AddItem("item 1", sItem1)
caroussel.AddItem("item 2", sItem2)
caroussel.AddItem("item 3", sItem3)
caroussel.AddItem("item 4", sItem4)
caroussel.AddItem("item 5", sItem5)
