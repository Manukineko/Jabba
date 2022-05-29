#region SPRITE ELEMENT

function JabbaGraphicElement(_sprite, _name = "Graphic") : __spriteTypeElement__() constructor{

	asset = _sprite
	width = sprite_get_width(_sprite)
	height = sprite_get_height(_sprite)
	xFlip = 1
	yFlip = 1
	
	//feedback = __feedbacks.popout.func
	//__activeFeedback = "popout"
	
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
	
	static SetColor = function(_color){
		color = _color
		
		return self
	}
	
	static Draw = function(){
		if !isHidden {
			draw_sprite_ext(asset, frame, x, y, xScale, yScale, angle, color, alpha)
		}
	}
}

#endregion