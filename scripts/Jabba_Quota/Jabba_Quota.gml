#region QUOTA COUNTER

/// @func JabbaQuotaCounterElement
/// @desc [Type: Font] An Element that will change color when the set Quota is reached.
/// @desc [Default Color - Quota Not Reached : White, Quota Reached : Red]
/// @param {string} name [Optional - default: Quota Counter]
/// @param {int} DigitsLimit [Optional - default: 9 (hundred million)] This will lock the Counter to the set number of digits with "9" even if the value goes beyond
/// @param {string} JabbaContainer The name of the JabbaContainer (a struct)

function JabbaQuotaCounterElement(_name = "Quota Counter", _digitsLimit = 9, _hud = undefined) : JabbaCounterElement() constructor{
	
	elementType = ELEMENT.QUOTA
	name = _name
	asset = JabbaFontDefault	//the default font
	digitsLimit = _digitsLimit	//the number of digits to lock the counter to
	limit = 0					// The quota to reach
	colorQuota = c_red			// Color to use when the Quota is reached
	colorNormal = c_white		// Color to use by default
	height = string_height(value)
	width = string_width(value)
	
	__reachTo = -1
	__counterValueLimit = (power(10, digitsLimit)) - 1 //the variable formating the value to number of "9" when DigitsLimit is reached.
	__activeFeedback = "popout"
	
	if !is_undefined(_hud) __addToHud(_hud)
	
	static __feedbackPlayOnReach = function(_mode = 1){
		if !isReach{
			if __isReach(_mode){
				isReach = true
				if feedbackIsEnabled{
					with(feedback){
						if !run run = true
					}
				}
				color = colorQuota
			}
		}else{
			if !__isReach(_mode) {
				isReach = false
				color = colorNormal
			}
		}
	}
	
	/// @func SetValue
	/// @desc Set the Value to compare the Quota to.
	/// @desc The method auto-update the width and height of the Element.
	/// @desc [Quota is reached] Turn the isReach value to true, change the Color's Element and trigger the attached Feedback 
	/// @param {int} value
	/// @param {bool} autofeedback if the feedback should play automatically or not
	static SetValue = function(_value, _autofeedback = true){
    	value = clamp(_value, 0, __counterValueLimit)
    	height = string_height(value)
		width = string_width(value)
		
		if feedbackIsEnabled{
			__feedbackPlayOnReach(__reachTo)
		}
    	
    	return self
    }
	
	/// @func SetQuota
	/// @desc Set the Quota to compare the Value to.
	/// @param {int} quota
	/// @param {real} direction [default: 1 (higher)] - if the quota to reach is higher : 1 or lower: 0 than the value to monitor 
	static SetQuota = function(_quota, _direction = 1){
    	//counter internal unit limit (it won't count past the number of unit)
    	if !is_numeric(_quota) show_error("The set Quota value is not a NUMBER", true)
    	if !is_int(_quota) show_error("The set Quota value is not an INTEGRER", true)
    	
        limit = _quota;
        __reachTo = _direction
        
        return self
    }
    
    /// @func SetDigitsLimit
    /// @desc Set the number of Digits allowed
    /// @param {int} Limit
    static SetDigitsLimit = function(_digitsLimit){
    	digitsLimit = _digitsLimit
        
        //set the value limit based on the digit limit in pure arcade fashion e.g 9999999
        var _cvl = (power(10, digitsLimit)) - 1
        __counterValueLimit = _cvl
        
        return self
    }
    
    /// @func SetTextColor
	/// @desc Set the Default Color and the Reached Color
	/// @params {color} normalColor
	/// @params {color} quotaColor The color to change when the quota is reached
	static SetTextColor = function(_normalColor, _quotaColor ){
    	
    	colorNormal = _normalColor
    	colorQuota = _quotaColor
		
	}
    
    /// @func SetFont
    /// @desc Set the Font to use to display the Value
    /// @param {font} Font
    static SetFont = function(_font){
    	if asset_type(_font) != font show_error("The Asset set for the Quota Counter is not a FONT", true)
    	asset = _font
    }
    
    /// @func FeedbackPlay
	/// @desc [On Reach] Play the Feedback assign to the Element when the value reach the limit
	static FeedbackPlay = function(){
		if feedbackIsEnabled{
			__feedbackPlayOnReach(__reachTo)
		}
	}
    
}
#endregion

