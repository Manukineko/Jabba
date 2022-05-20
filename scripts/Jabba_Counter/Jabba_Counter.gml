// A simple element that will play a feedback when a value change. Basically, it just display a string.
#region COUNTER ELEMENT
/// @func JabbaCounterElement(_limit, _name)
/// @desc a simple counter. it will display the value with a feedback when it changes.
/// @param {int}limit
/// @param {string} name
function JabbaCounterElement(_limit = 10, _name = "Counter") : __fontTypeElement__() constructor{
	
	name = _name
	limit = _limit
	asset = fJabbaFont
	
	feedback = __feedbacks.popout.func
	__activeFeedback = "popout"
	
	halign = fa_center
	valign = fa_middle
	
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
	
	static SetLimit = function(_limit){
		limit = _limit
		
		return self
	}
	
	/// @func Draw()
	/// @desc Draw the element
	 Draw = function(){
		if !isHidden{
			draw_set_font(asset)
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_transformed_color(x,y, value, xScale, yScale, angle, color, color, color, color, alpha )
			draw_set_halign(-1)
			draw_set_valign(-1)
		}
		
		if ENABLE_BIBFORTUNA {
			
			//if array_length(bib.activeFortuna) > 0{
			if ds_list_size(bib.activeFortuna) > 0{
				drawBib()
			}
		}
	}
	
	if ENABLE_BIBFORTUNA{
		bib = new Bib() ;
		static drawBib = function(){
			bib.Draw()
		} ;
		static updateBib = function(){
			bib.Update()
		}
	}
}
#endregion