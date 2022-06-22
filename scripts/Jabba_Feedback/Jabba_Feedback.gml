function __feedbackPlayer() constructor {
    owner = other
    state = 0
    time = 0
    color = owner.color
    run = false
    feedback = __getFeedbackLibrary("popout")
    __stateLength = 0
    
    //local feedback effect
    
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