#region GAUGE ELEMENT
// An element that displa a value as a gauge bar (life bar, stamina bar, etc)

function JabbaGaugeBarElement(_maxValue, _name = "") : __spriteTypeElement__() constructor{
	
	shader = jabbaShaderDissolve
	asset = sJabbaGaugeBar
	mask = sJabbaGaugeBarMask
	maxValue = _maxValue
	tolerance = 0
	inverse = true
	
	//The parameters for the shader
	__shaderParams = {}
	with(__shaderParams){
		
		mask_tex = sprite_get_texture(other.mask,0)
		u_mask_tex = shader_get_sampler_index(other.shader, "mask_tex")
		u_time = shader_get_uniform(other.shader, "time")
		u_tolerance = shader_get_uniform(other.shader, "tolerance")
		u_inverse = shader_get_uniform(other.shader, "inverse")
		
	}
	
	/// @func SetValue
	/// @desc Set the value use to manipulate the gauge
	/// @param {real} value
	/// @param {boolean} triggerFeedback If the element's feedback is to be triggered when the gauge is filled (/!\ Subject to change)
	static SetValue = function(_value, _feedbackTrigger){
		
		value = _value/maxValue
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
	
	/// @func SetShaderDissolve(sprite, mask)
	/// @desc Set the shader and the two necessary sprites for the effect 
	/// @param {sprite} sprite the sprite to dissolve
	/// @param {sprite} mask the sprite used to dissolve
	static SetShaderDissolve = function ( _sprite, _mask/*, _shader = jabbaShaderDissolve*/){
		//shader = _shader
		asset = _sprite
		mask = _mask
		with(__shaderParams){
			mask_tex = sprite_get_texture(other.mask,0)
			u_mask_tex = shader_get_sampler_index(other.shader, "mask_tex")
			u_time = shader_get_uniform(other.shader, "value")
			u_tolerance = shader_get_uniform(other.shader, "tolerance")
			u_inverse = shader_get_uniform(other.shader, "inverse")
		}
	}
	
	/// @func Draw()
	/// @desc Draw the element
	static Draw = function(){
		if !isHidden{
			
			shader_set(shader)
			texture_set_stage(__shaderParams.u_mask_tex, __shaderParams.mask_tex)
			shader_set_uniform_f(__shaderParams.u_time, value)
			shader_set_uniform_f(__shaderParams.u_tolerance,tolerance)
			shader_set_uniform_f(__shaderParams.u_inverse,inverse)
			draw_sprite_ext(asset,frame,x,y,xScale,yScale,angle,color,alpha)
			shader_reset();
		
		}
	}
}

#endregion