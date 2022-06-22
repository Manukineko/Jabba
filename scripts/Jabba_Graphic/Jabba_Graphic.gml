#region SPRITE ELEMENT

function JabbaGraphicElement(_sprite, _name = "Graphic",_hud = undefined) : __spriteTypeElement__() constructor{

	asset = _sprite
	width = sprite_get_width(_sprite)
	height = sprite_get_height(_sprite)
	xFlip = 1
	yFlip = 1
	
	if !is_undefined(_hud) __addToHud(_hud)
	
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
	
	static FeedbackPlay = function(){
		if enableFeedback{
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