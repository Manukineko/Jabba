# Jabba

A tentative library to easily build simple HUD for Gamemaker Studio 2.3+

**STILL IN DEVELOPMENT - USABLE BUT I'D ADVISE AGAINST USING IT IN PRODUCTION**

## Presentation

Jabba is a kind of a wrapper/helper library to easily setup a HUD for your game/prototype. It comes with severals Type of Elements you can use to build counters, gauge, timer that would monitor a value and, if you wish, would trigger some spark and whistle when a condition (relative to the type of an element) is met.

Each elements can be created as a standalone or stored in a Jabba container which will handle the drawing for you. Useless to say that you can also build your own container if you wish.

Think about it like the kind of HUD you had for 16-bits games, displaying life, score, combo counter, character mugshot, time, etc

### Features

* Graphic Element - Display a sprite asset
* Timer Element - Format and display times
* Counter Element - Display a number
* Quota Counter Element - Display a number and will change its color when the quota is reached
* Quota Counter Ext - Same but the color change gradually by tens of unit.
* Caroussel Element - A caroussel which rotate automatically to display the active item.
* Jabba Container - a container that handle automatically the drawing and feedback effect of each element
* Feedback & custom feedback - a small library of effects to trigger when an element met a condition. You can build yours too.
* Support splitscreen

### Features that won't be

* Interactions with mouse or/and gamepad/ keyboard
* Super fancy & complex animation
* Textbox, dialogue box, menu - for that, you have library like YUI or Bento.
* probably a super optimised library as I am not a programmer and I use it mainly for prototyping my ideas.

## Quick Guide
Using a JabbaContainer (or creating yours) is the recommended use of the library.

### Using the Jabba Container

1. In the Create event of an object

```gml
// create a hud container for the viewport 1 (if you omit the parameter it default to viewport 0)
hud = new Jabba(1)

// add a timer Element to the hud container with the provided method
RaceTimer = hud.CreateTimerElement()
RaceTimer.SetPosition(hud.width/2, 32)
```

2. Change the value

```gml
//Step Event
RaceTimer.SetValue(get_time()/1000)
```

3. In the DRAW GUI event

```gml
hud.Draw()
```

(Optional)
4. In the STEP event

```gml
hud.FeedbackPlayer()
```

### As a standalone element

1. In the CREATE event

```gml
// create a counter element
ComboCounter = new JabbaCounterElement()
ComboCounter.SetPosition(32,32)
```

2. Set the value

```gml
if keyboard_check_pressed(vk_space){
	combo++
	ComboCounter.SetValue(combo)
}

```

3. In the DRAW GUI event

```gml
ComboCounter.Draw()
```

## Wait ! That name ! You don't mean ... ?

You bet !!
Hell Yeah I mean it !!
It's called Jabba because ... **Jabba The HUD**
