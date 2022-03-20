#region QUOTA COUNTER
// An Element that will change color when a quota is reached
function JabbaQuotaCounterElement(_quota, _digitsLimit = 9, _name = "") : JabbaCounterElement() constructor{
	
	name = _name
	asset = fJabbaFont
	digitsLimit = _digitsLimit
	quota = _quota
	counterValueLimit = (power(10, digitsLimit)) - 1
	colorQuotaReached = c_red
	colorCounterDefault = c_white
	__activeFeedback = "popout"
	
	/// @func SetQuota(quota, counterLimit)
	/// @desc Set the quota to compare the value to.
	/// @param {real} quota
	/// @param {real} counterLimit Set the maximum unit to display. This is mandatory in order to calculate the position neatly
	static SetQuota = function(_quota){
    	//counter internal unit limit (it won't count past the number of unit)
        quota = _quota;
        
        return self
    }
    
    static SetDigitsLimit = function(_digitsLimit){
    	digitsLimit = _digitsLimit
        
        //set the value limit based on the digit limit in pure arcade fashion e.g 9999999
        var _cvl = (power(10, digitsLimit)) - 1
        counterValueLimit = _cvl
        
        return self
    }
    
    static SetValue = function(_value){
    	value = _value
    	height = string_height(value)
		width = string_width(value)
    	
    	if value >= quota{
    		if !isReach{
    			if hasFeedback{
    				//__feedbackUpdated = true
    				//__anyUpdated = true
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
    
    static SetFont = function(_font){
    	asset = _font
    }
}
#endregion


// An EXTENDED version of the Quota Counter Element that use sprite as its font. It allow to progressively change the color of each unit individually
#region QUOTA COUNTER EXT
/// @func JabbaQuotaCounterExtElement
/// @desc An extended Quota Counter using sprite as font and allowing to color each digit independently progressively as the quota is reached.
function JabbaQuotaCounterExtElement(_name = "") : __spriteTypeElement__() constructor{
  
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
	
	asset = JabbaFont
	spriteFontFrame = []
	spriteFontWidth = sprite_get_width(asset)
	letterSpacing = 2 
	
	feedback = __feedbacks.popout.func
	__activeFeedback = "popout"
    
    /// @func SetSpriteFont(sprite)
    /// @desc The spritesheet used for the font
    /// @params {sprite} sprite Must be a spritesheet where each digit are a frame, starting from 0 to 9 (unless you want some funny behavior)
    static SetSpriteFont = function(_sprite){
			asset = _sprite
			
			spriteFontWidth = sprite_get_width(asset)
			
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
        		draw_sprite_ext(asset, spriteFontFrame[_i], x+((spriteFontWidth+letterSpacing)*_i), y, xScale, yScale, angle, digitsColor[_i], 1 )
        		_i--
        	}
		}
    })
}
#endregion