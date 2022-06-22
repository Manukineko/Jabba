item = 0
combo = 0
life = 0
value = 0

hud = new JabbaContainer(viewportID)
hud.SetMargin(16)

//test = new JabbaCounterElement2(10,"test Counter")
//test.SetPosition(hud.center, hud.middle ).SetBibPosition(,).SetFeedback("flash")

quotaSimple = new JabbaQuotaCounterElement("Quota", 9, "hud")
quotaSimple.SetQuota(2500)
	.SetPosition(hud.right-32, 64)
	.SetTextAlign(fa_center, fa_middle)
	.SetOrigin(MiddleCenter)

quotaExt = new JabbaQuotaCounterExtElement("Quota Ext", 9 ,"hud")//hud.CreateQuotaCounterExtElement()
quotaExt.SetQuota(2500)
	.SetPosition(hud.right-128, 32)

//
timer = new JabbaTimerElement("Timer", "hud")//hud.CreateTimerElement()
timer.SetTimeFormat([JT.MIN, JT.SEC, JT.HUN])
	.SetPosition(hud.center, 32)
	.SetTimeLimit(3000)
//
counter = new JabbaCounterElement(10, , "hud")
counter.SetPosition(hud.center, hud.bottom-128)
	.SetFeedback("flash").SetBibPosition(,).SetDefaultColor(c_white)
//	
//counter.bib.CreateFortuna("test", [
//	method(undefined, function(){
//		show_debug_message("Je suis ")
//		state++
//	}),
//	method(undefined, function(){
//		show_debug_message("FORTUNA "+string(value))
//		state++
//	})
//])
//
////GAUGE BAR with built-in shader (dissolve)
mugshot = new JabbaGraphicElement(sMugshot, "Mugshot", "hud")
mugshot.SetPosition(hud.left+34, hud.top+34).SetFeedback("flash")
gaugeBar = new JabbaGaugeBarElement(100, sJabbaGaugeBar, sJabbaGaugeBarMask, ,"Gauge Bar", "hud")
gaugeBar.SetPosition(hud.left+70,hud.top+58).SetFeedback("flash")
	.SetDefaultColor(c_orange)
mugshotFrame = new JabbaGraphicElement(sMugshotFrame, "Mugshot Frame", "hud")
mugshotFrame.SetPosition(hud.left+32, hud.top+32)
//
////GAUGE BAR with custom Shader (well, example is the same code than the built-in dissolve)
//mugshotCustomShader = hud.CreateGraphicElement(sMugshot, "Mugshot Custom")
//mugshotCustomShader.SetPosition(hud.left+34, hud.top+80)
//gaugeBarCustomShader = hud.CreateGaugeBarElement(100, sJabbaGaugeBar, sJabbaGaugeBarMask, ,"Gauge Bar Custom")
//gaugeBarCustomShader.SetPosition(hud.left+70,hud.top+104)
//	.SetColor(c_aqua)
//	.AddShader("dissolveCustom", jabbaShaderDissolve, {
//		tolerance : 0,
//		inverse : true,
//		mask_tex : sprite_get_texture(sJabbaGaugeBarMask,0),
//		mask_transform : shader_remap_uv_scale(sJabbaGaugeBar, sJabbaGaugeBarMask),
//		u_mask_tex : shader_get_sampler_index(jabbaShaderDissolve, "mask_tex"),
//		u_mask_transform : shader_get_uniform(jabbaShaderDissolve, "mask_transform"),u_time : shader_get_uniform(jabbaShaderDissolve, "time"),
//		u_tolerance : shader_get_uniform(jabbaShaderDissolve, "tolerance"),
//		u_inverse : shader_get_uniform(jabbaShaderDissolve, "inverse"),
//		},
//		function(_value){
//			shader_set(jabbaShaderDissolve)
//			texture_set_stage(shaderParams.u_mask_tex, shaderParams.mask_tex)
//			shader_set_uniform_f_array(shaderParams.u_mask_transform, shaderParams.mask_transform)
//			shader_set_uniform_f(shaderParams.u_time, _value)
//			shader_set_uniform_f(shaderParams.u_tolerance,shaderParams.tolerance)
//			shader_set_uniform_f(shaderParams.u_inverse,shaderParams.inverse)
//			draw_sprite_ext(asset,frame,x,y,xScale,yScale,angle,color,alpha)
//			shader_reset();
//		}
//	)
//	.SetShader("dissolveCustom")
//mugshotFrameCustomShader = hud.CreateGraphicElement(sMugshotFrame, "Mugshot Frame Custom")
//mugshotFrameCustomShader.SetPosition(hud.left+32, hud.top+78)
//
caroussel = new JabbaCarousselElement("caroussel", "hud") //hud.CreateCarrouselElement("Caroussel")
caroussel.SetPosition(hud.center, hud.bottom-128)
	.SetRadius(128,64)
	.SetDepth(0.8)
	.SetDrawDistance(0.5)
	.SetRotation(45)
	.AddItem(sItem1, "item J")
caroussel.AddItem(sItem2, "item A1")
caroussel.AddItem(sItem3, "item B1")
caroussel.AddItem(sItem4, "item B2")
caroussel.AddItem(sItem5, "item A2")
caroussel.SetFeedback("radiusPopout").SetFeedback("highlightItem", true)

//customOriginTest = hud.CreateGraphicElement(sItem1, "Sprite with custom origin")
//customOriginTest.SetOrigin(MiddleCenter)
//	.SetPosition(200,200)

tourne = 0

//bib fortuna test
//counter.bib.CreateFortuna("test", [
//		function(){
//			show_debug_message("Je m'appelle")
//		},
//		function(){
//			show_debug_message(value)
//		}
//	])