#region HUDELEMENT - the base constructor for all elements



function __baseElement() constructor{
	
	//Public Variables
	//you can access those variables but it should be better to use the profided functions, as some manage some stuffs automatically.
	name = ""
	x = 0
	y = 0
	xx = 0
	yy = 0
	xOrigin = 0
	yOrigin = 0
	height = 0
	width = 0 
	xScale = 1
	yScale = 1
	scale = 1
	xFlip = 1
	yFlip = 1
	scale = 1
	angle = 0
	color = c_white
	alpha = 1
	frame = 0
	value = 0
	asset = undefined
	type = asset_unknown
	isHidden = false
	isReach = false
	hasFeedback = true
	//runFeedback = false
	feedback = function(){}
	
	//Private variable
	__activeFeedback = "none"
	__anyUpdated = false
	__positionUpdated = false
	__rotationUpdated = false
	__scaleUpdated = false
	__radiusUpdated = false
	__originUpdated = false
	__alphaUpdated = false
	__feedbackUpdated = false
	
	var _self = self
	
	//A list of global built-in feedback.
	//Each element can also have their own feedbacks
	__feedbacks = {
		
		owner : _self,

		none : {
			func : method(other, function(){}),
			init : method(other, function(){}),
		},
		
		highlight : {
			runFeedback : false,
			//colorActive : colorBlendActive,
			//colorInactive : colorBlendDefault,
			value : false,
			
			init : function(){
				runFeedback = true
				getCarrousselVar()
			},
			
			func : function(){
				if runFeedback{
					//var _previous = activeItem
					//_previous[$ "item"].SetColor(colorBlendDefault)
					//itemsList[value][$ "item"].SetColor(colorBlendActive)
				
					runFeedback = false
				}
			},
			callbackInternalUpdate : method(self, function(_a,_b){
				
			}),
			getCarrousselVar : method(self, function(){})
			
		},
		
		//inflate shortly the element
		popout : {
			scale : 1,
			time : 0,
			
			init : function(){
				time = 0
				//scale = 2//["scale", 2]
			},
			func : function(){
				time += 0.1
				scale = tween(2,1, time, EASE.INOUT_CUBIC)
				callbackInternalUpdate(scale, scale)
					
			},
			
			callbackInternalUpdate : method(self, function(_a,_b){
				SetScale(_a,_b)
			})
		},
		fliponce : {
			animate : 0,
			time : 0,
			runFeedback : false,
			xScale : xScale,
			maxScale: xScale,
			
			init : function(){
				self.runFeedback = true
				self.animate = 0
				self.time = 0
			},
			flipMe : method(self, function(_arg){
				SetScale(_arg,1)
			}),
			func : function(){
			
				if runFeedback{
					time += 0.1
					switch(animate){
						case 0: 
							xScale = tween(maxScale,0, time, EASE.OUT_CUBIC)
							if xScale <= 0 {animate = 1; time = 0;}
						break;
						case 1: 
							xScale = tween(0,maxScale, time, EASE.OUT_CUBIC);
							if xScale >= 1 {runFeedback = false;}
						break;
					}
					flipMe(xScale);
				}
			}
	
		}
	}
	
	//Internal tween functions shamelessly taken from Simon Milfred's (awesome) Bless Hay Gaming Utils pack (https://blesshaygaming.itch.io/bhg-utils). seriously, check it out.
	__tweenFunctions = {
		Tween_LerpTime : method(other,function(_originalValue, _targetValue, _lerpAmount, _timeFactor) {
	
			var _val = lerp( _originalValue, _targetValue, 1 - power( 1 -_lerpAmount, _timeFactor));
			return _val;
	
		}),
	}
	
	//internal - this will set the variable stored in a feedback struct ("params" member)
	static __feedbackGetParams = function(){
		
		var _params = __feedbacks[$ __activeFeedback]
		_params.init()
		
	}
	
	static __update = function(){
		if (__feedbackUpdated){
			__feedbackGetParams();
			
			__feedbackUpdated = false;
		}
		
		if (__originUpdated){
			var _xo = 0, _yo = 0
			if asset_get_type(asset) = asset_sprite{
				_xo = sprite_get_xoffset(asset)
				_yo = sprite_get_yoffset(asset)
			}
			else if asset_get_type(asset) = asset_font{
				switch(halign){
					case fa_left : _xo = 0; break;
					case fa_center : _xo = (width/2); break;
					case fa_right : _xo = width; break;
				}
				switch(valign){
					case fa_top : _yo = 0; break;
					case fa_middle : _yo = (height/2); break;
					case fa_bottom : _yo = height; break;
				}
			}
			if type = asset_sprite{
				_xo = sprite_get_xoffset(asset)
				_yo = sprite_get_yoffset(asset)
			}
			else if type = asset_font{
				switch(halign){
					case fa_left : _xo = 0; break;
					case fa_center : _xo = (width/2); break;
					case fa_right : _xo = width; break;
				}
				switch(valign){
					case fa_top : _yo = 0; break;
					case fa_middle : _yo = (height/2); break;
					case fa_bottom : _yo = height; break;
				}
			}
			xOrigin = -_xo + xOrigin;
			yOrigin = -_yo + yOrigin;
			
			__originUpdated = false;
		}
		if (__positionUpdated){
			xx = x - xOrigin//xx
			yy = y - yOrigin//yy
			x = xx
			y = yy
			
			__positionUpdated = false;
		}
		if (__rotationUpdated){
			
			var _c = dcos(angle);
			var _s = dsin(angle);
			x = xx - _c * xOrigin - _s * yOrigin
			y = yy - _c * yOrigin + _s * xOrigin
			
			__rotationUpdated = false;
		}
		if (__scaleUpdated){
			
			xScale = xScale * xFlip;
			yScale = yScale * yFlip;
			
			__scaleUpdated = false;
		}
		if (__radiusUpdated){
			wRadius = wRadius
			hRadius = hRadius
			
			__radiusUpdated = false
			
		}
		if (__alphaUpdated){
			
			__alphaUpdated = false;
		}
		
		__anyUpdated = false;
	}
	
	//Public functions
	/// @func SetValue
	/// @desc set the value to read from
	/// @params {relative to element} value the value to read
	/// @params {bool} play the element feedback (default : true)
	static SetValue = function(_value, _triggerFeedback = true){
		value = _value
		hasFeedback = _triggerFeedback
		if hasFeedback{
			__feedbackUpdated = true
			__anyUpdated = true
			//__feedbackGetParams()
		}
	}
	
	/// @func SetPosition
	/// @desc set the position.
	/// @params {real} x
	/// @params {real} y
	/// [NOTE] Could set a way to choose between SET and ADD ?
	static SetOrigin = function(_xOrigin, _yOrigin = undefined){
		
		if is_array(_xOrigin){
			_yOrigin = _xOrigin[0] * height
			_xOrigin = _xOrigin[1] * width
		}
		xOrigin = _xOrigin
		yOrigin = _yOrigin
		
		__originUpdated = true
		__anyUpdated = true;
		
		return self
	
	}
	
	static SetPosition = function(_x, _y){
		x = _x
		y = _y
		__positionUpdated = true
		__anyUpdated = true
		
		return self
	}
	
	static SetRotation = function(_angle){
		angle = _angle
		__rotationUpdated = true
		__anyUpdated = true
		
		return self
	
	}
	//static SetPosition = function(_x, _y){
	
	//    x = _x;
	//    y = _y;
	//    
	//    return self
	//}
	
	/// @func SetScale(xScale, yScale)
	/// @desc Set the scale of the element. You can omit the second parameter if you want yScale to be the same as xScale. Take the flipping value in account.
	/// @param {real} xScale or Scale
	///	@param {real} yScale If omitted, it will get the same value as xScale
	static SetScale = function(_xScale, _yScale = undefined){
		
		if is_undefined(_yScale){
			_yScale = _xScale;
		}
		
		xScale = _xScale
		yScale = _yScale
		__scaleUpdated = true;
		__anyUpdated = true;
		return self
		
	}
	
	/// @func SetScaleX(xScale)
	/// @desc set the size on the x axis, taking in account the flipping value
	/// @param {real} xScale
	static SetScaleX = function(_xScale){
		
		xScale = _xScale;
		
		//xScale = xScale * xFlip
		__scaleUpdated = true;
		__anyUpdated = true;
		
		return self
		
	}
	
	/// @func SetScaleY(yScale)
	/// @desc set the size on the y axis, taking in account the flipping value
	/// @param {real} yScale
	static SetScaleY = function(_yScale){
	
		yScale = _yScale
	
		//yScale = yScale * yFlip
		__scaleUpdated = true;
		__anyUpdated = true;
		
		return self
	
	}
	
	/// @func SetFlip(xFlip, yFlip)
	/// @desc Flip the element. You can omit the second parameter if you want yFlip to be the same as xFlip
	/// @param {integrer} xFlip or global Flip
	///	@param {integrer} yFlip If omitted, it will get the same value as xFlip
	static SetFlip = function(_xFlip, _yFlip = undefined){
		
		if is_undefined(_yFlip){
			_yFlip = _xFlip;
		}
		
		xFlip = _xFlip;
		yFlip = _yFlip;
		
		__scaleUpdated = true;
		__anyUpdated = true;
		//xScale = xScale*_xFlip
		//yScale = yScale*_yFlip
		
		return self
		
	}
	
	/// @func ToggleFlipX()
	/// @desc flip the element on the x axis. xScale variable will be updated as well.
	static ToggleFlipX = function(){
		xFlip = sign(xScale * -1)
		
		__scaleUpdated = true
		__anyUpdated = true
		//xScale = xScale * xFlip
		
		return self
		
	}
	
	/// @func ToggleFlipY()
	/// @desc flip the element on the x axis. yScale variable will be updated as well.
	static ToggleFlipY = function(){
		yFlip = sign(yScale * -1)
		
		__scaleUpdated = true
		__anyUpdated = true
		//yScale = yScale * yFlip
		return self
	}
	
	/// @func SetAlpha(alpha)
	/// @desc Set the transparency
	/// @param {real} alpha
	static SetAlpha = function(_alpha){
		
		alpha = _alpha
		
		return self
		
	}
	
	/// @func SetColor(color)
	/// @desc Set the color
	/// @param {integrer} color
	static SetColor = function(_color){
		
		color = _color
		
		return self
		
	}
	
	/// @func ToggleHide
	/// @desc toggle the element's isHidden variable to bypass drawing
	static ToggleHide = function(){
		
		isHidden = !isHidden
		
		return self
	}
	
	/// @func Hide(bool)
	/// @desc Hide or show the element
	/// @param {bool} bool
	static Hide = function(_bool){
		isHidden = _bool
		
		return self
	}
	
	static Update = function(){
		if (hasFeedback){
			feedback();
		}
		
		if (__anyUpdated){
			__update();
		}
		
	}
	
	/// @func SetFeedback(feedback)
	/// @desc set the feedback that will be played when the value changes
	/// @params {string} feedback name of the feedback as a steing (default : popout)
	static SetFeedback = function(_effect){
		var _feedback = variable_struct_get(__feedbacks, _effect)
		feedback = _feedback.func
		__activeFeedback = _effect
		
		return self
		
	}
	
/*** BROKEN ***/
	/// @func AddFeedback
	/// @desc Add a User-Defined feedback 
	/// @param {string} name The name of the custom feedback
	/// @param {function} function The feedback behavior
	/// @param {function} init An array of parameters as follow : ["variable 1", value 1, "variable 2", value 2, ...]
	//static AddFeedback = function(_name, _function, _init){
	//	var _struct = {}
	//	with(_struct){
	//		func = method(other,_function)
	//		init = method(other, _init)
	//	}
	//	
	//	variable_struct_set(__feedbacks, _name, _struct)
	//	
	//	return self
	//}
}
#endregion

