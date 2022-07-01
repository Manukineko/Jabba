/// @func JabbaGaugeBarElement
/// @desc [Type : Sprite] An Element that will fill a gauge with a dissolve shader (default). Like Life Bar, Stamina bar, etc
/// @param {int} maxValue the maximum value of the gauge [default : 100]
/// @param {sprite} sprite The sprite to dissolve [default : sJabbaGaugeBar]
/// @param {sprite} mask The mask to use in the shader [default : sJabbaGaugeBarMask]
/// @param {string} name the name of this element [default : "Gauge Bar"]
/// @param {string} JabbaContainer The name of the JabbaContainer (a struct)

function JabbaGaugeBarElement(_maxValue = 100, _asset = sJabbaGaugeBar, _mask = sJabbaGaugeBarMask, _name = "Gauge Bar", _hud = undefined) : __spriteTypeElement__() constructor{
	
	//#macro shaderParams activeShaderData.init
	
	elementType = ELEMENT.GAUGE
	limit = _maxValue
	asset = _asset
	mask = _mask
	activeShader = __shaderJabbaDissolveSet
	width = sprite_get_width(_asset)
	height = sprite_get_height(_asset)
	tolerance = 0
	inverse = true
	
	if !is_undefined(_hud) __addToHud(_hud)
	
	_valueNormalized = 0
	var _self = self
	
	//Dissolve Shader settings
	__shaderJabbaDissolveInit = {
		tolerance : 0,
		inverse : true,
		mask_tex : sprite_get_texture(mask,0),
		u_mask_tex : shader_get_sampler_index(jabbaShaderDissolve, "mask_tex"),
		mask_transform : shader_remap_uv_scale(asset, mask),
		u_mask_transform : shader_get_uniform(jabbaShaderDissolve, "mask_transform"),
		u_time : shader_get_uniform(jabbaShaderDissolve, "time"),
		u_tolerance : shader_get_uniform(jabbaShaderDissolve, "tolerance"),
		u_inverse : shader_get_uniform(jabbaShaderDissolve, "inverse"),
	}
	static __shaderJabbaDissolveSet = function(_value){
		shader_set(jabbaShaderDissolve)
			texture_set_stage(__shaderJabbaDissolveInit.u_mask_tex, __shaderJabbaDissolveInit.mask_tex)
			shader_set_uniform_f_array(__shaderJabbaDissolveInit.u_mask_transform, __shaderJabbaDissolveInit.mask_transform)
			shader_set_uniform_f(__shaderJabbaDissolveInit.u_time, _value)
			shader_set_uniform_f(__shaderJabbaDissolveInit.u_tolerance,__shaderJabbaDissolveInit.tolerance)
			shader_set_uniform_f(__shaderJabbaDissolveInit.u_inverse,__shaderJabbaDissolveInit.inverse)
			draw_sprite_ext(asset,frame,x,y,xScale,yScale,angle,color,alpha)
		shader_reset();
	}
	
	/// @func SetValue
	/// @desc Set the value use to fill the gauge
	/// @param {real} value
	/// @param {boolean} triggerFeedback If the element's feedback is to be triggered when the gauge is filled (/!\ Subject to change)
	static SetValue = function(_value, _autofeedback){
		
		value = min(_value, limit)
		_valueNormalized = value/limit
		
		if _autofeedback{
			if feedbackIsEnabled{
				__feedbackPlayOnReach()
			}
		}
	}
	
	/// @func FeedbackPlay
	/// @desc [On Reach] Play the Feedback assign to the Element
	static FeedbackPlay = function(){
		if feedbackIsEnabled{
			__feedbackPlayOnReach()
		}
	}
	
	/// @func Draw()
	/// @desc Draw the element. Bypassed if isHidden is true.
	static Draw = function(){
		if !isHidden{
			
			activeShader(_valueNormalized)
		
		}
		
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
	}
}

#endregion