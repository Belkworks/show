
# Show
*A visual debug library for Synapse.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Show = NEON:github('belkworks', 'show')
```
Compatible with [Broom](https://github.com/Belkworks/broom).

## API

### Global Options
- `color` - Color of object (`Color3  = white`)
- `opacity` - Inverse of transparency (`Float 0-1 = 1`)
- `mutex` - Deletes other objects with same mutex (`String`)

### Global Methods

**expire**: `Visual:expire(time) -> nil`  
Destroys `Visual` in `time` seconds.
```lua
V:expire(4)
```

**Destroy**: `Visual:Destroy() -> nil`  
Destroys `Visual`.  
```lua
V:Destroy()
```

## Rays

**Ray**: `Show.Ray(Ray, Options?) -> Ray`  
Create a display on `Ray` with `Options`
```lua
R = Show.Ray(Ray, {
	color = Color3.new(1,0,0)
})
```

### Options
- `showOrigin` - Show a circle where the ray begins (`Boolean = false`)
- `showTermination` - Show an arrow where the ray ends (`Boolean = false`)
- `advanced` - Show origin and termination (`Boolean = false`)

## Vectors

**Vector2**: `Show.Vector2(Vector2, Options?) -> Vector2`  
Creates a display on `Vector2` with `Options`
```lua
V = Show.Vector2(Vector2.new(200, 100), {
	mutex = 'howdy',
	radius = 20
})
```

**Vector3**: `Show.Vector3(Vector3, Options?) -> Vector3`  
Creates a display on `Vector3` with `Options`
```lua
V = Show.Vector3(Vector3.new(20, 80, 20), {
	box = true
})
```

### Methods
**setPosition**: `Vector:setPosition(Point) -> nil`  
Changes the current position of the Vector.
```lua
-- For Vector2
V:setPosition(Vector2.new(100, 300))
-- For Vector3
V:setPosition(Vector3.new(10, 80, 90))
```

### Options
- `box` - Render the point as a box (`Boolean = false`)
- `radius` - Radius of the display (`Number = 5`)

## Text

**Text**: `Show.Text(String, Vector3, Options?) -> Text`  
Creates a text display of `String` at `Vector3`
```lua
V = Show.Text('Hello', Vector3.new(0, 100, 0), {
	size = 14
})
```

### Options
- `font`: Font to render the text with `(Number = 13)`
- `size`: Size of the text `(Font = Monospace)`
- `center`: Whether or not to center the text `(Boolean = false)`
- `outline`: Outline color `(Color3/Boolean = White)`

### Methods
**setPosition**: `Text:setPosition(Vector3) -> nil`  
Changes the current position of the Text.
```lua
V:setPosition(Vector3.new(10, 10, 10))
```
**setText**: `Text:setText(String) -> nil`  
Changes the text displayed.
```lua
V:setText 'hello'
```

## Usage with [Broom](https://github.com/Belkworks/broom)

```lua
B = Broom()
V = Show.Vector2(Vector2.new(100, 200))
B:give(V)
-- later
B:clean() -- V is destroyed
```
