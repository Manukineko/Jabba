#region GAUGE ELEMENT
// An element that displa a value as a gauge bar (life bar, stamina bar, etc)

function JabbaGaugeBarElement(_maxValue, _name = "") : __spriteTypeElement__() constructor{
	
	#macro shaderParams activeShaderData.params
	
	shader = jabbaShaderDissolve
	asset = sJabbaGaugeBar
	mask = sJabbaGaugeBarMask
	width = sprite_get_width(asset)
	height = sprite_get_height(asset)
	maxValue = _maxValue
	tolerance = 0
	inverse = true
	_valueNormalized = 0
	
	_shaders = {
		dissolve : {
			shaderScript : jabbaShaderDissolve,
			params : {
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
					texture_set_stage(params.u_mask_tex, params.mask_tex)
					shader_set_uniform_f_array(params.u_mask_transform, params.mask_transform)
					shader_set_uniform_f(params.u_time, _value)
					shader_set_uniform_f(params.u_tolerance,params.tolerance)
					shader_set_uniform_f(params.u_inverse,params.inverse)
					draw_sprite_ext(asset,frame,xx,yy,xScale,yScale,angle,color,alpha)
				shader_reset();
			}
			
		}
	}
	
	activeShaderData = _shaders.dissolve
	activeShaderName = "dissolve"
	
	AddShader = function (_name, _shader, _init, _set ){
		var _struct = {}
		with(_struct){
			shaderScript = _shader
			params = _init
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