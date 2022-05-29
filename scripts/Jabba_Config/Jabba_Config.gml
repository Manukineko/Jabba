#macro JABBA_VERSION "0.4.1"
#macro JABBA_CREATOR_MOOD "Not Very Confident"
var _s = ENABLE_BIBFORTUNA ? "ON" : "OFF"
show_debug_message("You're using JABBA version "+JABBA_VERSION + " - Created by a "+JABBA_CREATOR_MOOD+ " Manukineko")
show_debug_message("BibFortuna for Jabba is " + string(_s ))

// Change this if you want different Default Fonts
#macro JabbaFontDefault fJabbaFont
#macro JabbaBitmapFontDefault JabbaFont

//BIB FORTUNA Extension
#macro ENABLE_BIBFORTUNA true

//DO NOT MODIFY ANYTHING AFTER THIS LINE (It will explode)
// __________________________________________________________ <- THIS LINE, THERE !

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