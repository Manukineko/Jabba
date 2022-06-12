//An element that will split and display a time.
/// @func JabbaTimerElement
/// @desc [Type : Font] An Element to display a time
/// @desc [Time Units] Highest : Days, Smallest : Hundredth
/// @param {string} name [Optional - default: Timer]
function JabbaTimerElement(_name = "Timer") : __fontTypeElement__() constructor{
	
	asset = JabbaFontDefault
	timeLimit = 0
	timeSeparator = ":"
	halign = fa_center
	valign = fa_middle

#region /*********************** Private Variables & Methods *********************/
	static __timeUnit = []
	__timeDigit = [0,0,0,0,0]
	__timeFormat = []
	__getFormat = undefined
	__createText = undefined
	__string = undefined
	
	//Create an array of function to convert time from
	//milliseconde to every time units
	__timeUnit[JT.DAYS] = function(_time){
	  return (_time div 86400000) mod 60
	}
	__timeUnit[JT.HOURS] = function(_time){
	  return (_time div 3600000) mod 60
	}
	__timeUnit[JT.MIN] = function(_time){
	  return (_time div 60000) mod 60
	}
	__timeUnit[JT.SEC] = function(_time){
	  return (_time div 1000) mod 60
	}
	__timeUnit[JT.HUN] = function(_time){
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
#endregion /********************************************************************/
	
	/// @func SetTimeFormat
	/// @desc Set the time format. The order in the array is the displaying order
	/// @params {array} format An array of time unit to use (Use the JT Enum provided in Jabba_Config. eg : [JT.MIN, JT.SEC])
	static SetTimeFormat = function(_array){
		__timeFormat = _array
		var _func
		
		switch(array_length(_array)){
			case 1 : _func = function(_time){
		    		
		    			var _a = []
						array_set(_a, __timeFormat[0], __timeUnit[__timeFormat[0]](_time))
						return _a
					}
			break
			case 2 : _func = function(_time){
					    
						var _a = []
						array_set(_a, __timeFormat[0], __timeUnit[__timeFormat[0]](_time))
						array_set(_a, __timeFormat[1], __timeUnit[__timeFormat[1]](_time))
						return _a
					}
			break;
			case 3 : _func = method(self, function(_time){
		    			
						var _a = []
						array_set(_a, __timeFormat[0], __timeUnit[__timeFormat[0]](_time))
						array_set(_a, __timeFormat[1], __timeUnit[__timeFormat[1]](_time))
						array_set(_a, __timeFormat[2], __timeUnit[__timeFormat[2]](_time))
						return _a
					})
			break
			case 4 : _func = function(_time){
		    			
						var _a = []
						array_set(_a, __timeFormat[0], __timeUnit[__timeFormat[0]](_time))
						array_set(_a, __timeFormat[1], __timeUnit[__timeFormat[1]](_time))
						array_set(_a, __timeFormat[2], __timeUnit[__timeFormat[2]](_time))
						array_set(_a, __timeFormat[3], __timeUnit[__timeFormat[3]](_time))
						return _a
					}
			break
			case 5 : _func = function(_time){
		    			
						var _a = []
						array_set(_a, __timeFormat[0], __timeUnit[__timeFormat[0]](_time))
						array_set(_a, __timeFormat[1], __timeUnit[__timeFormat[1]](_time))
						array_set(_a, __timeFormat[2], __timeUnit[__timeFormat[2]](_time))
						array_set(_a, __timeFormat[3], __timeUnit[__timeFormat[3]](_time))
						array_set(_a, __timeFormat[4], __timeUnit[__timeFormat[4]](_time))
						return _a
					}
			break
		}
		
		__getFormat = _func
		
		return self
		
	}
	
	/// @func SetTime
	/// @desc Set the time to update and format into a string that will be display
	/// @param {integrer} Time in millisecondes
	static SetTime = function(_time){
		value = _time
		
		__timeDigit = __getFormat(_time)
		
		var _leadingZero, _str ="", _l = array_length(__timeFormat)
		var _i =0; repeat(_l){
			//add a leading zero
			_leadingZero = __timeDigit[__timeFormat[_i]] < 10 ? "0" : ""
			_str = _str+_leadingZero
			_str = _str+string(__timeDigit[__timeFormat[_i]])
			if (_i = _l-1) {
				//last Time Unit
				__string = _str; 
				return self
			}
			//add the time separator to the string
			_str = _str+timeSeparator
			_i++
		}
		
		return self
	}
	
	/// @func Draw()
	/// @desc Draw the element. By passed if isHidden is true.
	static Draw = function(){
		if !isHidden{
			draw_set_font(asset)
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_transformed_color(x,y, __string, xScale, yScale, angle, color, color, color, color, alpha )
			draw_set_halign(-1)
			draw_set_valign(-1)
		}
		
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
	}
}

#endregion