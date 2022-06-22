/// @func JabbaGaugeBarElement
/// @desc [Type : Sprite] An Element that will fill a gauge with a dissolve shader (default). Like Life Bar, Stamina bar, etc
/// @param {int} maxValue the maximum value of the gauge [default : 100]
/// @param {sprite} sprite The sprite to dissolve [default : sJabbaGaugeBar]
/// @param {sprite} mask The mask to use in the shader [default : sJabbaGaugeBarMask]
/// @param {shader} shader The shader to use [default: jabbaShaderDissolve]
/// @param {string} name the name of this element [default : "Gauge Bar"]
/// @param {string} JabbaContainer The name of the JabbaContainer (a struct)

function JabbaGaugeBarElement(_maxValue = 100, _asset = sJabbaGaugeBar, _mask = sJabbaGaugeBarMask, _shader = "dissolve", _name = "Gauge Bar", _hud = undefined) : __spriteTypeElement__() constructor{
	
	#macro shaderParams activeShaderData.init
	
	limit = _maxValue
	asset = _asset
	mask = _mask
	activeShaderName = _shader
	width = sprite_get_width(_asset)
	height = sprite_get_height(_asset)
	tolerance = 0
	inverse = true
	
	if !is_undefined(_hud) __addToHud(_hud)
	
	_valueNormalized = 0
	var _self = self
	_shaders = {
		dissolve : {
			///!\ Only for buit-in shader : store reference of the constructor variables to use them in the ShaderSet function below. Enjoy scoping XD
			owner : _self,
			//
			shaderScript : jabbaShaderDissolve,
			init : {
				tolerance : 0,
				inverse : true,
				mask_tex : sprite_get_texture(mask,0),
				u_mask_tex : shader_get_sampler_index(jabbaShaderDissolve, "mask_tex"),
				mask_transform : shader_remap_uv_scale(asset, mask),
				u_mask_transform : shader_get_uniform(jabbaShaderDissolve, "mask_transform"),
				u_time : shader_get_uniform(jabbaShaderDissolve, "time"),
				u_tolerance : shader_get_uniform(jabbaShaderDissolve, "tolerance"),
				u_inverse : shader_get_uniform(jabbaShaderDissolve, "inverse"),
			},
			
			shaderSet : function(_value){
				shader_set(shaderScript)
					texture_set_stage(init.u_mask_tex, init.mask_tex)
					shader_set_uniform_f_array(init.u_mask_transform, init.mask_transform)
					shader_set_uniform_f(init.u_time, _value)
					shader_set_uniform_f(init.u_tolerance,init.tolerance)
					shader_set_uniform_f(init.u_inverse,init.inverse)
					draw_sprite_ext(owner.asset,owner.frame,owner.xx,owner.yy,owner.xScale,owner.yScale,owner.angle,owner.color,owner.alpha)
				shader_reset();
			}
			
		}
	}
	
	//set the shader by default at initialisation
	activeShaderData = variable_struct_get(_shaders, activeShaderName)
	
	
	/// @func SetValue
	/// @desc Set the value use to fill the gauge
	/// @param {real} value
	/// @param {boolean} triggerFeedback If the element's feedback is to be triggered when the gauge is filled (/!\ Subject to change)
	static SetValue = function(_value, _feedbackTrigger){
		
		value = min(_value, limit)
		_valueNormalized = value/limit
		hasFeedback = _feedbackTrigger
		
		if enableFeedback{
			__feedbackPlayOnReach()
		}
		
		
	
	}
	
	/// @func AddShader
	/// @desc Add a custom shader to the shader list. /!\ HIGHLY EXPERIMENTAL
	/// @param {string} name The name of the shader
	/// @param {shader} shader the shader script
	/// @param {function} Init	The init function (starting value)
	/// @param {function} ShaderSet The code to draw the shader (must include shader_set() and shader_reset() )
	AddShader = function (_name, _shader, _init, _set ){
		var _struct = {}
		with(_struct){
			shaderScript = _shader
			init = _init
			shaderSet = method(other,_set)
		}
		
		variable_struct_set(_shaders, _name, _struct)
		
		return self
		
	}
	
	/// @func SetShader
	/// @desc Select and set the shader to use with the gauge
	/// @param {string} name the name of the shader (not the shader script)
	SetShader = function(_name){
		activeShaderData = variable_struct_get(_shaders, _name)
		activeShaderName = _name
	}
	
	
	
	/// @func Draw()
	/// @desc Draw the element. Bypassed if isHidden is true.
	static Draw = function(){
		if !isHidden{
			
			activeShaderData.shaderSet(_valueNormalized)
		
		}
		
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
	}
}

#endregion