/// @func JabbaContainer
/// @desc Constructor for the HUD container. This is completly optional if you want to manage yours yourself
/// @desc The container has a grid feature you can use in order to quickly set the position of each Element.
/// @params {Int} viewport the viewport to assign the HUD to (in case of splitscreen) - Default: viewport[0]
/// [TODO] Groups. Abilities to group elements together so they can be manipulate together (position, rotation, etc)
function JabbaContainer(_viewport = 0) constructor {
	
	owner = other
	
	width = view_get_wport(_viewport)
	height = view_get_hport(_viewport)
	x = view_get_xport(_viewport)
	y = view_get_yport(_viewport)
	
	// Array holding all the Elements
	elementsList = [];
	elementsListSize = 0
	isHidden = false
	viewport = _viewport
	
	
	
	
	//grids Feature
	margin = {
		top : 0,
		left : 0,
		bottom : 0,
		right : 0
	}
	
	// Set a Grid with 9-points that you can refer later when you position an Element, using `myContainer.top`
	top = view_get_yport(_viewport) + margin.top
	left = view_get_xport(_viewport) + margin.left
	middle = height/2
	center = width/2
	bottom = height - margin.bottom
	right = width - margin.right
	
#region	/**************************** Internal Methods **********************************/
	/// @func __addElement
	/// @desc [Internal] Add an Element to the elementsList array and increment the elementsListSize
	/// @param {struct} Element from the Element Constructors function
	static __addElement = function(_element){
		array_push(elementsList, _element)
		elementsListSize++
		return _element
	}
	
	/// @func __setGrid
	/// @desc Set a 4-cells (or 9-Points) Grid based on the Margins. 
	static __setGrid = function(){
	
		top 	= view_get_yport(viewport) + margin.top
		left	= view_get_xport(viewport) + margin.left
		middle	= height/2
		center	= width/2
		bottom	= height - margin.bottom
		right	= width - margin.right
	}
#endregion /*****************************************************************/
	
#region /****************************  Public Methods  **********************************/ 
	//Each have a Name and Index optional parameter.
	
	/// @func CreateCounterElement()
	/// @desc create a Count element constructor and store it in the HUD
	static CreateCounterElement = function(_limit, _name = "Counter", _index = undefined){
		var _element = new JabbaCounterElement(_limit, _name)

		return __addElement(_element)
	}
	
	/// @func CreateQuotaCounterElement()
	/// @desc create a Quota Element constructor and store it in the HUD	
	static CreateQuotaCounterElement = function(_name = "Quota Counter", _digitsLimit = 9, _index = undefined){
		var _element = new JabbaQuotaCounterElement(_name, _digitsLimit)

		return	__addElement(_element)
	}
	
	/// @func CreateQuotaCounterExtElement()
	/// @desc create an Extended Quota Element constructor and store it in the HUD	
	static CreateQuotaCounterExtElement = function(_name = "Quota Counter EXT", _digitsLimit = 9, _index = undefined){
		var _element = new JabbaQuotaCounterExtElement(_name, _digitsLimit)

		return	__addElement(_element)


	}
	
	/// @func CreateTimerElement()
	/// @desc create a Timer element constructor and store it in the HUD	
	static CreateTimerElement = function(_name = "Timer", _index = undefined){
		var _element = new JabbaTimerElement(_name)
		return	__addElement(_element)

	}
	/// @func CreateGaugeBarElement(maxValue)
	/// @desc create a Timer element constructor
	/// @param {real} maxValue the maximum value (In order to calculate the bar progression)
	static CreateGaugeBarElement = function(_maxValue, _asset, _mask, _shader,  _name = "Gauge Bar", _index = undefined){
		var _element = new JabbaGaugeBarElement(_maxValue, _asset, _mask, _shader, _name)
		return	__addElement(_element)

	}
	
	/// @func CreateCarrouselElement()
	/// @desc create an empty Caroussel Element constructor
	/// @param {real} maxValue the maximum value (In order to calculate the bar progression)
	static CreateCarrouselElement = function(_name = "Caroussel", _index = undefined){
		var _element = new JabbaCarousselElement(_name)
		return	__addElement(_element)
	}
	
	/// @func CreateGraphicElement()
	/// @desc create a simple Sprite Element
	/// @param {sprite} sprite
	static CreateGraphicElement = function(_sprite, _name = "Graphic", _index = undefined){
		var _element = new JabbaGraphicElement(_sprite, _name)
		return	__addElement(_element)

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
		
		margin.top = _top
		margin.left = _left
		margin.bottom = _bottom
		margin.right = _right
		
		// Recalculate the Grid
		__setGrid()
		
		return self
		
	}
	
	/// @func SetViewport
	/// @desc Change the viewport assign to the Jabba Container
	/// @param {int} viewportID
	static SetViewport = function(_viewport){
		viewport = _viewport
		
		width = view_get_wport(_viewport)
		height = view_get_hport(_viewport)
		x = view_get_xport(_viewport)
		y = view_get_yport(_viewport)
		
		//Recalculate the Grid
		__setGrid()
		
		return self
		
	}
	
	/// @func ToggleHide()
	/// @desc toggle all the element's visibility. Drawing is bypassed.
	static ToggleHide = function(){
		
		isHidden = !isHidden
		
		return self
	}
	
	/// @func Hide()
	/// @desc Hide or Unhide the whole HUD. Drawning is bypassed
	/// @param {bool} boolean
	static Hide = function(_bool){
		isHidden = _bool
		
		return self
	}
	
	/// @func Update
	/// @desc Update all the Elements. Must be called each step.
	static Update = function(){
		var _i=0;repeat(array_length(elementsList)){
			elementsList[_i].Update()
			_i++
		}
	}
	
	/// @func Draw()
	/// @desc Draw all the elements if their internal isHidden variable is true. Must be called in the Draw GUI Event.
	static Draw = function(){
		if !isHidden{
			var _i=0;repeat(array_length(elementsList)){
				elementsList[_i].Draw()
				_i++
			}
		}
	}
	
	/// @func CleanUp
	/// @desc [Bib Fortuna] If you use Bib Fortuna, you must call it after drawing (Begin Step or Post Draw)
	static CleanUp = function(){
		var _i=0;repeat(array_length(elementsList)){
			elementsList[_i].CleanUp()
			_i++
		}
	}
	
}
#endregion