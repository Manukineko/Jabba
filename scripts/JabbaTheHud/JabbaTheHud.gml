#macro JabbaTheHud _hud.__theHud

function Jabba(_viewport = 0) constructor {
	x = 0
	y = 0
	var _owner = other.id;
	__theHud = {};
	with (__theHud){
		owner = _owner;
		viewport = _viewport
		elementsList = [];
	}
	
	CreateQuotaCounterElement = function(){
		var _element = new JabbaQuotaCounterElement()
		var _as
		with (__theHud){
			array_push(elementsList, _element)
			_as = array_length(elementsList)
			return elementsList[_as-1]
		}
	}
	
	draw = method(self, function(){
		with(__theHud){
			var _i=0;repeat(array_length(elementsList)){
				elementsList[_i].Draw()
				_i++
			}
		}
		
	})
	
	
}

function __hudelement__(/*_hud = undefined*/) constructor{
	x = other.x
	y = other.y
	
	SetPosition = function(_x, _y){
	    x = _x;
	    y = _y;
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
        //var _q=0; repeat(digitsLimit){
        //	var _dl, _arrsum
		//	
		//	_arrsum = ArraySum(quotaDigits);
        //    _dl = string_repeat("0", (digitsLimit-_q)-1);
        //    divLimit = string_insert("1", _dl, 1);
		//	
        //    quotaDigits[_q] = ((quota - _arrsum) div real(divLimit)) * real(divLimit);
		//	
        //    _q++
        //}
    }
    
    SetValue = function(_value){
    	
    	//Clamp the value from 0 to the limit set for the counter.
    	value = clamp(_value, 0, counterValueLimit)
    	valueLength = string_length(string(value))
    	
    	//Split the value by Units until we reach the limit and store it in an array
    	valueDigits = SplitPowerOfTenToArray(value, digitsLimit)
    	
    	//DOESN'T WORK YET
				if value > quota {
					var _i=0; repeat(digitsLimit){
						array_set(digitsColor, _i, colorQuotaReached)
						array_set(matchingDigit, _i, true)
						_i++
					}
					return
				}
				else{
					var _i=0; repeat(digitsLimit){
						var _iprev = _i - 1
						if (_iprev >= 0){
							matchingDigit[_i] = (valueDigits[_i] >= quotaDigits[_i] && matchingDigit[_iprev]
						}
						else{
							matchingDigit[_i] = (valueDigits[_i] >= quotaDigits[_i]
						}
						
						digitsColor[_i] = matchingDigit[_i] = true ? colorQuotaReached : colorCounterDefault 
						_i++
					}
    		}
    	//var _q=0; repeat(digitsLimit){
        //	var _dl, _arrsum
		//	
		//	_arrsum = ArraySum(valueDigits);
        //    _dl = string_repeat("0", (digitsLimit-_q)-1);
        //    divLimit = string_insert("1", _dl, 1);
		//	
        //    valueDigits[_q] = ((value - _arrsum) div real(divLimit)) * real(divLimit);
		//	
        //    _q++
    	//}
    	}
    	
    }
    
    SetCounterColor = function(_defaultColor, _reachColor ){
    	
    }
		
		IsReached = function(_callback = function(){}){
			
		}
    
    
    
    
    Draw = method(self, function(){
        draw_text_color(x,y,string(value),digitsColor[0],digitsColor[0],digitsColor[0],digitsColor[0],1)
        //draw_sprite_ext(fntDefault, )
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
	
}

/// @func ArraySum
/// @desc add all value of an array.
function ArraySum(_array){
    var _i, _sum = 0, _l, _a
    
    _l = array_length(_array)
    
    _i = 0; repeat(_l){
         _a = _array[_i]
        if (is_numeric(_a)){
        _sum += _a
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
function SplitPowerOfTenToArray(_value, _digitsSize = 0){
        	
	var _size, _array, _div, _sum
	_size = (_digitsSize <= 0) ? string_length(string(_value)) : _digitsSize
	
	_array = array_create(_size, 0)
	//_div = power(10, _size-1)
	
	var _i=0; repeat(_size){
		
		_sum = ArraySum(_array);
		_div = power(10, _size-_i-1)
	    _array[_i] = ((_value - _sum) div _div) * _div;
		
		//_div = _div / 10
		_i++
	}
	return _array
}

/// @func SplitByDigitsToArray
/// @desc Put each digit of the value in an array
function SplitByDigitsToArray(_value){
   	var _l, _a 
   	_l = string_length(string(_value))
   	
   	var _i = _l-1; repeat(_l){
   		
   		_value = _value / 10
   		_a[_i] = frac(_value) * 10
		_i--
   	}
	return _a
}

/// @func StripPowerOfTensToArray
/// @desc Remove a Tens of a value and store the result of each strip in an array
function StripPowerOfTensToArray(_value){
   	var _l, _a 
   	_l = string_length(string(_value))
   	
   	var _i = _l-1; repeat(_l){
   		
   		_value = _value / 10
   		_a[_i] = floor(_value)
		_i--
   	}
	return _a
}

