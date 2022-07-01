
/// @func __baseElement
/// @desc [Internal] The Base Constructor for all Jabba Element
function __baseElement() constructor{
	
#region /***************************** Public Common Variables  *********************************/
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
	defaultColor = undefined
	alpha = 1
	frame = 0
	value = 0
	
	mode = undefined
	asset = undefined //The main asset (Font or Sprite)
	assetType = asset_unknown //The type of asset (automatically set in __fontTypeElement__() constructor)
	elementType = ELEMENT.BASE
	isHidden = false //
	isReach = false // The moment it is set to true depends of the Element
	feedbackIsEnabled = true
	
#endregion /*********************************************************************************/	
	
#region /***************************** Private Common Variables *********************************/
	__activeFeedback = "none"
	__anyUpdated = false
	__positionUpdated = false
	__rotationUpdated = false
	__scaleUpdated = false
	__radiusUpdated = false
	__originUpdated = false
	__alphaUpdated = false
	
	feedback = new __feedbackPlayer(elementType)
	bib = new Bib() ;
	
	
	
	static __addToHud = function(_hud){
		var _h = variable_instance_get(other, _hud)
		array_push(_h.elementsList, self)
		_h.elementsListSize++
	}
	
	var _self = self

#endregion

#region /*****************************  Private Common Methods  *********************************/
	
	/// @func __update
	/// @desc Internal update method. Trigger update for Feedback, Origin, Position, Rotation, Scale, Alpha and Radius (for the Caroussel)
	static __update = function(){
		
		if (__originUpdated){
			var _xo = 0, _yo = 0
			if assetType = asset_sprite{
				_xo = sprite_get_xoffset(asset)
				_yo = sprite_get_yoffset(asset)
			}
			else if assetType = asset_font{
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
			
			//To redo Later
			//var _a = point_direction(_xo,_yo,xOrigin,yOrigin)
			//xOrigin = _xo + cos(_a) * xOrigin + cos(_a + pi / 2) * yOrigin
			//yOrigin = _yo + sin(_a) * xOrigin + sin(_a + pi / 2) * yOrigin
			
			__originUpdated = false;
		}
		if (__positionUpdated){
			xx = x - xOrigin
			yy = y - yOrigin
			x = xx
			y = yy
			
			//To redo Later
			// var _a = point_direction(x,y,xOrigin,yOrigin)
			// xx = x + cos(_a) * xOrigin + cos(_a + pi / 2) * yOrigin
			// yy = y + sin(_a) * xOrigin + sin(_a + pi / 2) * yOrigin
			
			__positionUpdated = false;
		}
		if (__rotationUpdated){
			
			var _c = dcos(angle);
			var _s = dsin(angle);
			x = xx - _c * xOrigin - _s * yOrigin
			y = yy - _c * yOrigin + _s * xOrigin
			//x = xx + _c * xOrigin - _s * yOrigin
			//y = yy + _s * xOrigin + _c * yOrigin
			
			//To redo Later
			//x = xx + dcos(angle) * xOrigin + dcos(angle + pi / 2) * yOrigin
			//y = yy + dsin(angle) * xOrigin + dsin(angle + pi / 2) * yOrigin
			
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
	
	/// @func __isReach()
	/// @desc Internal method to determine if the value has reach the limit
	/// @param {int} direction 0 = downward : the limit is lower than the value. 1 = upward : The limit is higher than the value
	static __isReach = function(_mode = 1){
			switch _mode{
				case 0 : return value <= limit
				break
				case 1 : return  value >= limit
				break
				default : show_debug_message("isReach() direction is not defined")
				break
			}
	}
	
	static __feedbackPlayOnReach = function(_mode = 1){
		if !isReach{
			if __isReach(_mode){
				isReach = true
				with(feedback){
					if !run run = true
				}
			}
		}else{
			if !__isReach(_mode) isReach = false
		}
	}
	static __feedbackPlayOnValue = function(){
		with(feedback){
			if run {
				__reset()
			}
			else run = true
		}
	}
	
#endregion


#region /*****************************  Public Common Methods   *********************************/	
	
	/// @func SetValue
	/// @desc set the value to display by the Element
	/// @params {} value the value to read
	/// @params {bool} play the element feedback (default : true)
	static SetValue = function(_value, _autofeedback = true){
		value = _value
		
		if _autofeedback{
			if feedbackIsEnabled{
				__feedbackPlayOnValue()
			}
		}
		
		return self
	}
	
	/// @func FeedbackPlay
	/// @desc [On Value] Play the feedback assign to the Element when the value change.
	static FeedbackPlay = function(){
		if feedbackIsEnabled{
			__feedbackPlayOnValue()
		}
	}
	
	/// @func SetOrigin
	/// @desc set the Origin. It is a CUSTOM origin as it won't change the xoffset and yoffset variables set for a sprite in the IDE.
	/// @desc You can use the macro provided in Jabba_Config for the First Parameter if you want a quick setup.
	/// @desc If you don't call that method, the Custom Origin is set from the Asset x/y offset set in the IDE by default.
	/// @params {real or macro} x The x Origin for the Element's Asset or one of the macro in Jabba_Config
	/// @params {real} y The y Origin for the Element's asset [Optional - default: auto]
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
	
	/// @func SetPosition
	/// @desc Set the Element's Position
	/// @param {real} x
	/// @param {real} y
	/// @param {bool} relative Similar to the "relative" checkbox in GML Visual (jump_to_point)
	static SetPosition = function(_x, _y, _relative = false){
		
		__positionUpdated = true
		__anyUpdated = true
		
		if _relative{
			x += _x
			y += _y
			return self
		}
		
		x = _x
		y = _y
		//SetBibPosition(_x,_y)
		
		return self
	}
	
	/// @func SetRotation
	/// @desc Set the angle for the Element. It's based on the Custom Origin
	/// @param {real} angle
	static SetRotation = function(_angle){
		angle = _angle
		__rotationUpdated = true
		__anyUpdated = true
		
		return self
	
	}
	
	/// @func SetScale
	/// @desc Set the scale of the element. You can omit the second parameter if you want yScale to be the same as xScale. Take the flipping value in account.
	/// @param {real} xScale or Scale 
	///	@param {real} yScale [Optional] If omitted, it will get the same value as xScale
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
	
	/// @func SetScaleX
	/// @desc Scale on the X Axis
	/// @param {real} xScale
	static SetScaleX = function(_xScale){
		
		xScale = _xScale;
		
		__scaleUpdated = true;
		__anyUpdated = true;
		
		return self
		
	}
	
	/// @func SetScaleY
	/// @desc Scale on the Y Axis
	/// @param {real} yScale
	static SetScaleY = function(_yScale){
	
		yScale = _yScale
	
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
		
		return self
		
	}
	
	/// @func ToggleFlipX
	/// @desc flip the element on the x axis. xScale variable will be updated as well.
	static ToggleFlipX = function(){
		xFlip = sign(xScale * -1)
		
		__scaleUpdated = true
		__anyUpdated = true
		//xScale = xScale * xFlip
		
		return self
		
	}
	
	/// @func ToggleFlipY()
	/// @desc flip the element on the y axis. yScale variable will be updated as well.
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
	
	/// @func SetDefaultColor(color)
	/// @desc Set the default color. Set it when you use feedbacks ou want to temporarly change the element's color. To change the color, use the ChangeColor() method
	/// @param {integrer} color
	static SetDefaultColor = function(_color){
		if defaultColor = undefined{
			color = _color
		}
		
		defaultColor = _color
		
		return self
		
	}
	
	/// @func ChangeColor
	/// @desc change the active color. Use this to change the color of the element.
	/// @param {constant} color
	static ChangeColor = function(_color = undefined){
		
		if is_undefined(_color){
			color = defaultColor
			return self
		}
		
		if is_undefined(defaultColor){
			show_debug_message("[JABBA WARNING] DefaultColor has been SET with ColorChange() for Element "+name+" (Please use SetDefaultColor to SET the defaultColor)")
			defaultColor = color
		}
		
		color = _color
		
		return self
	}
	
	/// @func ToggleHide
	/// @desc toggle the visibility of the element's. The Element won't be drawn, even if its Alpha value is set to 1.
	static ToggleHide = function(){
		
		isHidden = !isHidden
		
		return self
	}
	
	/// @func Hide
	/// @desc Hide or show the element
	/// @param {bool} bool
	static Hide = function(_bool){
		isHidden = _bool
		
		return self
	}
	
	/// @func SetFeedback
	/// @desc set the feedback that will be played when the displayed value changes.
	/// @params {string} feedback name of the feedback as a string (default : popout)
	static SetFeedback = function(_name){
		feedback.Set(_name)
		
		return self
	}
	
	/// @func SetBibPosition
	/// @desc Set the Bib's Position relative to the Element Position [Default : 0 (Element Position)]
	/// @param {real} x position relative to Element x [Default : 0]
	/// @param {real} y position relative to Element y [Default : 0]
	static SetBibPosition = function(_x = 0, _y = 0){
		bib.x = x + _x
		bib.y = y + _y
		
		return self
	}
	
	
	/// @func Update
	/// @desc [Standalone Only] Must be called in the End Step Event if you use this Element as a standalone or outside a JabbaContainer.
	static Update = function(){
		if (feedbackIsEnabled){
			feedback.__play();
		}
		
		if (__anyUpdated){
			__update();
		}
		
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Update()
			}
		}
		
	
		
	}
	
	//For now, only used with BibFortuna
	//Will use it when I'll need to clean the element
	
	/// @func CleanUp
	/// @desc [Standalone & Bib Fortuna] You must called this method if you use Bib Fortuna and use this Element as a Standalone or outside a Jabba COntainer.
	/// @desc Recommand to put it in the Begin Step Event or after drawing ended.
	/// @param {type} variable
	static CleanUp = function(){
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				CleanUp()
			}
		}
	}
	
}
#endregion



#region FONT TYPE SUB-ELEMENT

// Set additional variable and value for Font Type Element (Counter, Timer and Quota)
function __fontTypeElement__() : __baseElement() constructor{
	assetType = asset_font
	
	static SetFont = function(_asset){
		asset = _asset
		
		return self
	}
}
#endregion

#region SPRITE TYPE SUB-ELEMENT
// Set additional variable and value for Sprite Type Element (Gauge, Graphic and QuotaExt)
function __spriteTypeElement__() : __baseElement() constructor{
	assetType = asset_sprite
}

#endregion

#region MISC FUNCTIONS
//Those functions can be used for yourself but should NEVER be removed (or it explode a second time)

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

function is_int(_value){
	return floor(_value) = _value ? true : false
}


#endregion
