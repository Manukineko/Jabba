#macro defaultName "element "+ string(elementsListSize)

#region JABBA CONTAINER
/// @func Jabba
/// @desc Constructor for the HUD container. This is completly optional if you want to manage yours youself
/// @params {Int} viewport the viewport to assign the HUD to (in case of splitscreen) - Dafault: viewport[0]
/// [TODO] anchor system as well as custom attach points
/// [TODO] Groups. Abilities to group elements together so they can be manipulate together (position, rotation, etc)
function JabbaContainer(_viewport = 0) constructor {
	
	x = x
	y = y
	
	// Array holding all the Elements
	elementsList = [];
	elementsListSize = 0
	isHidden = false
	
	width = view_get_wport(_viewport)
	height = view_get_hport(_viewport)
	x = view_get_xport(_viewport)
	
	
	y = view_get_yport(_viewport)
	
	margin = {}
	with(margin){
		top = 0
		left = 0
		bottom = 0
		right = 0
	}
	
	top = view_get_yport(_viewport)
	left = view_get_xport(_viewport)
	middle = top + height/2
	center = left + width/2
	bottom = top + height
	right = left + width
	//
	var _owner = other;
	__theHud = {};
	with (__theHud){
		owner = _owner;
		viewport = _viewport
	
		// Internal fuction to add an element in Jabba's elements list
		__addElement = method(other, function(_element){
			var _list = elementsList
			
			with (__theHud){
				array_push(_list, _element)
				other.elementsListSize = array_length(_list)
				return _element
			}
		})
		
		//MAYBE LATER if perf are shiesse
		//__buildDrawList = method(other, function(){
		//	var _list = elementList
		//	with(__theHud){
		//		var _i = 0; repeat(array_length(_list)){
		//			if _list[_i].isHidden = false
		//		}
		//	}
		//})
		//
	}
	/// @func CreateCounterElement()
	/// @desc create a Count element constructor and store it in the HUD
	static CreateCounterElement = function(_name = defaultName){
		var _element = new JabbaCounterElement(_name)

		with(__theHud){
			__addElement(_element)
		}
		return _element
		//
	}
	
	/// @func CreateQuotaCounterElement()
	/// @desc create a Quota Element constructor and store it in the HUD	
	static CreateQuotaCounterElement = function(_name = defaultName){
		var _element = new JabbaQuotaCounterElement(_name)

		with(__theHud){
			__addElement(_element)
		}
		return _element
		//
	}
	
	/// @func CreateQuotaCounterExtElement()
	/// @desc create an Extended Quota Element constructor and store it in the HUD	
	static CreateQuotaCounterExtElement = function(){
		var _element = new JabbaQuotaCounterExtElement()

		with(__theHud){
			__addElement(_element)
		}
		return _element
		//
	}
	
	/// @func CreateTimerElement()
	/// @desc create a Timer element constructor and store it in the HUD	
	static CreateTimerElement = function(){
		var _element = new JabbaTimerElement()
		with(__theHud){
			__addElement(_element)
		}
		return _element
	}
	/// @func CreateGaugeBarElement(maxValue)
	/// @desc create a Timer element constructor
	/// @param {real} maxValue the maximum value (In order to calculate the bar progression)
	static CreateGaugeBarElement = function(_maxValue){
		var _element = new JabbaGaugeBarElement(_maxValue)
		with(__theHud){
			__addElement(_element)
		}
		return _element
	}
	
	/// @func CreateCarrouselElement()
	/// @desc create an empty Caroussel Element constructor
	/// @param {real} maxValue the maximum value (In order to calculate the bar progression)
	static CreateCarrouselElement = function(){
		var _element = new JabbaCarousselElement()
		with(__theHud){
			__addElement(_element)
		}
		return _element
	}
	
	/// @func SetMargin
	/// @desc Set a margin for the whole HUD
	/// @param {integrer} Top
	/// @param {integrer} Left
	/// @param {integrer} Bottom
	/// @param {integrer} Right
	static SetMargin = function(_top, _left = undefined, _bottom = undefined, _right = undefined){
		if is_undefined(_left){
			
				_right = _left
				_bottom = _top
			
		}
		if is_undefined(_bottom){
			
				_right = _top
				_bottom = _top
				_left = _left
			
		}
		
		with(margin){
			top = _top
			left = _left
			bottom = _bottom
			right = _right
		}
		
		__setAnchor()
		
		return self
		
	}
	
	__setAnchor = function(){
	
		top 	=	view_get_yport(_viewport) + margin.top
		left	=	view_get_xport(_viewport) + margin.left
		middle	=	top + height/2
		center	=	left + width/2
		bottom	=	top + height - margin.bottom
		right	=	left + width - margin.right
		
	}
	
	/// @func AddAnchor
	/// @desc It will add points the user can reference to position the element 
	static AddAnchor = function(){}
	
	/// @func ToggleHide()
	/// @desc toggle the element's isHidden variable to bypass drawing
	static ToggleHide = function(){
		
		isHidden = !isHidden
	}
	
	/// @func Hide()
	/// @desc Hide or Unhide the whole HUD
	/// @param {bool} boolean
	static Hide = function(_bool){
		isHidden = _bool
	}
	
	/// @func Draw()
	/// @desc Draw all the elements if their internal isHidden variable is true
	static Draw = function(){
		if !isHidden{
			var _i=0;repeat(array_length(elementsList)){
				elementsList[_i].Draw()
				_i++
			}
		}
	}

	/// @func FeedbackPlayer()
	/// @desc it will play whatever automatic feedback setup in an element - MUST BE executed each frame if you want Jabba to manage this feature for you.
	static FeedbackPlayer = function(){
		var _i=0;repeat(array_length(elementsList)){
			elementsList[_i].feedback()
			_i++
		}
	}
	
	
}
#endregion

