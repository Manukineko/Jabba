function __feedbackPlayer(_elementType = ELEMENT.BASE) constructor {
    owner = other
    state = 0
    time = 0
    color = owner.color
    run = false
    feedback = __getFeedbackLibrary("none")
    __stateLength = 0
    
    /// @desc Internal - Get the statemachine of a feedback effect
    static __getFeedbackLibrary = function(_array){
    	var _fsm = [], _a = ds_map_find_value(global.__jabbaFeedbacksList[owner.elementType], _array);
		if is_undefined(_a) return show_error("[JABBA WARNING] The Feedback for "+owner.name+" doesn't exists", true)
    	array_copy(_fsm, 0, _a , 0, array_length(_a));
    	return _fsm;
    }
    
    /// @desc Reset state and time if the feedback is triggered again while already running.
    static __reset = function(){
    	state = 0
    	time = 0
    }
    
    /// @desc Internal - play the feedback
    static __play = function(){
    	if run{
        	feedback[state]()
    	}
    }
    
    /// @func Set
    /// @desc Assign the chosen feedback to the Element
    /// @param {string} name of the feedback
    static Set = function(_name){
        
        feedback = __getFeedbackLibrary(_name)
        __stateLength = array_length(feedback)
        
    }
    
    /// @func Complete
    /// @desc Must be call on the last state of a feedback function. Used only when you write you own feedback
    static Complete = function(){
    	state = 0
		time = 0
    	run = false
    }
}