#region SPRITE ELEMENT

function JabbaGraphicElement(_sprite, _name = "Graphic",_hud = undefined) : __spriteTypeElement__() constructor{
	
	elementType = ELEMENT.GRAPHIC
	asset = _sprite
	width = sprite_get_width(_sprite)
	height = sprite_get_height(_sprite)
	xFlip = 1
	yFlip = 1
	
	if !is_undefined(_hud) __addToHud(_hud)
	
	
	/// @func SetOffset
	/// @desc Modify the offset of the Element's sprite. Same as changing the sprite's origin in the IDE.
	/// @param {int} xoffset
	/// @param {int} yoffset - optional if you use one of the macro provided in JabbaConfig in the xoffset parameter
	static SetOffset = function(_x, _y = undefined){
		
		var _xoff, _yoff
		if is_array(_x){  
			_y = _x[0]*height
			_x = _x[1]*width
		}

		_xoff = _x
		_yoff = _y
		
		sprite_set_offset(asset, _xoff, _yoff)
		
		return self
	}
	
	/// @func FeedbackPlay
	/// @desc [On Value] Play the Feedback assign to the Element
	static FeedbackPlay = function(){
		if feedbackIsEnabled{
			__feedbackPlayOnValue()
		}
	}
	
	static Draw = function(){
		if !isHidden {
			draw_sprite_ext(asset, frame, x, y, xScale, yScale, angle, color, alpha)
		}
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
	}
}

#endregion