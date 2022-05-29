#region GAUGE ELEMENT
// An element that displa a value as a gauge bar (life bar, stamina bar, etc)
/// @func JabbaGaugeBarElement
/// @desc An element that will fill a gauge with a dissolve shader (default)
/// @param {int} maxValue the maximum value of the gauge
/// @param {sprite} sprite The sprite to dissolve
/// @param {sprite} mask The mask to use in the shader
/// @param {shader} shader The shader to use [default: jabbaShaderDissolve]
/// @param {string} name the name of this element [default : "Gauge Bar"]
function JabbaGaugeBarElement(_maxValue, _asset, _mask, _shader = "dissolve", _name = "Gauge Bar") : __spriteTypeElement__() constructor{
	
	#macro shaderParams activeShaderData.init
	
	//shader = jabbaShaderDissolve
	activeShaderName = _shader
	asset = _asset//sJabbaGaugeBar
	mask = _mask//sJabbaGaugeBarMask
	width = sprite_get_width(_asset)
	height = sprite_get_height(_asset)
	maxValue = _maxValue
	tolerance = 0
	inverse = true
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
	
	activeShaderData = variable_struct_get(_shaders, activeShaderName)
	//activeShaderData = _shaders.dissolve
	//activeShaderName = "dissolve"
	
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
	
	SetShader = function(_name){
		activeShaderData = variable_struct_get(_shaders, _name)
		activeShaderName = _name
	}
	
	/// @func SetValue
	/// @desc Set the value use to manipulate the gauge
	/// @param {real} value
	/// @param {boolean} triggerFeedback If the element's feedback is to be triggered when the gauge is filled (/!\ Subject to change)
	static SetValue = function(_value, _feedbackTrigger){
		
		value = min(_value, maxValue)
		_valueNormalized = value/maxValue
		hasFeedback = _feedbackTrigger
		
		//what a mess. Nothing make sens here.
		if hasFeedback && runFeedback{
			if value >= maxValue{
				value = maxValue
				//__feedbackUpdated = true
				__feedbackGetParams()
				runFeedback = false
			}
			else runFeedback = true
		}
	}
	
	/// @func Draw()
	/// @desc Draw the element
	static Draw = function(){
		if !isHidden{
			
			activeShaderData.shaderSet(_valueNormalized)
		
		}
	}
}

#endregion