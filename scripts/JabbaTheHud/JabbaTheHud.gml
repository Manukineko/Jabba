#macro JabbaTheHud _hud.__theHud

function Jabba(_viewport = 0) constructor {
	x = 0
	y = 0
	//[TEST] tentative to understand scoping while using "private" functions & variablesp
	elementsList = [];
	//
	var _owner = other;
	__theHud = {};
	with (__theHud){
		owner = _owner;
		viewport = _viewport
	
		//elementsList = [];
		//[TEST] tentative to understand scoping while using "private" functions & variablesp
		__addElement = method(other, function(_element){
			var _list = elementsList
			with (__theHud){
				array_push(_list, _element)
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
	
	CreateCounterElement = function(){
		var _element = new JabbaCounterElement()
		var _as
		//with (__theHud){
		//	array_push(elementsList, _element)
		//	_as = array_length(elementsList)
		//	return elementsList[_as-1]
		//}
		//[TEST] tentative to understand scoping while using "private" functions & variables
		with(__theHud){
			__addElement(_element)
		}
		return _element
		//
	}
	
	CreateQuotaCounterElement = function(){
		var _element = new JabbaQuotaCounterElement()
		var _as
		//with (__theHud){
		//	array_push(elementsList, _element)
		//	_as = array_length(elementsList)
		//	return elementsList[_as-1]
		//}
		//[TEST] tentative to understand scoping while using "private" functions & variables
		with(__theHud){
			__addElement(_element)
		}
		return _element
		//
	}
	
	CreateTimerElement = function(){
		var _element = new JabbaTimerElement()
		with(__theHud){
			__addElement(_element)
		}
		return _element
	}
	
	Draw = function(){
		//with(__theHud){
			var _i=0;repeat(array_length(elementsList)){
				elementsList[_i].Draw()
				_i++
			}
		//}
		
	}
	
	FeedbackPlayer = function(){
		var _i=0;repeat(array_length(elementsList)){
			elementsList[_i].feedback()
			_i++
		}
	}
	
	
}

function __hudelement__() constructor{
	x = other.x
	y = other.y
	xscale = 1
	yscale = 1
	scale = 1
	angle = 0
	color = c_white
	alpha = 1
	value = undefined
	isHidden = false
	isReach = false
	isFeedbackOn = true
	feedback = function(){}
	
	
	__feedbacks = {}
	with(__feedbacks){
		none = function(){}
		popout = method(other, function(){
			
			if isFeedbackOn{	
				scale = scale > 1 ? __tweenFunctions.Tween_LerpTime(scale, 1, 0.1, 1) : 1
				xscale = scale; yscale = scale
			}
		})
	}
	
	__tweenFunctions = {
		Tween_LerpTime : method(other,function(_originalValue, _targetValue, _lerpAmount, _timeFactor) {
	
			var _val = lerp( _originalValue, _targetValue, 1 - power( 1 -_lerpAmount, _timeFactor));
			return _val;
	
		}),
	}
	
	SetPosition = function(_x, _y){
	    x = _x;
	    y = _y;
	}
	
	ToggleHide = function(){
		
		isHidden = !isHidden
	}
}

function JabbaCounterElement() : __hudelement__() constructor{
	value = 0
	feedback = __feedbacks.popout
	
	SetValue = function(_value, _triggerFeedback = true){
		value = _value
		isFeedbackOn = _triggerFeedback
	}
	
	SetFeedback = function(_effect){
		feedback = variable_struct_get(__feedbacks, _effect)
	}
	
	Draw = function(){
		if !isHidden{
			draw_text_transformed_color(x,y, value, xscale, yscale, angle, color, color, color, color, alpha )
		}
	}
}

function JabbaQuotaCounterElement() : __hudelement__() constructor{
  
    valueLength = 0
    quota = 0
    
    valueDigits = []
    quotaDigits = []
    digitsLimit = undefined
    counterValueLimit = undefined
    digitsColor = []
	colorQuotaReached = c_red
	colorCounterDefault = c_white
	matchingDigit = []
	spriteFont = JabbaFont
	spriteFontFrame = []
	spriteFontWidth = sprite_get_width(spriteFont)
	letterSpacing = 2 //nope. Must find a better way to do that.
    
    SetSpriteFont = function(_sprite){
			spriteFont = _sprite
			
			spriteFontWidth = sprite_get_width(spriteFont)
    }
		
		SetCounterColor = function(_defaultColor, _reachColor ){
    	
		}
    
    SetQuota = function(_quota = 1000, _limit = 9){
    	//quota to reach
    	//counter internal unit limit (it won't count past the number of unit)
        quota = _quota;
        digitsLimit = _limit
        
        var _digitNumber, divLimit
        
        //trick to build the number of quota Digits dynamically
        //I count the number of characters and use that to resize the digit array
        
        quotaDigits = array_create(digitsLimit, 0)
        //resize the value digits array
        valueDigits = array_create(digitsLimit, 0)
        //resize the color array
        digitsColor = array_create(digitsLimit, colorCounterDefault)
        //resize the matching digit array
        matchingDigit = array_create(digitsLimit,false)
        
        //set the value limit based on the digit limit in pure arcade fashion e.g 9999999
        var _cvl = (power(10, digitsLimit)) - 1//string_repeat("9", digitsLimit)
        counterValueLimit = _cvl
        
        
        //Build the quota Array to be compared with the value
        quotaDigits = SplitPowerOfTenToArray(quota, digitsLimit)
        
    }
    
    SetValue = function(_value){
    	
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
			if !isReach isReach = true
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
    
    
    
    
    Draw = method(self, function(){
       //Beware of scary out-of-bound error : DigitLimit is higher that the Indexes in those arrays, so minus ONE it needs to be. BRRR. Scary.
		if !isHidden{
        	var _i=digitsLimit-1; repeat(valueLength){
        		draw_sprite_ext(spriteFont, spriteFontFrame[_i], x+((spriteFontWidth+letterSpacing)*_i), y, 1, 1, 0, digitsColor[_i], 1 )
        		_i--
        	}
		}
    })
    
	//if is_struct(_hud) && variable_struct_exists(_hud, "__theHud"){
	//	
	//	with(JabbaTheHud){
	//	    array_push(elements, other)
	//	}
	//    show_debug_message("Ca marche (et y'a JABBA)")
	//}
	//else{
	//	owner = other
	//    show_debug_message("Ca marche (mais ya pas JABBA)")
	//}
}

function JabbaTimerElement() : __hudelement__() constructor{
	
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
	
	timeUnit = []
	timeDigit = [0,0,0,0,0]
	timeFormat = []
	__getFormat = undefined
	__createText = undefined
	__string = undefined
	
	//not used ... yet ?
	//__private = {}
	//with(__private){
	//	format = {
	//		defaut: 
	//	}
	//}
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
	SetTimeFormat = function(_array){
		timeFormat = _array
		var _func
		
		switch(array_length(_array)){
			case 1 : _func = function(_time){
		    			//return [timeUnit[timeFormat[0]](_time)]
		    			var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						return _a
					}
			break
			case 2 : _func = function(_time){
					    //return [timeUnit[timeFormat[0]](_time),
						//		timeUnit[timeFormat[1]](_time)]
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						return _a
					}
			break;
			case 3 : _func = method(self, function(_time){
		    			//return [timeUnit[timeFormat[0]](_time),
						//		timeUnit[timeFormat[1]](_time),
						//		timeUnit[timeFormat[2]](_time)]
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						array_set(_a, timeFormat[2], timeUnit[timeFormat[2]](_time))
						return _a
					})
			break
			case 4 : _func = function(_time){
		    			//return [timeUnit[timeFormat[0]](_time),
						//		timeUnit[timeFormat[1]](_time),
						//		timeUnit[timeFormat[2]](_time)]
						var _a = []
						array_set(_a, timeFormat[0], timeUnit[timeFormat[0]](_time))
						array_set(_a, timeFormat[1], timeUnit[timeFormat[1]](_time))
						array_set(_a, timeFormat[2], timeUnit[timeFormat[2]](_time))
						array_set(_a, timeFormat[3], timeUnit[timeFormat[3]](_time))
						return _a
					}
			break
			case 5 : _func = function(_time){
		    			//return [timeUnit[timeFormat[0]](_time),
						//		timeUnit[timeFormat[1]](_time),
						//		timeUnit[timeFormat[2]](_time)]
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
		
		//return _func //Find a way to set the draw function with this
		
		__getFormat = _func
		
	}
	
	UpdateTime = function(_time){
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
	
	Draw = function(){
		if !isHidden{
			draw_text(x,y, __string)
		}
	}
	
}

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
/// @desc Remove each Tens of a value and store the remaining in an array
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

