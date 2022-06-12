/// @func JabbaCounterElement(_limit, _name)
/// @desc a simple counter. it will display the value with a feedback when the value changes.
/// @param {int}limit The value limit from which the counter won't update.
/// @param {string} name Giving a name to the Element helps for debugging but can be also used to display it's name in a tutorial.
function JabbaCounterElement(_limit = 10, _name = "Counter") : __fontTypeElement__() constructor{
	
	name = _name
	limit = _limit
	asset = fJabbaFont
	halign = fa_center
	valign = fa_middle
	
	feedback = __feedbacks.popout.func
	__activeFeedback = "popout"
	
	
	// static SetLimit = function(_limit){
	// 	limit = _limit
		
	// 	return self
	// }
	
	/// @func SetTextAlign()
	/// @desc Set the alignement of the text (GML constant fa_*)
	/// @param {constant} halign
	/// @param {constant} valign
	static SetTextAlign = function(_halign, _valign){
		halign = _halign
		valign = _valign
		
		__originUpdated = true
		__anyUpdated = true
		
		return self
	}
	
	/// @func Draw()
	/// @desc Draw the element. Bypassed if isHidden is false
	static Draw = function(){
		if !isHidden{
			draw_set_font(asset)
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_transformed_color(x,y, value, xScale, yScale, angle, color, color, color, color, alpha )
			draw_set_halign(-1)
			draw_set_valign(-1)
		}
		
		with(bib){
			if ds_list_size(activeFortuna) > 0{
				Draw()
			}
		}
	}
}
#endregion