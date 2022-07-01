#region CAROUSSEL ELEMENT
/// @func JabbaCarousselElement
/// @desc An element that show and animate a caroussel composed of several item sprite (eg Command Ring in Secret of Mana)
/// @param {string} name The name of the Element [Optional - default : Caroussel]
/// @param {string} JabbaContainer The name of the JabbaContainer (a struct)
function JabbaCarousselElement(_name = "Caroussel", _hud = undefined) : __baseElement() constructor {
	
	elementType = ELEMENT.CAROUSSEL
	name = _name
	itemsList = []
	activeItem = undefined
	colorBlendDefault = c_white
	colorBlendActive = c_yellow
	radius = 1
	wRadius = 128
	hRadius = 128
	fadeMin = .8
	scaleMin = .8
	carousselSize = 0
	rotation = 0
	rotationSpeed = 0.1
	drawOrder = []
	itemFeedbackIsEnabled = true
	initFeedback = false // set the feedback's variables
	
	__itemsProcessStep = 0
	
	if !is_undefined(_hud) __addToHud(_hud)
	
	/// @func __add
	/// @desc add an item to the caroussel in the itemlist
	/// @param sprite the sprite to use for the new item
	/// @param name the new item's name
	/// @param position 
	__add = function( _sprite, _name, _pos){
		var _item = new __CarousselItemElement(_sprite, _name, carousselSize, self)

		_item.SetOrigin(MiddleCenter).SetPosition(other.x,other.y)
		//_item.ID = _pos
		//_item.name = _name

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
		//ROLLBACK : not allow custom position in the list
		itemsList[_pos] = _itemStruct
		carousselSize = array_length(itemsList)
		
	}
	
	/// @desc calculate the position of each item in the caroussel
	__buildItem = function(){
		
		//var _previous = activeItem
		
		rotation -= angle_difference(rotation, value * (360/carousselSize)*(carousselSize - 1)) / (rotationSpeed * room_speed)
		var _prio = ds_priority_create()
		var _i = 0; repeat(carousselSize){
			//add the item to the priority based on its position on the radius
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
						drawOrder[_i][$ "item"].SetPosition(x+_x,y+_y).SetScale(_scale).SetAlpha(_fade)//.Update()
						
					break;
					//Then call the Update for each. Feedback will kick in as well
					case 1 :
							drawOrder[_i][$ "item"].Update()
					break;
				}
				_i++
				
			}
			__itemsProcessStep++
		}
		
		ds_priority_destroy(_prio)
		
	}
	
	/// @func SetValue
	/// @desc set the value to read from
	/// @params {relative to element} value the value to read
	/// @params {bool} play the element feedback (default : true)
	static SetValue = function(_value, _autofeedback = true){
		
		value = _value
		activeItem = itemsList[value][$ "item"]
		
		if _autofeedback{	
			if feedbackIsEnabled{
				__feedbackPlayOnValue()
			}
			if itemFeedbackIsEnabled{
				activeItem.FeedbackPlay()
			}
		}
	}
	
	/// @func ItemFeedbackPlay
	/// @desc Play the feedback assign to the items of the caroussel
	static ItemFeedbackPlay = function(){
		if itemFeedbackIsEnabled{
			activeItem.FeedbackPlay()
		}
		
		return self
	}
	
	/// @func AddItem(name, sprite)
	/// @desc Add an Item, a sprite, to the caroussel
	/// @param {string} name the name for the item
	/// @param {sprite} sprite the sprite to use
	/// @param {real} position NOT USED (yet)
	static AddItem = function(_sprite, _name = "Item"+string(array_length(itemsList)), _pos = undefined){

		__add( _sprite, _name, _pos)
		return self
	}
	
		/// @func SetFeedback(feedback)
	/// @desc set the feedback that will be played when the value changes
	/// @params {string} feedback name of the feedback as a string (default : popout)
	static SetFeedback = function(_name, _targetItem = false ){
		if _targetItem{
			
			var _i = 0; repeat(carousselSize){
				with(itemsList[_i][$ "item"]){
					feedback.Set(_name)
					feedbackIsEnabled = true
					
				}
				
				_i++
			}
			return self
		}
		
		feedback.Set(_name)
		
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
	
	
	/// @func Update
	/// @desc Update the Caroussel - Must be executed each step
	static Update = function(){
		if (feedbackIsEnabled){
			feedback.__play();
		}
		
		if (__anyUpdated){
			__update();
		}
		
		__buildItem()
	}
	
	/// @func Draw()
	/// @desc Draw the caroussel - Must be executed each step
	static Draw = function(){
		
		if !isHidden {
			
			var _i=0;repeat(carousselSize){
				
				if drawOrder[_i] != undefined{
					drawOrder[_i][$ "item"].Draw()
				}
				_i++
				
			}
		}
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
	}
	
	//bib = new Bib()
}

/// @func __CarousselItemElement
/// @desc Internal - GraphicElement Item
/// @param {sprite} sprite
/// @param {string} name
/// @param {real} index
/// @param {int} parent caroussel
function __CarousselItemElement(_sprite, _name, _pos, _owner) : JabbaGraphicElement(_sprite, _name) constructor {
	caroussel = _owner
	ID = _pos
	
	static SetValue = function(){
		if __isReach && feedbackIsEnabled{
			with(feedback){
				if run {
					__reset()
				}
				else run = true
			}
		}
	}
}

#endregion