#region FONT TYPE SUB-ELEMENT
function __fontTypeElement__() : __baseElement() constructor{
	type = asset_font
}
#endregion

#region SPRITE TYPE SUB-ELEMENT
function __spriteTypeElement__() : __baseElement() constructor{
	type = asset_sprite
}

#endregion

#region MISC FUNCTIONS

/// @func ArraySum
/// @desc add all value of an array.
function ArraySum(_array){
    var _i, _sum = 0, _l = array_length(_array),
    
    _i = 0; repeat(_l){
        if (is_real(_array[_i])){
        _sum += _array[_i]
        }
        else show_error("[ArraySum] the value at index "+string(_i)+" in Array "+string(_array)+ " is not a NUMERIC value", true)
        
        _i++
    }
    return _sum
}

///@func SplitPowerOfTenToArray
///@desc Return an array populated by the Units of a value (Ones, Tens, Hundreds, etc) for each index
///@param {int} Value
///@param {int} [DigitNumber] //The number of Unit type to go to eg(1=1, 2=10, 3=100, etc) - default = value length (0)
///@returns {array}
function SplitPowerOfTenToArray(_value, _arraySize = 0){
        	
	var _i, _a = [], _div, _sum
	
	if _arraySize <=0 {
		_arraySize = CountDigit(_value)
	}
	var _i=0; repeat(_arraySize){
		
		_sum = ArraySum(_a);
		_div = power(10, _arraySize-_i-1)
	    _a[_i] = ((_value - _sum) div _div) * _div;
		
		//_div = _div / 10
		_i++
	}
	return _a
}

