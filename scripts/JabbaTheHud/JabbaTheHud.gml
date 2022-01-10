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
	
	Draw = method(self, function(){
		//with(__theHud){
			var _i=0;repeat(array_length(elementsList)){
				elementsList[_i].Draw()
				_i++
			}
		//}
		
	})
	
	
}

function __hudelement__(/*_hud = undefined*/) constructor{
	x = other.x
	y = other.y
	isHidden = false
	isReach = false
	
	SetPosition = function(_x, _y){
	    x = _x;
	    y = _y;
	}
	
	ToggleHide = function(){
		
		isHidden = !isHidden
	}
}

function JabbaQuotaCounterElement(/*_hud = undefined*/) : __hudelement__() constructor{
    value = 0
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
	
	#macro tHundreds (time div 10) mod 100
	#macro tSeconds  (time div 1000) mod 60
	#macro tMinutes  (time div 60000) mod 60

	enum JABBA{
		MINUTES,
		SECONDS,
		HUNDREDTH
	}
	
	time = 568954
	timeLimit = 0
	timeSeparator = ";"
	precision = [0,1]
	hundredth = 0
	seconds = 0
	minutes = 0
	hours = 0
	days = 0
	timeFormat = [tMinutes, tSeconds, tHundreds]
	timeDigits = []
	precision = [0,1]
	var _owner = other
	__private = {}
	with (__private){
		owner = _owner
		
		__update = method(other, function(_time){
			
		})
		
		
		
		
		
	}
	
	UpdateTime = function(_time = time){
			time = _time
			var _i = precision[0]; repeat(precision[1]){
				timeDigits[_i] = timeFormat[_i]
			}
		
	}
	
	//
	
	
	SetPrecision = function(_start, _end){
		precision = [_start, _end]
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

