#macro ENABLE_BIBFORTUNA true
//#macro __INIT_BIBFORTUNA bib = new Bib() ; static drawBib = function(){bib.Draw()} ; static updateBib = function(){bib.Update()}

function Bib() constructor {
    
    owner = other
	
    activeFortuna = []
    
    
    
    CreateFortuna = function(_name, _array){
        var _fortuna = new Fortuna(owner, , ,_array)
        variable_struct_set(self, _name, _fortuna)
    }
    
    TellFortuna = function(_name, _value){
        var _fsm = variable_struct_get(self, _name)
        var _fortuna = new Fortuna(owner, self, _fsm, _value)
        array_push(activeFortuna, _fortuna)
		_fortuna.index = array_length(activeFortuna)-1
    }
    
    spawnMalus = [
        function(_self){
            _self.alpha = 0
            _self.yy = owner.y
			_self.yend = owner.y - 16
            _self.state = 1
			_self.time = 0
            //Tween(InstanceVar("alpha"), 1, 50, ["type", te_quartic_in])
        },
        function(_self){
			_self.time += 0.05
            _self.y = tween(_self.yy, _self.yend, _self.time, EASE.OUT_QUART)
            if _self.y = _self.yend{
                _self.state = 2
            }
        }]
    
    static Update = function(){
        var _i = 0; repeat(array_length(activeFortuna)){
            activeFortuna[_i]._update()
        }
    }
    
    static Draw = function(){
        var _i = 0; repeat(array_length(activeFortuna)){
            activeFortuna[_i]._draw()
        }
    }
}

function Fortuna(_element, _bib, _array, _value, _type = asset_font) constructor{
    state = 0
    value = _value
    x = _element.x
    y = _element.y
    bib = _bib
    //asset
    //alpha
    //color
    
   static __cleanup = function(_me = self){
        
		array_delete(bib.activeFortuna, index,1)
		delete _me
		
   }
    array_push(_array, __cleanup)
    
    fsm = _array
    
    static _update = function(_state = state, _me = self){
        fsm[_state](_me)
    }
    
	if _type = asset_font{
        static _draw = function(_x = x, _y = y){
            draw_text(x,y,value)
        }
    }
   //static _defineDraw = function(_type){
   //    if _type = asset_font{
   //        return function(){
   //            draw_text(x,y,value)
   //        }
   //    }
   //}
   //
   //_draw = _defineDraw(_type)
}

//playerHud.harmonicCounter.TellFortuna("spawnMalus")