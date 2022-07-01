#macro JABBA_VERSION "0.4.1"
#macro JABBA_CREATOR_MOOD "Not Very Confident"
show_debug_message("You're using JABBA version "+JABBA_VERSION + " - Created by a "+JABBA_CREATOR_MOOD+ " Manukineko")

// Change this if you want different Default Fonts
#macro JabbaFontDefault fJabbaFont
#macro JabbaBitmapFontDefault JabbaFont

//DO NOT MODIFY ANYTHING AFTER THIS LINE (It will explode)
// __________________________________________________________ <- THIS LINE, THERE !

//Element Type
enum ELEMENT{
	BASE,
	COUNTER,
	QUOTA,
	TIMER,
	GAUGE,
	CAROUSSEL,
	GRAPHIC,
	TEXT, //not implemented yet
	SIZE
}

// Base Element Type Sprite
//Virtual Origin Template
#macro TopLeft [0,0]
#macro TopCenter [0,0.5]
#macro TopRight [0,1]
#macro MiddleLeft [0.5, 0]
#macro MiddleCenter [0.5, 0.5]
#macro MiddleRight [0.5, 1]
#macro BottomLeft [1, 0]
#macro BottomCenter [1, 0.5]
#macro BottomRight [1, 1]

// Timer Element
//Time Unit to use to set the time format
	enum JT{
		DAYS,
		HOURS,
		MIN,
		SEC,
		HUN
	}

__Jabba_Initialize()
function __Jabba_Initialize() {
//	
//	global.__jabbaFeedbacksList = ds_map_create()
//	//Jabba Feedback List HERE
//	
//	ds_map_add(global.__jabbaFeedbacksList, "none", [
//		method(undefined, function(){
//			return
//		})
//	])
//	
//	ds_map_add(global.__jabbaFeedbacksList, "flash", [
//		method(undefined, function(){
//			state++;
//			time = 0
//			color = c_red
//			owner.ChangeColor(color)
//		}),
//		method(undefined, function(){
//			//time++
//			if time > 15{
//				Complete()
//				owner.ChangeColor()
//			} else time++
//		}),
//	])
//	ds_map_add(global.__jabbaFeedbacksList, "highlightItem", [
//		method(undefined, function(){
//			state++;
//			time = 0
//			val = true
//		}),
//		method(undefined, function(){
//			if owner.caroussel.activeItem.ID = owner.ID{
//				if val{
//					owner.ChangeColor(owner.caroussel.colorBlendActive)
//					val = false
//				}
//			}
//			else{
//				owner.ChangeColor(owner.caroussel.colorBlendDefault)
//				Complete()
//			}
//		}),
//	])
//	
//	ds_map_add(global.__jabbaFeedbacksList, "popout", [
//		method(undefined, function(){
//			scale = 2
//			time = 0
//			state++
//		}),
//		method(undefined, function(){
//			time += 0.1
//			scale = tween(2,1,time,EASE.INOUT_CUBIC)
//			owner.SetScale(scale, scale)
//			if scale <= 1 {
//				Complete()
//			}
//		})
//	])
//	ds_map_add(global.__jabbaFeedbacksList, "flipOnce", [
//		method(undefined, function(){
//			time = 0
//			xscale = 1
//			maxscale = 1
//			state++
//		}),	
//		method(undefined, function(){
//			xscale = tween(maxscale,0, time, EASE.OUT_CUBIC)
//			if xscale <= 0 {state++ ; time = 0;}
//			time += 0.1
//			owner.SetScale(xscale,1)
//		}),
//		method(undefined, function(){
//			xscale = tween(0,maxscale, time, EASE.OUT_CUBIC);
//			if xscale >= 1 {Complete()}
//			time += 0.1
//			owner.SetScale(xscale,1)
//		})
//	])
//	ds_map_add(global.__jabbaFeedbacksList, "radiusPopout", [
//		method(undefined, function(){
//			radius = 32
//			animate = true
//			time = 0
//			state++
//		}),
//		method(undefined, function(){
//			if animate{
//				time += 0.1
//				radius = tween(32,0,time,EASE.SMOOTHSTEP)
//				owner.wRadius = owner.width + radius
//				owner.hRadius = owner.height + radius
//				//owner.SetRadius(owner.width+radius, owner.height+radius)
//				if time = 1 {
//					Complete()
//					animate = false
//				}
//			}
//		})
//	])
	
	global.__jabbaBibFortunaList = ds_map_create()
	ds_map_add(global.__jabbaBibFortunaList, "spawnMalus", [
    method(undefined,function(){
            alpha = 0
            yy = y
			yend = y - 16
            state = 1
			time = 0
			shutUp = false
			show_debug_message("[Fortuna"+string(index)+"] Initialisation")
    }),
    method(undefined,function(){
			time += 0.05
            y = tween(yy, yend, time, EASE.OUT_QUART)
            alpha = tween(0, 1, time*4, EASE.IN_QUART)
            show_debug_message("[Fortuna"+string(index)+"] Animate "+string(time))
            if y = yend{
                state = 2
                
            }
    }),
    method(undefined,function(){
    	time += 0.05
    	alpha = tween(1, 0, time, EASE.IN_QUART);
    	if alpha <= 0 {
    		state = 3;
    		show_debug_message("[Fortuna"+string(index)+"] Animate END")
    	} 
    })
])
	
}  