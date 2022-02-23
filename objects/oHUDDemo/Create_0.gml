item = 0
combo = 0
life = 0

hud = new JabbaContainer(viewportID)
hud.SetMargin(16)
quotaSimple = hud.CreateQuotaCounterElement()
quotaSimple.SetQuota(2500).SetPosition(hud.right-32, 64).SetTextAlign(fa_right, fa_middle)

//hud.CreateQuotaCounterElement().SetQuota(2500).SetPosition(hud.right-32, 64).SetTextAlign(fa_right, fa_middle)


quotaExt = hud.CreateQuotaCounterExtElement()
quotaExt.SetQuota(2500).SetPosition(hud.right-128, 32)
value = 0

timer = hud.CreateTimerElement()
timer.SetTimeFormat([JT.MIN, JT.SEC, JT.HUN]).SetPosition(hud.center, 32)
//timer.CreateTimerText()

counter = hud.CreateCounterElement()
counter.SetPosition(hud.center, hud.bottom-128).SetFeedback("popout")

mugshot = hud.CreateGraphicElement(sMugshot)
mugshot.SetPosition(hud.left+34, hud.top+34)
gaugeBar1 = hud.CreateGaugeBarElement(100)
gaugeBar1.SetPosition(hud.left+70,hud.top+58).SetColor(c_lime)
mugshotFrame = hud.CreateGraphicElement(sMugshotFrame)
mugshotFrame.SetPosition(hud.left+32, hud.top+32)


caroussel = hud.CreateCarrouselElement()
caroussel.SetPosition(hud.center, hud.bottom-128).SetRadius(128,64).SetDepth(0.8).SetDrawDistance(0.5).SetFeedback("none").AddItem("item 1", sItem1)
caroussel.AddItem("item 2", sItem2)
caroussel.AddItem("item 3", sItem3)
caroussel.AddItem("item 4", sItem4)
caroussel.AddItem("item 5", sItem5)

customOriginTest = hud.CreateGraphicElement(sItem1)
customOriginTest.SetOrigin(0,0).SetPosition(200,200)

tourne = 0