#region HUDELEMENT - the base constructor for all elements

function __hudelement__() constructor{
	
	//Public Variables
	//you can access those variables but it should be better to use the profided functions, as some manage some stuffs automatically.
	name = ""
	x = 0
	y = 0
	xScale = 1
	yScale = 1
	scale = 1
	angle = 0
	color = c_white
	alpha = 1
	frame = 0
	value = 0
	isHidden = false
	isReach = false
	hasFeedback = true
	runFeedback = true
	feedback = function(){}
	
	//Private variable
	__activeFeedback = "none"
	
	//A list of global built-in feedback.
	//Each element can also have their own feedbacks
	__feedbacks = {}
	with(__feedbacks){

		none = {
			func : method(other, function(){}),
			params : []
		}
		
		//inflate shortly the element
		popout = {
			func : method(other, function(){
				if hasFeedback{	
					scale = scale > 1 ? __tweenFunctions.Tween_LerpTime(scale, 1, 0.1, 1) : 1
					xScale = scale; yScale = scale
				}
			}),
			params : ["scale", 2]
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
	__feedbackGetParams = function(){
		
		var _params = __feedbacks[$ __activeFeedback][$ "params"]
		var _i=0; repeat(array_length(_params)/2){
			variable_struct_set(self, _params[_i], _params[_i+1])
			_i += 2
		}
		
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
			__feedbackGetParams()
		}
	}
	
	/// @func SetPosition
	/// @desc set the position.
	/// @params {integrer} x
	/// @params {integrer} y
	/// [NOTE] Could set a way to choose between SET and ADD ?
	static SetPosition = function(_x, _y){

	    x = _x;
	    y = _y;
	    
	    return self
	}
	
	/// @func SetScale(xScale, yScale)
	/// @desc Set the scale of the element. You can omit the second parameter if you want yScale to be the same as xScale
	/// @param {integrer} xScale or Scale
	///	@param {integrer} yScale If omitted, it will get the same value as xScale
	static SetScale = function(_xScale, _yScale = undefined){
		
		if is_undefined(_yScale){
			_yScale = _xScale
		}
		
		xScale = _xScale
		yScale = _yScale
		
		return self
		
	}
	
	/// @func SetAlpha(alpha)
	/// @desc Set the transparency
	/// @param {integrer} alpha
	static SetAlpha = function(_alpha){
		
		alpha = _alpha
		
		return self
		
	}
	
	/// @func ToggleHide
	/// @desc toggle the element's isHidden variable to bypass drawing
	static ToggleHide = function(){
		
		isHidden = !isHidden
	}
	
	static Hide = function(_bool){
		isHidden = _bool
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
	
	/// @func AddFeedback
	/// @desc Add a User-Defined feedback 
	/// @param {string} name The name of the custom feedback
	/// @param {function} function The feedback behavior
	/// @param {array} params An array of parameters as follow : ["variable 1", value 1, "variable 2", value 2, ...]
	static AddFeedback = function(_name, _function, _params){
		var _struct = {}
		with(_struct){
			func = method(other,_function)
			params = _params
		}
		
		variable_struct_set(__feedbacks, _name, _struct)
		
		return self
	}
}

#endregion
// A simple element that will play a feedback when a value change. Basically, it just display a string.
#region COUNTER ELEMENT
/// @func JabbaCounter()
/// @desc a simple counter. it will display the value with a feedback when it changes.
function JabbaCounterElement(_name) : __hudelement__() constructor{
	
	name = _name
	
	feedback = __feedbacks.popout.func
	__activeFeedback = "popout"
	
	halign = fa_center
	valign = fa_middle
	
	/// @func SetTextAlign()
	/// @desc Set the alignement of the text (GML constant fa_*)
	/// @param {constant} halign
	/// @param {constant} valign
	static SetTextAlign = function(_halign, _valign){
		halign = _halign
		valign = _valign
		
		return self
	}
	
	/// @func Draw()
	/// @desc Draw the element
	static Draw = function(){
		if !isHidden{
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_transformed_color(x,y, value, xScale, yScale, angle, color, color, color, color, alpha )
			draw_set_halign(-1)
			draw_set_valign(-1)
		}
	}
}
#endregion

#region QUOTA COUNTER
// An Element that will change color when a quota is reached
function JabbaQuotaCounterElement(_name) : JabbaCounterElement() constructor{
	
	name = _name
	quota = 0
	digitsLimit = 9
	counterValueLimit = (power(10, digitsLimit)) - 1
	colorQuotaReached = c_red
	colorCounterDefault = c_white
	__activeFeedback = "popout"
	
	/// @func SetQuota(quota, counterLimit)
	/// @desc Set the quota to compare the value to.
	/// @param {real} quota
	/// @param {real} counterLimit Set the maximum unit to display. This is mandatory in order to calculate the position neatly
	static SetQuota = function(_quota = 1000, _limit = 9){
    	//counter internal unit limit (it won't count past the number of unit)
        quota = _quota;
        digitsLimit = _limit
        
        //set the value limit based on the digit limit in pure arcade fashion e.g 9999999
        var _cvl = (power(10, digitsLimit)) - 1
        counterValueLimit = _cvl
        
        return self
    }
    
    
    static SetValue = function(_value){
    	value = _value
    	
    	if value >= quota{
    		if !isReach{
    			if hasFeedback{
    				__feedbackGetParams()
    			}
    			isReach = true
    		}
    	}
    	else{
    		if (isReach) isReach = false
    	}
    	
    	color = value >= quota ? colorQuotaReached : colorCounterDefault
    	
    	return self
    }
}
#endregion
// An EXTENDED version of the Quota Counter Element that use sprite as its font. It allow to progressively change the color of each unit individually
#region QUOTA COUNTER EXT
/// @func JabbaQuotaCounterExtElement
/// @desc An extended Quota Counter using sprite as font and allowing to color each digit independently progressively as the quota is reached.
function JabbaQuotaCounterExtElement() : __hudelement__() constructor{
  
    valueLength = 0
    quota = 0
    
    digitsLimit = 9
    valueDigits = array_create(digitsLimit, 0)
    quotaDigits = array_create(digitsLimit, 0)
    
    counterValueLimit = undefined
    
	colorQuotaReached = c_red
	colorCounterDefault = c_white
	digitsColor = array_create(digitsLimit, colorCounterDefault)
	
	matchingDigit = array_create(digitsLimit,false)
	
	spriteFont = JabbaFont
	spriteFontFrame = []
	spriteFontWidth = sprite_get_width(spriteFont)
	letterSpacing = 2 
	
	feedback = __feedbacks.popout.func
	__activeFeedback = "popout"
    
    /// @func SetSpriteFont(sprite)
    /// @desc The spritesheet used for the font
    /// @params {sprite} sprite Must be a spritesheet where each digit are a frame, starting from 0 to 9 (unless you want some funny behavior)
    static SetSpriteFont = function(_sprite){
			spriteFont = _sprite
			
			spriteFontWidth = sprite_get_width(spriteFont)
			
			return self
    }
	
	/// @func SetTextColor(defaultColor, goalColor)
	/// @desc Set the regular color and the color for when the quota is reached
	/// @params {color} defaultColor
	/// @params {color} goalColor The color to change when the quota is reached
	static SetTextColor = function(_defaultColor, _goalColor ){
    	
    	colorCounterDefault = _defaultColor
    	colorQuotaReached = _goalColor
		
	}
    
    /// @func SetQuota(quota, counterLimit)
    /// @desc Set the quota value to be reached. You can set a limit to the number of digit. If the value goes above it, it will be ignored.
    /// @params {integrer} quota the quota value to reach
    /// @params {integrer} The Digit limit to display (default : 9 (100 000 000) )
    static SetQuota = function(_quota = 1000, _limit = 9){
    	//quota to reach
    	//counter internal unit limit (it won't count past the number of unit)
        quota = _quota;
        digitsLimit = _limit
        
        var _digitNumber, divLimit
        
        //trick to build the number of quota Digits dynamically
        //I count the number of characters and use that to resize the digit array
        
        
        array_resize(quotaDigits, digitsLimit)
        	//quotaDigits = array_create(digitsLimit, 0)
        
        //resize the value digits array
        array_resize(valueDigits, digitsLimit)
        	//valueDigits = array_create(digitsLimit, 0)
        
        //resize the color array
        array_resize(digitsColor, digitsLimit)
        	//digitsColor = array_create(digitsLimit, colorCounterDefault)
        
        //resize the matching digit array
        array_resize(matchingDigit, digitsLimit)
        	//matchingDigit = array_create(digitsLimit,false)
        
        //set the value limit based on the digit limit in pure arcade fashion e.g 9999999
        var _cvl = (power(10, digitsLimit)) - 1//string_repeat("9", digitsLimit)
        counterValueLimit = _cvl
        
        
        //Build the quota Array to be compared with the value
        quotaDigits = SplitPowerOfTenToArray(quota, digitsLimit)
        
        return self
        
    }
    
   /// @func SetValue(value)
   /// @desc Set the value to compare to the quota. The function will trigger a boolean and colored the text if the quota is reached.
   /// @params {integrer} value
   /// //[TODO] Add feedback system per DIGITS
    static SetValue = function(_value){
    	
    	//Clamp the value from 0 to the limit set for the counter.
    	value = clamp(_value, 0, counterValueLimit)
    	valueLength = CountDigit(value)//string_length(string(value))
    	
    	//Split the value by Units until we reach the limit and store it in an array
    	valueDigits = SplitPowerOfTenToArray(value, digitsLimit)
    	spriteFontFrame = SplitByDigitsToArray(value, digitsLimit)
    	
		if value > quota {
			var _i=0; repeat(digitsLimit){
				array_set(digitsColor, _i, colorQuotaReached)
				array_set(matchingDigit, _i, true)
				_i++
			}
			if !isReach{
    			if hasFeedback{
    				__feedbackGetParams()
    			}
    			isReach = true
    		}
		}
		else{
			var _i=0; repeat(digitsLimit){
				var _iprev = _i - 1
				if (_iprev >= 0){
					matchingDigit[_i] = (valueDigits[_i] >= quotaDigits[_i] && matchingDigit[_iprev])
					
				}
				else{
					matchingDigit[_i] = (valueDigits[_i] >= quotaDigits[_i])
				}
				
				digitsColor[_i] = matchingDigit[_i] = true ? colorQuotaReached : colorCounterDefault 
				_i++
			}
			
			if isReach isReach = false
    }
			
	}
    
    /// @func Draw()
    /// @desc Draw the element
    static Draw = method(self, function(){
       //Beware of scary out-of-bound error : DigitLimit is higher that the Indexes in those arrays, so minus ONE it needs to be. BRRR. Scary.
		if !isHidden{
        	var _i=digitsLimit-1; repeat(valueLength){
        		draw_sprite_ext(spriteFont, spriteFontFrame[_i], x+((spriteFontWidth+letterSpacing)*_i), y, xScale, yScale, 0, digitsColor[_i], 1 )
        		_i--
        	}
		}
    })
}
#endregion

#region TIMER ELEMENT
//An element that will split and display a time.
function JabbaTimerElement() : __hudelement__() constructor{
	
	//Time Unit to use to set the time format
	enum JT{
		DAYS,
		HOURS,
		MIN,
		SEC,
		HUN
	}
	
	//time = 568954
	timeLimit = 0
	timeSeparator = ":"
	
	halign = fa_center
	valign = fa_middle
	timeUnit = []
	timeDigit = [0,0,0,0,0]
	timeFormat = []
	__getFormat = undefined
	__createText = undefined
	__string = undefined
	
	//Create an array of function to convert time from
	//milliseconde to every time units
	timeUnit[JT.DAYS] = function(_time){
	  return (_time div 86400000) mod 60
	}
	timeUnit[JT.HOURS] = function(_time){
	  return (_time div 3600000) mod 60
	}
	timeUnit[JT.MIN] = function(_time){
	  return (_time div 60000) mod 60
	}
	timeUnit[JT.SEC] = function(_time){
	  return (_time div 1000) mod 60
	}
	timeUnit[JT.HUN] = function(_time){
	  return (_time div 10) mod 100
	}
	
	//This is to set the Unit we need to display.
	//The goal would be to :
	//1. build a function which'll then return itself an array populated with the
	//corresponding timeconverter function (above) to be use efficiently without the
	//need of a for loop
	//2. automatic mode, where the returned function would be store
	//internally in Jabba and then use in the update function.
	//3. custom mide, allow to build a set of different format (sot it means being able to
	//return the func to an instance variable)
	
	/// @func SetTimeFormat(array)
	/// @desc Set the time format. The order in the array is the display order
	/// @params {array} format An array of time unit to use (Use the JT enum provided above. eg : [JT.MIN, JT.SEC])
	static SetTimeFormat = function(_array){
		timeFormat = _array
		var _func
		
		switch(array_length(_array)){
			case 1 : _func = function(_time){
		    		
		    			var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						return _a
					}
			break
			case 2 : _func = function(_time){
					    
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						return _a
					}
			break;
			case 3 : _func = method(self, function(_time){
		    			
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						array_set(_a, timeFormat[2], timeUnit[timeFormat[2]](_time))
						return _a
					})
			break
			case 4 : _func = function(_time){
		    			
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						array_set(_a, timeFormat[2], timeUnit[timeFormat[2]](_time))
						array_set(_a, timeFormat[3], timeUnit[timeFormat[3]](_time))
						return _a
					}
			break
			case 5 : _func = function(_time){
		    			
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						array_set(_a, timeFormat[2], timeUnit[timeFormat[2]](_time))
						array_set(_a, timeFormat[3], timeUnit[timeFormat[3]](_time))
						array_set(_a, timeFormat[4], timeUnit[timeFormat[4]](_time))
						return _a
					}
			break
		}
		
		__getFormat = _func
		
		return self
		
	}
	
	/// @func UpdateTime(time)
	/// @desc The fonction to use to update and format the time into a string that will be display
	/// @param {integrer} Time in millisecondes
	static UpdateTime = function(_time){
		value = _time
		timeDigit = __getFormat(_time)
		var _leadingZero, _str ="", _l = array_length(timeFormat)
		var _i =0; repeat(_l){
			_leadingZero = timeDigit[timeFormat[_i]] < 10 ? "0" : ""
			_str = _str+_leadingZero
			_str = _str+string(timeDigit[timeFormat[_i]])
			if (_i = _l-1) {
				__string = _str; 
				return
			}
			_str = _str+timeSeparator
			_i++
		}
	}
	
	/// @func Draw()
	/// @desc Draw the element
	static Draw = function(){
		if !isHidden{
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_transformed_color(x,y, __string, xScale, yScale, angle, color, color, color, color, alpha )
			draw_set_halign(-1)
			draw_set_valign(-1)
		}
	}
}

#endregion

#region GAUGE ELEMENT
// An element that displa a value as a gauge bar (life bar, stamina bar, etc)

function JabbaGaugeBarElement(_maxValue) : __hudelement__() constructor{
	
	shader = jabbaShaderDissolve
	sprite = sJabbaGaugeBar
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
	/// @param {integrer} value
	/// @param {boolean} triggerFeedback If the element's feedback is to be triggered when the gauge is filled (/!\ Subject to change)
	static SetValue = function(_value, _feedbackTrigger){
		
		value = _value/maxValue
		hasFeedback = _feedbackTrigger
		
		//what a mess. Nothing make sens here.
		if hasFeedback && runFeedback{
			if value >= maxValue{
				value = maxValue
				__feedbackGetParams()
				runFeedback = false
			}
			else runFeedback = true
		}
	}
	
	/// @func SetAngle(angle)
	/// @desc Set the angle of the element
	/// @param {integrer} angle
	static SetAngle = function(_angle){
		angle = _angle
	}
	
	/// @func SetShaderDissolve(sprite, mask)
	/// @desc Set the shader and the two necessary sprites for the effect 
	/// @param {sprite} sprite the sprite to dissolve
	/// @param {sprite} mask the sprite used to dissolve
	static SetShaderDissolve = function ( _sprite, _mask/*, _shader = jabbaShaderDissolve*/){
		//shader = _shader
		sprite = _sprite
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
			draw_sprite_ext(sprite,frame,x,y,xScale,yScale,angle,color,alpha)
			shader_reset();
		
		}
	}
}

#endregion

#region CAROUSSEL ELEMENT
// An element that show and animate a caroussel composed of several item sprite (eg Command Ring in Secret of Mana)
function JabbaCarousselElement() : __hudelement__() constructor {
	
	itemsList = []
	activeItem = undefined
	carousselSize = 0
	rotation = 0
	rotationSpeed = 0.1
	wRadius = 128
	hRadius = 128
	fadeMin = .8
	scaleMin = .8
	drawOrder = []
	colorBlendDefault = c_white
	colorBlendActive = c_black
	
	//Private
	with(__feedbacks){

		highlight = {
			func : method(other, function(){
				if runFeedback{
					var _previous = activeItem
					_previous[$ "item"].SetColor(colorBlendDefault)
					itemsList[value][$ "item"].SetColor(colorBlendActive)
				
					runFeedback = false
				}
			}),
			params : ["runFeedback", true]
		}
	}
	
	show_debug_message(__feedbacks)
	
	/// @desc add an item to the caroussel in the itemlist
	__add = function(_name, _sprite, _pos){
		var _item = new JabbaGraphicElement(_sprite)
		_item.SetPosition(other.x,other.y)
		_item.SetOrigin(MiddleCenter)
		
		var _itemStruct = {
			ID : carousselSize, //NO. Just testing purpose. To do better.
			name : _name,
			item : _item
		}
		if _pos = undefined{
			array_push(itemsList,_itemStruct)
			carousselSize = array_length(itemsList)
			return
		}
		itemsList[_pos] = _itemStruct
		carousselSize = array_length(itemsList)
		
	}
	
	/// @desc calculate the position of each item in the caroussel
	__dispatch = function(){
		
		//var _previous = activeItem
		
		rotation -= angle_difference(rotation, value * (360/carousselSize)*(carousselSize - 1)) / (rotationSpeed * room_speed)
		var _prio = ds_priority_create()
		var _i = 0; repeat(carousselSize){
			ds_priority_add(_prio, itemsList[_i], lengthdir_y(hRadius/2, (rotation-90) + _i * (360/carousselSize) ))
			_i++
			
		}
		var _x,_y,_fade, _scale
		var _i = 0; repeat(carousselSize){
			drawOrder[_i] = ds_priority_delete_min(_prio)
			_x = lengthdir_x(wRadius/2, (rotation-90) + drawOrder[_i][$ "ID"] * (360/carousselSize) )
			_y = lengthdir_y(hRadius/2, (rotation-90) + drawOrder[_i][$ "ID"] * (360/carousselSize) )
			_fade = clamp(-sin(pi/180 * (rotation + ((360/carousselSize) * drawOrder[_i][$ "ID"]) -90)),fadeMin,1)
			_scale = clamp(-sin(pi/180 * (rotation + ((360/carousselSize) * drawOrder[_i][$ "ID"]) -90)), scaleMin,1)
			drawOrder[_i][$ "item"].SetPosition(x+_x,y+_y).SetAlpha(_fade).SetScale(_scale)
			_i++
			
		}
		
		activeItem = drawOrder[carousselSize-1]
		//activeItem[$ "item"].SetColor(c_blue)
		
		
		//if hasFeedback && runFeedback{
		//	var _done = floor(abs(_x))
		//	if _done < 1{
		//		activeItem[$ "item"].SetColor(c_blue)
		//		if !is_undefined(_previous) && _previous != activeItem{
		//			_previous[$ "item"].SetColor(c_white)
		//		}
		//		runFeedback = false
		//	}
		//}
		//Test in order to implement the feedback
		//var _d = point_direction(0,0,_x,_y)
		//show_debug_message(_previous)
		ds_priority_destroy(_prio)
		
	}

	//static SetValue = function(_value){
	//	value = _value
	//	
	//	if hasFeedback{
	//		
	//		__feedbackGetParams()
	//	
	//	}
	//}
	
	/// @func AddItem(name, sprite)
	/// @desc Add an Item, a sprite, to the caroussel
	/// @param {string} name the name for the item
	/// @param {sprite} sprite the sprite to use
	/// @param {real} position NOT USED (yet)
	static AddItem = function(_name, _sprite, _pos = undefined){

		__add(_name, _sprite, _pos)
		return undefined
	}
	
	/// @func SetRadius(width, height)
	/// @desc Set the radius of the caroussel. If the Height is omitted, it will be set to the Width value (caroussel would be a perfect circle)
	/// @param {integrer} radiusWidth
	/// @param {integrer} radiusHeight
	static SetRadius = function(_wRadius, _hRadius = undefined){
		
		if is_undefined(_hRadius){
			_hRadius = _wRadius
		}
		
		wRadius = _wRadius
		hRadius = _hRadius
		
		return self
		
	}
	
	/// @func SetDepth(scale)
	/// @desc The Depth is the size of the items other than the active one in order to give a sense of depth to the caroussel.
	/// @param {integrer} scale Between 0 and 1
	static SetDepth = function(_value){
		scaleMin = clamp(_value,0,1)
		
		return self
	}
	
	/// @func SetDrawDistance(alpha)
	/// @desc Act on the transparency of the items other than the active one
	/// @param {integrer} alpha Between 0 and 1
	static SetDrawDistance = function(_value){
		fadeMin = clamp(_value,0,alpha)
		
		return self
	}
	
	/// @func SetRotationSpeed(speed)
	/// @desc Set the speed of rotation of the caroussel when an item becom active
	/// @param {integrer} speed
	static SetRotationSpeed = function(_speed){
		if (_speed = 0) show_error("Caroussel speed is 0",true)
		
		rotationSpeed = abs(_speed)
		
		return self
	}
	
	/// @func Update()
	/// @desc This function must be executed each frame if you use this Element (I plan to implement it better later)
	static Update = function(){

		__dispatch()

	}
	
	/// @func Draw()
	/// @desc Draw the caroussel
	static Draw = function(){
		if !isHidden {
			var _i=0;repeat(array_length(itemsList)){
				if drawOrder[_i] != 0 drawOrder[_i][$ "item"].Draw()
				_i++
			}
		}
	}
}

#endregion

#region SPRITE ELEMENT

function JabbaGraphicElement(_sprite) : __hudelement__() constructor{
	
	#macro TopLeft [0,0]
	#macro TopCenter [0,0.5]
	#macro TopRight [0,1]
	#macro MiddleLeft [0.5, 0]
	#macro MiddleCenter [0.5, 0.5]
	#macro MiddleRight [0.5, 1]
	#macro BottomLeft [1, 0]
	#macro BottomCenter [1, 0.5]
	#macro BottomRight [1, 1]

	sprite = _sprite
	width = sprite_get_width(_sprite)
	height = sprite_get_height(_sprite)
	xFlip = 1
	yFlip = 1
	
	static SetOrigin = function(_x, _y = undefined){
		
		var _xoff, _yoff
		if is_array(_x){
			_y = _x[1]*height
			_x = _x[0]*width
		}
		
		_xoff = _x
		_yoff = _y
		
		sprite_set_offset(sprite, _xoff, _yoff)
		
		return self
	}
	
	static SetFlip = function(_xFlip = false, _yFlip = false){
		
		xFlip = _xFlip = true ? -1 : 1;
		yFlip = _yFlip = true ? -1 : 1;
		
	}
	
	static SetColor = function(_color){
		color = _color
		
		return self
	}
	
	static Draw = function(){
		if !isHidden {
			draw_sprite_ext(sprite, frame, x, y, xScale*xFlip, yScale*yFlip, angle, color, alpha)
		}
	}
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