/// @func SplitByDigitsToArray
/// @desc Put each digit of the value in an array
function SplitByDigitsToArray(_value, _arraySize = 0){
   	var _a = []
	if _arraySize <= 0{
		//we count the number of digit
		_arraySize = CountDigit(_value)
	}
	
	repeat(_arraySize){
		
		_value = _value / 10
		_a[_arraySize-1] = floor(frac(_value) * 10)
		_arraySize--
	}
	return _a	
}

/// @func StripPowerOfTensToArray
/// @desc Remove each Tens of a value and store the each remaining in an array
function StripPowerOfTensToArray(_value){
   	var _l, _a 
   	_l = CountDigit(_value)
	
	repeat(_l){
   		
   		_value = _value / 10
   		_a[_l-1] = floor(_value)
		_l--
   	}
	return _a
}

function CountDigit (_value){
	var _n = 0
	while(floor(_value) > 0){
		_value = _value / 10
		_n++
	}
	
	return _n = 0 ? 1 : _n
}
#endregion

function value_wrap_selector(_current, _delta, _list) {
	
	var _size = array_length(_list)
	var _i = 0; repeat(_size){
		if _list[_i] = _current break
		_i++
	}
	//if _i < 0 return undefined
	_i = (((_i + _delta) mod _size) + _size) mod _size;
	var _result = _list[_i]
	return _result

}

