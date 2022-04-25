#macro defaultName "element "+ string(elementsListSize)

#region JABBA CONTAINER
/// @func Jabba
/// @desc Constructor for the HUD container. This is completly optional if you want to manage yours yourself
/// @params {Int} viewport the viewport to assign the HUD to (in case of splitscreen) - Dafault: viewport[0]
/// [TODO] anchor system as well as custom attach points
/// [TODO] Groups. Abilities to group elements together so they can be manipulate together (position, rotation, etc)
function JabbaContainer(_viewport = 0) constructor {
	
	x = x
	y = y
	
	// Array holding all the Elements
	elementsList = [];
	elementsListSize = 0
	isHidden = false
	viewport = _viewport
	
	width = view_get_wport(_viewport)
	height = view_get_hport(_viewport)
	x = view_get_xport(_viewport)
	y = view_get_yport(_viewport)
	
	margin = {}
	with(margin){
		top = 0
		left = 0
		bottom = 0
		right = 0
	}
	
	top = view_get_yport(_viewport) + margin.top
	left = view_get_xport(_viewport) + margin.left
	middle = height/2
	center = width/2
	bottom = height - margin.bottom
	right = width - margin.right
	//
	var _owner = other;
	__theHud = {};
	with (__theHud){
		owner = _owner;
		// Internal function to add an element in Jabba's elements list
		__addElement = method(other, function(_element, _index){
			var _list = elementsList
			
			with (__theHud){
				if is_undefined(_index){
					array_push(_list, _element)
				}
				else{
					array_set(_list, _index, _element)	
				}
				other.elementsListSize = array_length(_list)
				return _element
			}
		})
	}
		
		//MAYBE LATER if perf are shiesse
		//__buildDrawList = method(other, function(){
		//	var _list = elementList
		//	with(__theHud){
		//		var _i = 0; repeat(array_length(_list)){
		//			if _list[_i].isHidden = false
		//		}
		//	}
		//})
		//
		
	static __setAnchor = function(){
	
		top 	= view_get_yport(viewport) + margin.top
		left	= view_get_xport(viewport) + margin.left
		middle	= height/2
		center	= width/2
		bottom	= height - margin.bottom
		right	= width - margin.right
	}
	
	
	//Public Methods
	//Each have a Name and Index optional parameter.
	
	/// @func CreateCounterElement()
	/// @desc create a Count element constructor and store it in the HUD
	static CreateCounterElement = function(_limit, _index = undefined, _name = defaultName){
		var _element = new JabbaCounterElement(_limit, _name)

		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
		//
	}
	
	/// @func CreateQuotaCounterElement()
	/// @desc create a Quota Element constructor and store it in the HUD	
	static CreateQuotaCounterElement = function(_index = undefined, _name = defaultName){
		var _element = new JabbaQuotaCounterElement(_name)

		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
		//
	}
	
	/// @func CreateQuotaCounterExtElement()
	/// @desc create an Extended Quota Element constructor and store it in the HUD	
	static CreateQuotaCounterExtElement = function(_index = undefined, _name = defaultName){
		var _element = new JabbaQuotaCounterExtElement(_name)

		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
		//
	}
	
	/// @func CreateTimerElement()
	/// @desc create a Timer element constructor and store it in the HUD	
	static CreateTimerElement = function(_index = undefined, _name = defaultName){
		var _element = new JabbaTimerElement(_name)
		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
	}
	/// @func CreateGaugeBarElement(maxValue)
	/// @desc create a Timer element constructor
	/// @param {real} maxValue the maximum value (In order to calculate the bar progression)
	static CreateGaugeBarElement = function(_maxValue, _index = undefined, _name = defaultName){
		var _element = new JabbaGaugeBarElement(_maxValue, _name)
		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
	}
	
	/// @func CreateCarrouselElement()
	/// @desc create an empty Caroussel Element constructor
	/// @param {real} maxValue the maximum value (In order to calculate the bar progression)
	static CreateCarrouselElement = function(_index = undefined, _name = defaultName){
		var _element = new JabbaCarousselElement(_name)
		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
	}
	
	/// @func CreateGraphicElement()
	/// @desc create a sprite Element constructor
	/// @param {sprite} sprite
	static CreateGraphicElement = function(_sprite, _index = undefined, _name = defaultName){
		var _element = new JabbaGraphicElement(_sprite, _name)
		with(__theHud){
			__addElement(_element, _index)
		}
		return _element
	}
	
	/// @func SetMargin
	/// @desc Set a margin for the whole HUD
	/// @param {integrer} Top
	/// @param {integrer} Left
	/// @param {integrer} Bottom
	/// @param {integrer} Right
	static SetMargin = function(_top, _left = undefined, _bottom = undefined, _right = undefined){
		if is_undefined(_left){
				_left = _top
				_right = _top
				_bottom = _top
			
		}
		if is_undefined(_bottom){
			
				_right = _left
				_bottom = _top
				
			
		}
		
		with(margin){
			top = _top
			left = _left
			bottom = _bottom
			right = _right
		}
		
		__setAnchor()
		
		return self
		
	}
	
	static SetViewport = function(_viewport){
		viewport = _viewport
		
		width = view_get_wport(_viewport)
		height = view_get_hport(_viewport)
		x = view_get_xport(_viewport)
		y = view_get_yport(_viewport)
		
		__setAnchor()
		
		return self
		
	}
	
	/// @func ToggleHide()
	/// @desc toggle the element's isHidden variable to bypass drawing
	static ToggleHide = function(){
		
		isHidden = !isHidden
		
		return self
	}
	
	/// @func Hide()
	/// @desc Hide or Unhide the whole HUD
	/// @param {bool} boolean
	static Hide = function(_bool){
		isHidden = _bool
		
		return self
	}
	
	static Update = function(){
		var _i=0;repeat(array_length(elementsList)){
			elementsList[_i].Update()
			_i++
		}
	}
	
	/// @func Draw()
	/// @desc Draw all the elements if their internal isHidden variable is true
	static Draw = function(){
		if !isHidden{
			var _i=0;repeat(array_length(elementsList)){
				elementsList[_i].Draw()
				_i++
			}
		}
	}

	/// @func FeedbackPlayer()
	/// @desc it will play whatever automatic feedback setup in an element - MUST BE executed each frame if you want Jabba to manage this feature for you.
	static FeedbackPlayer = function(){
		var _i=0;repeat(array_length(elementsList)){
			elementsList[_i].feedback()
			_i++
		}
	}
	
	
}
#endregion