__Jabba_Initialize_ALT()

function __Jabba_isDuplicateFeedback(_element, _name){
	var _k = ds_map_keys_to_array(global.__jabbaFeedbacksList[_element])
    if array_length(_k) != undefined{
        for (_j = 0; _j < array_length(_k); _j++) {
            if _k[_j] = _name{
                show_debug_message("Feedback Effect Name already in use for enum ELEMENT at index "+string(_element))
                return true
            }
        }
    }
	return false
}

function Jabba_AddFeedback(_element, _name, _array){
	if !is_array(_element){
		if !__Jabba_isDuplicateFeedback(_element, _name){
			ds_map_add(global.__jabbaFeedbacksList[_element], _name, _array)
			return
		}
	}
	
    var _i = 0; repeat(array_length(_element)){
		if !__Jabba_isDuplicateFeedback(_element[_i], _name){
        ds_map_add(global.__jabbaFeedbacksList[_element[_i]], _name, _array)
		}
		_i++
    }
    
}

function __Jabba_Initialize_ALT() {
    global.__jabbaFeedbacksList = []
    
    var _i = 0; repeat(ELEMENT.SIZE){
        global.__jabbaFeedbacksList[_i] = ds_map_create()
        _i++
    }
    
    Jabba_AddFeedback(ELEMENT.BASE, "none", [
		method(undefined, function(){
			return
		})
	])
    
	Jabba_AddFeedback([ELEMENT.COUNTER, ELEMENT.GRAPHIC, ELEMENT.GAUGE], "flash", [
    	method(undefined, function(){
    		state++;
    		time = 0
    		color = c_red
    		owner.ChangeColor(color)
    	}),
    	method(undefined, function(){
    		if time > 15{
    			Complete()
    			owner.ChangeColor()
    		} else time++
    	}),
    ])
    
    Jabba_AddFeedback([ELEMENT.TIMER,ELEMENT.COUNTER, ELEMENT.QUOTA, ELEMENT.GRAPHIC], "popout", [
        method(undefined, function(){
        	scale = 2
        	time = 0
        	state++
        }),
        method(undefined, function(){
        	time += 0.075
        	scale = tween(2,1,time,EASE.INOUT_CUBIC)
        	owner.SetScale(scale, scale)
        	if scale <= 1 {
        		Complete()
        	}
        })
    ])
    
    Jabba_AddFeedback(ELEMENT.CAROUSSEL, "CarousselBounce", [
    	method(undefined, function(){
			radius = 32
			animate = true
			time = 0
			state++
		}),
		method(undefined, function(){
			//if animate{
				time += 0.1
				radius = tween(32,0,time,EASE.SMOOTHSTEP)
				owner.wRadius = owner.width + radius
				owner.hRadius = owner.height + radius
				//owner.SetRadius(owner.width+radius, owner.height+radius)
				if time = 1 {
					Complete()
					animate = false
				}
			//}
		})
	])
    
    //ds_map_add(global.__jabbaFeedbacksList_ALT[ELEMENT.COUNTER], "flash", [
    //	method(undefined, function(){
    //		state++;
    //		time = 0
    //		color = c_red
    //		owner.ChangeColor(color)
    //	}),
    //	method(undefined, function(){
    //		//time++
    //		if time > 15{
    //			Complete()
    //			owner.ChangeColor()
    //		} else time++
    //	}),
    //])
    //
    //ds_map_add(global.__jabbaFeedbacksList_ALT[ELEMENT.GRAPHIC], "flash", [
    //	method(undefined, function(){
    //		state++;
    //		time = 0
    //		color = c_red
    //		owner.ChangeColor(color)
    //	}),
    //	method(undefined, function(){
    //		//time++
    //		if time > 15{
    //			Complete()
    //			owner.ChangeColor()
    //		} else time++
    //	}),
    //])
}

//function __Jabba_Initialize() {
//    
//    
//	
//	global.__jabbaFeedbacksList = ds_map_create()
//	//Jabba Feedback List HERE
//	
//	ds_map_add(global.__jabbaFeedbacksList, "none", [
//		method(undefined, function(){
//			return
//		})
//	])
//	
//	ds_map_add(global.__jabbaFeedbacksList, "flash", [
//		method(undefined, function(){
//			state++;
//			time = 0
//			color = c_red
//			owner.ChangeColor(color)
//		}),
//		method(undefined, function(){
//			//time++
//			if time > 15{
//				Complete()
//				owner.ChangeColor()
//			} else time++
//		}),
//	])
//	ds_map_add(global.__jabbaFeedbacksList, "highlightItem", [
//		method(undefined, function(){
//			state++;
//			time = 0
//			val = true
//		}),
//		method(undefined, function(){
//			if owner.caroussel.activeItem.ID = owner.ID{
//				if val{
//					owner.ChangeColor(owner.caroussel.colorBlendActive)
//					val = false
//				}
//			}
//			else{
//				owner.ChangeColor(owner.caroussel.colorBlendDefault)
//				Complete()
//			}
//		}),
//	])
//	
//	ds_map_add(global.__jabbaFeedbacksList, "popout", [
//		method(undefined, function(){
//			scale = 2
//			time = 0
//			state++
//		}),
//		method(undefined, function(){
//			time += 0.1
//			scale = tween(2,1,time,EASE.INOUT_CUBIC)
//			owner.SetScale(scale, scale)
//			if scale <= 1 {
//				Complete()
//			}
//		})
//	])
//	ds_map_add(global.__jabbaFeedbacksList, "flipOnce", [
//		method(undefined, function(){
//			time = 0
//			xscale = 1
//			maxscale = 1
//			state++
//		}),	
//		method(undefined, function(){
//			xscale = tween(maxscale,0, time, EASE.OUT_CUBIC)
//			if xscale <= 0 {state++ ; time = 0;}
//			time += 0.1
//			owner.SetScale(xscale,1)
//		}),
//		method(undefined, function(){
//			xscale = tween(0,maxscale, time, EASE.OUT_CUBIC);
//			if xscale >= 1 {Complete()}
//			time += 0.1
//			owner.SetScale(xscale,1)
//		})
//	])
//	ds_map_add(global.__jabbaFeedbacksList, "radiusPopout", [
//		method(undefined, function(){
//			radius = 32
//			animate = true
//			time = 0
//			state++
//		}),
//		method(undefined, function(){
//			if animate{
//				time += 0.1
//				radius = tween(32,0,time,EASE.SMOOTHSTEP)
//				owner.wRadius = owner.width + radius
//				owner.hRadius = owner.height + radius
//				//owner.SetRadius(owner.width+radius, owner.height+radius)
//				if time = 1 {
//					Complete()
//					animate = false
//				}
//			}
//		})
//	])//