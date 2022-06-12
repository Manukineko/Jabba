function Bib() constructor {
    
    owner = other
    x = other.x
    y = other.y

    activeFortuna = ds_list_create()
    cleaningList = ds_queue_create()
    fortunaTold = false
    
    static CreateFortuna = function(_name, _array, _self = self){
    	
    	ds_map_add(global.__jabbaBibFortunaList, _name,  _array)
      
    }
    
    static TellFortuna = function(_name, _value){
    
        var _fortuna = new Fortuna(owner, self, _name, _value)
        ds_list_add(activeFortuna, _fortuna)
		_fortuna.index = ds_list_size(activeFortuna)-1
    }
    
    static Update = function(){
        var _i = 0; repeat(ds_list_size(activeFortuna)){
            activeFortuna[| _i]._update()
            _i++
        }
    }
    
    static Draw = function(){
        var _i = 0; repeat(ds_list_size(activeFortuna)){
            activeFortuna[| _i]._draw()
            _i++
        }
    }
    
    static CleanUp = function(){
    	if fortunaTold{
        	
        	var _i = 0; repeat(ds_list_size(activeFortuna)){
    			if activeFortuna[| _i].shutUp{
    				delete activeFortuna[| _i]
					ds_queue_enqueue(cleaningList, _i)
    			}
				_i ++
        	}
			
			while !ds_queue_empty(cleaningList){
        		var _q = ds_queue_dequeue(cleaningList)
        		ds_list_delete(activeFortuna, _q)
    			show_debug_message("[Fortuna"+string(_q)+"] has shut up !")
        	}
			fortunaTold = false
    	}
    }
}

function Fortuna(_element, _bib, _array, _value, _type = asset_font) constructor{
	
    state = 0;
    value = _value;
    x = _bib.x;
    y = _bib.y;
    fnt = fJabbaFont
    color = c_white
    alpha = 1
    halign = fa_center
    valign = fa_middle
    
    shutUp = false
    
    bib = _bib;
    list = global.__jabbaBibFortunaList
    var _a = ds_map_find_value(list, _array);
    fsm = _a
    
	
    
    static __getFortunaFSM = function(_array){
    	var _fsm = [], _a = ds_map_find_value(global.__jabbaBibFortunaList, _array);
    	array_copy(_fsm, 0, _a , 0, array_length(_a));
    	return _fsm;
    }
    
   static __cleanup = function(){
        show_debug_message("[Fortuna"+string(index)+"] send for cleaning")
        bib.fortunaTold = true
		shutUp = true
		
   }
    array_push(fsm, __cleanup)
    
    
    
    static _update = function(_state = state, _me = self){
	
		fsm[_state](_me)
		
	}
    
	if _type = asset_font{
        static _draw = function(_x = x, _y = y){
        	
        	draw_set_font(fnt)
			draw_set_halign(halign)
			draw_set_valign(valign)
			draw_text_color(x,y,value,color,color,color,color, alpha)
			draw_set_halign(fa_left)
			draw_set_valign(fa_top)
			draw_set_font(-1)
        }
    }
}
