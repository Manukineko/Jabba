#region CAROUSSEL ELEMENT
// An element that show and animate a caroussel composed of several item sprite (eg Command Ring in Secret of Mana)
function JabbaCarousselElement(_name = "") : __baseElement() constructor {
	
	itemsList = []
	activeItem = undefined
	carousselSize = 0
	rotation = 0
	rotationSpeed = 0.1
	radius = 1
	//__activeFeedback = "popout"
	//feedback = __feedback.popout.func
	
	wRadius = 128
	hRadius = 128
	fadeMin = .8
	scaleMin = .8
	drawOrder = []
	colorBlendDefault = c_white
	colorBlendActive = c_black
	hasFeedback = true
	itemHasFeedback = true
	initFeedback = false // set the feedback's variables
	__itemsProcessStep = 0
	
	//Private
	with(__feedbacks){

		highlight = {
			func : method(other, function(){
				if runFeedback{
					var _previous = activeItem
					_previous[$ "item"].SetColor(colorBlendDefault)
					itemsList[value][$ "item"].SetColor(colorBlendActive)
				
					runFeedback = false
				}
			}),
			params : ["runFeedback", true]
		}
		popout = {
			func: method(other, function(){
				if hasFeedback{	
						
						radius = radius > 0 ? __tweenFunctions.Tween_LerpTime(radius, 0, 0.1, 1) : 0
						wRadius = width + radius
						hRadius = height + radius
						//wRadius = wRadius - radius; hRadius = hRadius - radius
						//__radiusUpdated = true
						//__anyUpdated = true
						//wRadius = wRadius * radius; hRadius = hRadius * radius
						//SetRadius(wRadius, hRadius)
					}
					//if radius <= 0 runFeedback = false
					
				//}
			}),
			//params : ["radius", 16, "wRadius", other.wRadius+other.radius, "hRadius", other.hRadius+other.radius]
			params : method(other, function(){
				radius = 32
				//SetRadius(wRadius + 16,hRadius + 16)
				//wRadius = wRadius + radius
				//hRadius = hRadius + radius
			})
		}
		popout2 = {
			radius : 0,
			time : 0,
			runFeedback : false,
			
			
			params : function(){
				self.time = 0
				self.runFeedback = true
				self.radius = 32
			},
			func: function(){
				if runFeedback{
					if radius <=0 {runFeedback = false; return}
					time += 0.1
					radius = tween(32, 0, time, EASE.OUT_ELASTIC )
					callbackInternalUpdate(radius, radius)
				}
					
			},
			callbackInternalUpdate : method(other, function(_a, _b){
				wRadius = width + _a
				hRadius = height + _b
				//SetRadius(_wr, _hr)
			})
		}
	}



	show_debug_message(__feedbacks)
	
	/// @desc add an item to the caroussel in the itemlist
	__add = function( _sprite, _name, _pos){
		var _item = new JabbaGraphicElement(_sprite)
		_item.SetOrigin(MiddleCenter).SetPosition(other.x,other.y)
		
		var _itemStruct = {
			ID : carousselSize, //NO. Just testing purpose. To do better.
			name : _name,
			item : _item
		}
		if _pos = undefined{
			array_push(itemsList,_itemStruct)
			carousselSize = array_length(itemsList)
			return
		}
		itemsList[_pos] = _itemStruct
		carousselSize = array_length(itemsList)
		
	}
	__feedbackGetParams = function(){
		
		var _params = __feedbacks[$ __activeFeedback]//[$ "params"]
		_params.params()
		//var _i=0; repeat(array_length(_params)/2){
		//	variable_struct_set(self, _params[_i], _params[_i+1])
		//	_i += 2
		//}
		
	}
	
	/// @desc calculate the position of each item in the caroussel
	__buildItem = function(){
		
		//var _previous = activeItem
		
		rotation -= angle_difference(rotation, value * (360/carousselSize)*(carousselSize - 1)) / (rotationSpeed * room_speed)
		var _prio = ds_priority_create()
		var _i = 0; repeat(carousselSize){
			ds_priority_add(_prio, itemsList[_i], lengthdir_y(hRadius/2, (rotation-90) + _i * (360/carousselSize) ))
			_i++
			
		}
		var _x,_y,_fade, _scale
		__itemsProcessStep = 0; repeat(2){
		var _i = 0; repeat(carousselSize){
			switch(__itemsProcessStep){
				//start to calculate ITEMS' position & co
				case 0 :
					drawOrder[_i] = ds_priority_delete_min(_prio)
					_x = lengthdir_x(wRadius/2, (rotation-90) + drawOrder[_i][$ "ID"] * (360/carousselSize) )
					_y = lengthdir_y(hRadius/2, (rotation-90) + drawOrder[_i][$ "ID"] * (360/carousselSize) )
					_fade = clamp(-sin(pi/180 * (rotation + ((360/carousselSize) * drawOrder[_i][$ "ID"]) -90)),fadeMin,1)
					_scale = clamp(-sin(pi/180 * (rotation + ((360/carousselSize) * drawOrder[_i][$ "ID"]) -90)), scaleMin,1)
					drawOrder[_i][$ "item"].SetPosition(x+_x,y+_y).SetAlpha(_fade).SetScale(_scale)//.Update()
					
				break;
				//Then call the Update for each. Feedback will kick in as well
				case 1 :
					drawOrder[_i][$ "item"].Update()
				break
			}
			_i++
			
		}
		__itemsProcessStep++
		}
		
		//TO DO BETTER
		//activeItem = itemsList[value][$ "item"]//drawOrder[carousselSize-1][$ "item"]
		//if hasFeedback && isReach{
		//	activeItem.__feedbackUpdated = true
		//	activeItem.__anyUpdated = true
		//	activeItem.Update()
		//	isReach = false
		//}
		//activeItem[$ "item"].SetColor(c_blue)
		
		
		//if hasFeedback && runFeedback{
		//	var _done = floor(abs(_x))
		//	if _done < 1{
		//		activeItem[$ "item"].SetColor(c_blue)
		//		if !is_undefined(_previous) && _previous != activeItem{
		//			_previous[$ "item"].SetColor(c_white)
		//		}
		//		runFeedback = false
		//	}
		//}
		//Test in order to implement the feedback
		//var _d = point_direction(0,0,_x,_y)
		//show_debug_message(_previous)
		ds_priority_destroy(_prio)
		
	}
	
	/// @func AddItem(name, sprite)
	/// @desc Add an Item, a sprite, to the caroussel
	/// @param {string} name the name for the item
	/// @param {sprite} sprite the sprite to use
	/// @param {real} position NOT USED (yet)
	static AddItem = function(_sprite, _name = "", _pos = undefined){

		__add( _sprite, _name, _pos)
		return self
	}
	
		/// @func SetFeedback(feedback)
	/// @desc set the feedback that will be played when the value changes
	/// @params {string} feedback name of the feedback as a string (default : popout)
	static SetFeedback = function(_effect, _targetItem = false){
		
		if _targetItem{
			
			var _i = 0; repeat(carousselSize){
			
				with(itemsList[_i][$ "item"]){
					
					var _feedback = variable_struct_get(__feedbacks, _effect)
					feedback = _feedback.func
					__activeFeedback = _effect
					hasFeedback = true
					
				}
				
				_i++
			}
			return self
		}
			
		var _feedback = variable_struct_get(__feedbacks, _effect)
		feedback = _feedback.func
		__activeFeedback = _effect
		
		
		return self
		
	}
	
	/// @func SetRadius(width, height)
	/// @desc Set the radius of the caroussel. If the Height is omitted, it will be set to the Width value (caroussel would be a perfect circle)
	/// @param {integrer} radiusWidth
	/// @param {integrer} radiusHeight
	static SetRadius = function(_wRadius, _hRadius = undefined){
		
		if is_undefined(_hRadius){
			_hRadius = _wRadius
		}
		
		width = _wRadius
		height = _hRadius
		wRadius = width
		hRadius = height
		__radiusUpdated = true;
		__anyUpdated = true;
		
		return self
		
	}
	
	/// @func SetDepth(scale)
	/// @desc The Depth is the size of the items other than the active one in order to give a sense of depth to the caroussel.
	/// @param {integrer} scale Between 0 and 1
	static SetDepth = function(_value){
		
		scaleMin = clamp(_value,0,1)
		
		return self
		
	}
	
	/// @func SetDrawDistance(alpha)
	/// @desc Act on the transparency of the items other than the active one
	/// @param {integrer} alpha Between 0 and 1
	static SetDrawDistance = function(_value){
		
		fadeMin = clamp(_value,0,alpha)
		
		return self
		
	}
	
	/// @func SetRotationSpeed(speed)
	/// @desc Set the speed of rotation of the caroussel when an item becom active
	/// @param {integrer} speed
	static SetRotationSpeed = function(_speed){
		
		if (_speed = 0) show_error("Caroussel speed is 0",true)
		
		rotationSpeed = abs(_speed)
		
		return self
		
	}
	
	//Public functions
	/// @func SetValue
	/// @desc set the value to read from
	/// @params {relative to element} value the value to read
	/// @params {bool} play the element feedback (default : true)
	static SetValue = function(_value, _triggerFeedback = true){
		
		value = _value
		activeItem = itemsList[value][$ "item"]
		//hasFeedback = _triggerFeedback
		initFeedback = _triggerFeedback
		runFeedback = _triggerFeedback
		
			if initFeedback{
				
				if hasFeedback{
					isReach = true
					__feedbackGetParams()
				}
				if itemHasFeedback{
					activeItem.__feedbackGetParams()
				}
				
				initFeedback = false
				
			//__feedbackUpdated = true
			//__anyUpdated = true
			//
			}
	}
	
	static Update = function(){
		if (hasFeedback){
			feedback();
		}
		
		if (__anyUpdated){
			__update();
		}
		
		__buildItem()
	}
	
	/// @func Draw()
	/// @desc Draw the caroussel
	static Draw = function(){
		
		if !isHidden {
			
			var _i=0;repeat(array_length(itemsList)){
				
				if drawOrder[_i] != 0 drawOrder[_i][$ "item"].Draw()
				_i++
				
			}
		}
	}
}

#endregion