function __feedbackPlayer() constructor {
    owner = other
    state = 0
    time = 0
    color = owner.color
    run = false
    feedback = undefined
    __stateLength = 0
    
    static __getFeedbackLibrary = function(_array){
    	var _fsm = [], _a = ds_map_find_value(global.__jabbaFeedbacksList, _array);
    	array_copy(_fsm, 0, _a , 0, array_length(_a));
    	return _fsm;
    }
    
    /// @desc Reset state and time if the feedback is triggered again while already running.
    static __reset = function(){
    	state = 0
    	time = 0
    }
    
    static __play = function(){
    	if run{
        	feedback[state]()
    	}
    }
    
    static Set = function(_name){
        
        feedback = __getFeedbackLibrary(_name)
        __stateLength = array_length(feedback)
        
    }
    
    static Complete = function(){
    	state = 0
		time = 0
    	run = false
    }
}



/// @func JabbaCounterElement(_limit, _name)
/// @desc a simple counter. it will display the value with a feedback when the value changes.
/// @param {int}limit The value limit from which the counter won't update.
/// @param {string} name Giving a name to the Element helps for debugging but can be also used to display it's name in a tutorial.
function JabbaCounterElement2(_limit = 10, _name = "Counter", _hud = undefined) : __fontTypeElement__() constructor{
	
	name = _name
	limit = _limit
	asset = fJabbaFont
	halign = fa_center
	valign = fa_middle
	enableFeedback = true
	
	static __addToHud = function(_hud){
		var _h = variable_instance_get(other, _hud)
		array_push(_h.elementsList, self)
		_h.elementsListSize++
	}
	
	if !is_undefined(_hud) __addToHud(_hud)
	
	feedback = new __feedbackPlayer()
	feedback.Set("flipOnce")
	
	/// @func SetValue
	/// @desc set the value to display by the Element
	/// @params {} value the value to read
	/// @params {bool} play the element feedback (default : true)
	static SetValue = function(_value, _enableFeedback = true){
		value = _value
		enableFeedback = _enableFeedback
		if enableFeedback{
			with(feedback){
				if run {
					__reset()
				}
				else run = true
			}
			//feedback.run = true
		}
		//if hasFeedback{
		//	__feedbackUpdated = true
		//	__anyUpdated = true
		//	//__feedbackGetParams()
		//}
		return self
	}
	
	static SetFeedback = function(_name){
		feedback.Set(_name)
		
		return self
	}
	
	/// @func SetTextAlign()
	/// @desc Set the alignement of the text (GML constant fa_*)
	/// @param {constant} halign
	/// @param {constant} valign
	static SetTextAlign = function(_halign, _valign){
		halign = _halign
		valign = _valign
		
		__originUpdated = true
		__anyUpdated = true
		
		return self
	}
	
	/// @func Update
	/// @desc [Standalone Only] Must be called in the End Step Event if you use this Element as a standalone or outside a JabbaContainer.
	static Update = function(){
		if (enableFeedback){
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
	
	/// @func Draw()
	/// @desc Draw the element. Bypassed if isHidden is false
	static Draw = function(){
		if !isHidden{
			draw_set_font(asset)
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_transformed_color(x,y, value, xScale, yScale, angle, color, color, color, color, alpha )
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