/// @func Wave(_from, _to, _duration, _offset)
/// @desc Returns a value that will wave back and forth between [from-to] over [duration] seconds
/// @param from
/// @param to
/// @param duration - in seconde
/// @param offset
 
//Code by Shaun Spalding - ported for GMS2.3+ by me.
// 
// Examples
//      image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
//      x = Wave(-10,10,0.25,0)         -> move left and right quickly
 
// Or here is a fun one! Make an object be all squishy!! ^u^
//      image_xscale = Wave(0.5, 2.0, 1.0, 0.0)
//      image_yscale = Wave(2.0, 0.5, 1.0, 0.0)
function Wave(_from, _to, _duration, _offset){
	var a4 = (_to - _from) * 0.5;
	return _from + a4 + sin((((current_time * 0.001) + _duration * _offset) / _duration) * (pi*2)) * a4;
}

/// @function			number_wrap(value, min, max, [include_max?]);
/// @description		Wraps a value to stay between the set min and max.
/// @argument			{real} value The value to wrap.
/// @argument			{real} min The lower value to wrap around.
/// @argument			{real} max The higher value to wrap around.
/// @argument			{boolean} [include_max?=true] Whether to allow the value to be equal to max (true) or not (false).
/// @returns			{real} The wrapped value.
function number_wrap(_value, _min, _max) {
	var __min = min(_min, _max);
	_max = max(_min, _max);
	_min = __min;

	if (_min == _max) {
		return _min;
	}

	var _diff = (_max - _min);
	if (argument_count == 3 || argument[3]) {
		while (_value > _max || _value < _min) {
			if (_value > _max) {
				_value -= _diff + 1;
			} else if (_value < _min) {
				_value += _diff + 1;
			}
		}
	} else {
		while (_value >= _max || _value < _min) {
			if (_value >= _max) {
				_value -= _diff;
			} else if (_value < _min) {
				_value += _diff;
			}
		}
	}
	return _value;
}

function shader_remap_uv_scale(_sprite, _mask){
	
	//variables
	var _sprite_uvs		= sprite_get_uvs(_sprite, 0)
	var _sprite_uv_w	= _sprite_uvs[2] - _sprite_uvs[0]
	var _sprite_uv_h 	= _sprite_uvs[3] - _sprite_uvs[1]
	var _sprite_aspect	= sprite_get_width(_sprite) / sprite_get_height(_sprite)
	
	var _mask_uvs		= sprite_get_uvs(_mask, 0)
	var _mask_uv_w		= _mask_uvs[2] - _mask_uvs[0]
	var _mask_uv_h 		= _mask_uvs[3] - _mask_uvs[1]
	var _mask_aspect		= sprite_get_width(_mask) / sprite_get_height(_mask)

	//Calculate
	var _scale_x		= _mask_uv_w / _sprite_uv_w
	var _scale_y		= _mask_uv_h / _sprite_uv_h
	if (_sprite_aspect > _mask_aspect) {
		_scale_y		/= _sprite_aspect / _mask_aspect
		var _shift_x	= _mask_uvs[0] - _sprite_uvs[0] * _scale_x
		var _shift_y	= _mask_uvs[1] - _sprite_uvs[1] * _scale_y
		_shift_y		+= 0.5 * (_mask_uv_h - _sprite_uv_h * _scale_y)
	}
	else {
		_scale_x		*= _sprite_aspect / _mask_aspect
		var _shift_x	= _mask_uvs[0] - _sprite_uvs[0] * _scale_x
		var _shift_y	= _mask_uvs[1] - _sprite_uvs[1] * _scale_y
		_shift_x		+= 0.5 * (_mask_uv_w - _sprite_uv_w * _scale_x)
	}
	
	return [_scale_x, _scale_y, _shift_x, _shift_y]
}

function ceil_ext(_value, _size){
	_size = 1-_size
	return ceil(_value/_size) * _size
}

function round_ext(_value, _size){
	return round(_value/_size) * _size
}

function floor_ext(_value, _size){
	_size = 1-_size
	return floor(_value/_size) * _size
}