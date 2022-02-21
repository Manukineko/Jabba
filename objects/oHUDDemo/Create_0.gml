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


/// @func draw_sprite_offset(sprite, x, y, xoffset, yoffset, rotation)
/// @param sprite_index
/// @param x
/// @param y
/// @param xoffset
/// @param yoffset
/// @param rotation
draw_sprite_offset = function(_sprite, _x, _y, _xOffset, _yOffset, _rot) {
    var _c = dcos(_rot);
    var _s = dsin(_rot);
    var _oX = -sprite_get_xoffset(_sprite) + _xOffset;
    var _oY = -sprite_get_yoffset(_sprite) + _yOffset;
    draw_sprite_ext(_sprite, 0, _x - _c * _oX - _s * _oY, _y - _c * _oY + _s * _oX, 1, 1, _rot, c_white, 1);
}
tourne = 0
