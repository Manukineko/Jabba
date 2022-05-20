item = 0
combo = 0
life = 0

hud = new JabbaContainer(viewportID)
hud.SetMargin(16)

quotaSimple = hud.CreateQuotaCounterElement()
quotaSimple.SetQuota(2500)
	.SetPosition(hud.right-32, 64)
	.SetTextAlign(fa_center, fa_middle)
	.SetOrigin(MiddleCenter)

quotaExt = hud.CreateQuotaCounterExtElement()
quotaExt.SetQuota(2500)
	.SetPosition(hud.right-128, 32)
value = 0

timer = hud.CreateTimerElement()
timer.SetTimeFormat([JT.MIN, JT.SEC, JT.HUN])
	.SetPosition(hud.center, 32)

counter = hud.CreateCounterElement(10)
counter.SetPosition(hud.center, hud.bottom-128)
	.SetFeedback("fliponce")
	
counter.bib.CreateFortuna("test", [
	method(undefined, function(){
		show_debug_message("Je suis ")
		state++
	}),
	method(undefined, function(){
		show_debug_message("FORTUNA "+string(value))
		state++
	})
])

//GAUGE BAR with built-in shader (dissolve)
mugshot = hud.CreateGraphicElement(sMugshot, "Mugshot")
mugshot.SetPosition(hud.left+34, hud.top+34)
gaugeBar = hud.CreateGaugeBarElement(100, sJabbaGaugeBar, sJabbaGaugeBarMask, ,"Gauge Bar")
gaugeBar.SetPosition(hud.left+70,hud.top+58)
	.SetColor(c_orange)
mugshotFrame = hud.CreateGraphicElement(sMugshotFrame, "Mugshot Frame")
mugshotFrame.SetPosition(hud.left+32, hud.top+32)

//GAUGE BAR with custom Shader (well, example is the same code than the built-in dissolve)
mugshotCustomShader = hud.CreateGraphicElement(sMugshot, "Mugshot Custom")
mugshotCustomShader.SetPosition(hud.left+34, hud.top+80)
gaugeBarCustomShader = hud.CreateGaugeBarElement(100, sJabbaGaugeBar, sJabbaGaugeBarMask, ,"Gauge Bar Custom")
gaugeBarCustomShader.SetPosition(hud.left+70,hud.top+104)
	.SetColor(c_aqua)
	.AddShader("dissolveCustom", jabbaShaderDissolve, {
		tolerance : 0,
		inverse : true,
		mask_tex : sprite_get_texture(sJabbaGaugeBarMask,0),
		mask_transform : shader_remap_uv_scale(sJabbaGaugeBar, sJabbaGaugeBarMask),
		u_mask_tex : shader_get_sampler_index(jabbaShaderDissolve, "mask_tex"),
		u_mask_transform : shader_get_uniform(jabbaShaderDissolve, "mask_transform"),u_time : shader_get_uniform(jabbaShaderDissolve, "time"),
		u_tolerance : shader_get_uniform(jabbaShaderDissolve, "tolerance"),
		u_inverse : shader_get_uniform(jabbaShaderDissolve, "inverse"),
		},
		function(_value){
			shader_set(jabbaShaderDissolve)
			texture_set_stage(shaderParams.u_mask_tex, shaderParams.mask_tex)
			shader_set_uniform_f_array(shaderParams.u_mask_transform, shaderParams.mask_transform)
			shader_set_uniform_f(shaderParams.u_time, _value)
			shader_set_uniform_f(shaderParams.u_tolerance,shaderParams.tolerance)
			shader_set_uniform_f(shaderParams.u_inverse,shaderParams.inverse)
			draw_sprite_ext(asset,frame,x,y,xScale,yScale,angle,color,alpha)
			shader_reset();
		}
	)
	.SetShader("dissolveCustom")
mugshotFrameCustomShader = hud.CreateGraphicElement(sMugshotFrame, "Mugshot Frame Custom")
mugshotFrameCustomShader.SetPosition(hud.left+32, hud.top+78)

caroussel = hud.CreateCarrouselElement("Caroussel")
caroussel.SetPosition(hud.center, hud.bottom-128)
	.SetRadius(128,64)
	.SetDepth(0.8)
	.SetDrawDistance(0.5)
	.SetRotation(45)
	.AddItem(sItem1, "item J" )
caroussel.AddItem(sItem2, "item A1")
caroussel.AddItem(sItem3, "item B1")
caroussel.AddItem(sItem4, "item B2")
caroussel.AddItem(sItem5, "item A2")
caroussel.SetFeedback("popout").SetFeedback("highlight", true)

customOriginTest = hud.CreateGraphicElement(sItem1, "Sprite with custom origin")
customOriginTest.SetOrigin(MiddleCenter)
	.SetPosition(200,200)

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