#region QUOTA COUNTER EXT
/// @func JabbaQuotaCounterExtElement
/// @desc [Type : Sprite] An EXTENDED version of the Quota Counter Element that use sprite as its font. It allow to progressively change the color of each unit individually
/// @desc [Default Color - Quota Not Reached : White, Quota Reached : Red]
/// @param {string} name [Optional - default: Quota Counter EXT]
/// @param {int} DigitsLimit [Optional - default: 9 (hundred million)]
/// @param {string} JabbaContainer The name of the JabbaContainer (a struct)

function JabbaQuotaCounterExtElement(_name = "Quota Counter EXT", _digitsLimit = 9, _hud = undefined) : __spriteTypeElement__() constructor{
	
	elementType = ELEMENT.QUOTA
    name = _name					
    asset = JabbaFont				//the default font
    digitsLimit = _digitsLimit		//the number of digits to lock the counter to
    limit = 0						// The quota to reach
    colorQuota = c_red				// Color to use when the Quota is reached
	colorNormal = c_white			// Color to use by default
	width = sprite_get_width(asset)
	height = sprite_get_height(asset)
	letterSpacing = 2				// The space between two letters (sprite)
    valueLength = 0					// The Length of the value's string
   
    
#region /***************************** Private Variables **********************************/
    __reachTo = -1					// the direction to reach : downward or backward to use in the __isReach() method
    __valueDigits = array_create(digitsLimit, 0)
    __quotaDigits = array_create(digitsLimit, 0)
    __counterValueLimit = (power(10, digitsLimit)) - 1
	__digitsColor = array_create(digitsLimit, colorNormal)
	__matchingDigit = array_create(digitsLimit,false)
	__spriteFontFrame = []
	
	if !is_undefined(_hud) __addToHud(_hud)
	
#endregion /********************************************************************************/
	
	/// @desc assigne the QuotaColor to all the Units
	static __setFullReach = function(){
		var _i=0; repeat(digitsLimit){
			array_set(__digitsColor, _i, colorQuota)
			array_set(__matchingDigit, _i, true)
			_i++
		}
	}
	
	/// @desc Determine the check regarding the chosen limit direction (higher or lower)
	static __digitIsReach = function(_mode, _ind, _i, _iprev){
		var _a
		switch (_ind){
			case 0 : _a = [(__valueDigits[_i] <= __quotaDigits[_i] && __matchingDigit[_iprev]), (__valueDigits[_i] >= __quotaDigits[_i] && __matchingDigit[_iprev])]
			break
			case 1 : _a = [(__valueDigits[_i] <= __quotaDigits[_i]), (__valueDigits[_i] >= __quotaDigits[_i])]
		}
		
		return _a[_mode]
	}
	
	/// @desc Determine which unit can be lit
	static __setProgressiveReach = function(){
		var _i=0; repeat(digitsLimit){
			var _iprev = _i - 1
			
			if (_iprev >= 0){
				
				__matchingDigit[_i] = __digitIsReach(__reachTo, 0,  _i, _iprev)
				//__matchingDigit[_i] = (__valueDigits[_i] >= __quotaDigits[_i] && __matchingDigit[_iprev])
					
			}
			else{
				__matchingDigit[_i] = __digitIsReach(__reachTo,1, _i, _iprev)
				//__matchingDigit[_i] = (__valueDigits[_i] >= __quotaDigits[_i])
			}
				
			__digitsColor[_i] = __matchingDigit[_i] = true ? colorQuota : colorNormal 
			_i++
		}
			
		if isReach isReach = false
	}
	
	/// @desc Play the feedback on reach
	static __feedbackPlayOnReach = function(_mode = 1, _autofeedback){
		
		if __isReach(_mode){
			if !isReach{
				__setFullReach()
				
				if _autofeedback{
					if feedbackIsEnabled{
						with(feedback){
							if !run run = true
						}
					}
				}
			isReach = true
			}
		}else{
			__setProgressiveReach()
			isReach = false	
		} 
		
	}
		
	/// @func SetValue(value)
   /// @desc Set the value to compare to the quota. The function will trigger a boolean and colored the text if the quota is reached.
   /// @params {integrer} value
   /// //[TODO] Add feedback system per DIGITS
    static SetValue = function(_value, _autofeedback = true){
    	
    	//Clamp the value from 0 to the limit set for the counter.
    	value = clamp(_value, 0, __counterValueLimit)
    	valueLength = CountDigit(value)//string_length(string(value))
    	
    	//Split the value by Units until we reach the limit and store it in an array
    	__valueDigits = SplitPowerOfTenToArray(value, digitsLimit)
    	__spriteFontFrame = SplitByDigitsToArray(value, digitsLimit)
    	
    	__feedbackPlayOnReach(__reachTo, _autofeedback)

	}
	
	/// @func SetQuota
    /// @desc Set the quota value to be reached. You can set a limit to the number of digit. If the value goes above it, it will be ignored.
    /// @params {integrer} quota the quota value to reach
	/// @param {real} direction [default: 1 (higher)] - if the limit to reach is higher : 1 or lower: 0 than the value to monitor 
    static SetQuota = function(_quota, _direction = 1){
    	//quota to reach
    	//counter internal unit limit (it won't count past the number of unit)
        limit = _quota;
        __reachTo = _direction
        
        var _digitNumber, divLimit
        
        //trick to build the number of quota Digits dynamically
        //Count the number of characters and use that to resize the digit array
        
        array_resize(__quotaDigits, digitsLimit)
        	//__quotaDigits = array_create(digitsLimit, 0)
        
        //resize the value digits array
        array_resize(__valueDigits, digitsLimit)
        	//__valueDigits = array_create(digitsLimit, 0)
        
        //resize the color array
        array_resize(__digitsColor, digitsLimit)
        	//__digitsColor = array_create(digitsLimit, colorNormal)
        
        //resize the matching digit array
        array_resize(__matchingDigit, digitsLimit)
        	//__matchingDigit = array_create(digitsLimit,false)
   
        //Build the quota Array to be compared with the value
        __quotaDigits = SplitPowerOfTenToArray(limit, digitsLimit)
        
        return self
        
    }
    
    /// @func SetDigitsLimit
    /// @desc Set the number of Digits allowed
    /// @param {int} Limit
    static SetDigitsLimit = function(_digitsLimit){
    	digitsLimit = _digitsLimit
        
        //set the value limit based on the digit limit in pure arcade fashion e.g 9999999
        var _cvl = (power(10, digitsLimit)) - 1
        __counterValueLimit = _cvl
        
        return self
    }
    
    /// @func SetSpriteFont
    /// @desc Use a spritesheet for the font
    /// @desc The methods auto-calculate the width and height of the Element
    /// @params {spritesheet} Sprite Must be a spritesheet where each digit are a frame, starting from 0 to 9 (unless you want some funny behavior)
    static SetSpriteFont = function(_sprite){
			asset = _sprite
			
			width = sprite_get_width(asset)
			height = sprite_get_height(asset)
			
			return self
    }
	
	/// @func SetTextColor
	/// @desc Set the Default Color and the Reached Color
	/// @params {color} normalColor
	/// @params {color} quotaColor The color to change when the quota is reached
	static SetTextColor = function(_normalColor, _quotaColor ){
    	
    	colorNormal = _normalColor
    	colorQuota = _quotaColor
		
	}
    
    /// @func Draw()
    /// @desc Draw the element
    static Draw = function(){
       //Beware of scary out-of-bound error : DigitLimit is higher that the Indexes in those arrays, so minus ONE it needs to be. BRRR. Scary.
		if !isHidden{
        	var _i=digitsLimit-1; repeat(valueLength){
        		draw_sprite_ext(asset, __spriteFontFrame[_i], x+((width+letterSpacing)*_i), y, xScale, yScale, angle, __digitsColor[_i], 1 )
        		_i--
        	}
		}
		
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
    }
}
#endregion