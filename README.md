# Doom-Fire
Doom fire effect made with [_Löve2D_](https://love2d.org/)

## How it works?
firsts things first, you need to know a bit of [lua](https://www.lua.org/) (try this [quick tutorial](https://www.tutorialspoint.com/lua/lua_quick_guide.htm))


#### So... how Löve2D works?
In main.lua file we need to declare some functions that the Löve2D will call by himself:

> `function love.load() end`
> A function called once when the program start.


> `function love.update() end`
> A function in a loop and called every time

> `function love.draw() end`
> A function with calling synchronized with framerate

### And how the effect works?
We will begin with the _love.load_:
```lua
function love.load() --Declare function
    local width, height = love.window.getMode( ) --Get the size of window

    --4 is the size of our "pixel" 8 are the sum of borders
    rowSize = math.floor(width/4)-8
    columnSize = math.floor(height/4)-8
    gridSize = columnSize*rowSize
    
    --"Pixels" colors that we will use to draw the fire
    Colors = {}
    Colors.ref = love.graphics.newImage("colors.png") --Load an image
    for i=0,35 do --We have 36 colors to represent intensity
      
      --Quads are a part of an original image
      Colors[i] = love.graphics.newQuad(
        ( ( i * 24 ) + i ), 0, --X and Y of the color that we want
        4, 4, --Both 4 are the size of our "pixel" again
        Colors.ref:getDimensions()
      )
    end
    
    --This grid represents the fire
    Grid = {}
    for i=1,gridSize do
        Grid[i] = 36
    end
end
```
With this we already have our fire but let's _draw_ this on the screen:
```lua
function love.draw() --Let's draw something
  --We need to catch every pixel in Grid (its index and intensity)
  for index, force in ipairs(Grid) do
    
    --The rest of division of the pixel's index by
    --  the rowSize is his position in its row
    local x = (index % rowSize)*4 --4 is the pixel size
    
    --The result of division of the pixel's index by
    --  the rowSize is the row that it is in but
    --a division can return fraction and we don't want it
    -- then I use math.floor( ) to round the result
    local y = math.floor( (  index  -  1  )  /  rowSize ) * 4 --4 is the pixel size again
    
    --Then finally we draw the pixel on the screen 
    love.graphics.draw(Colors.ref, Colors[force], x, y)
  end
end
```
If you execute the code that We wrote then will get just a static white window, then let's animate whit love.update:
```lua
--Timer is a global variable
--usually isn't a good pratice
--but we don't want anything too complex
--so this works fine
Timer = 0

--dt is the delta time between tha last and current call of update()
function love.update(dt)

  Timer = Timer + dt

  --This is the easiest way to do something like sleep()
  if Timer >= 0.05 then

    --Finally let's put fire on the screen
    for index in ipairs(Grid) do

      --If the pixel is in the first row
      if index  <=  rowSize then

        --We take the below pixel
        index = index + rowSize
      end

      --Taking a random value will enable us to do a effect really good
      local decay = math.random(0, 1)

      --To have the decay effect then the force of current pixel
      --  will be the force of below pixel less the decay
      local force = Grid[ index - rowSize ] - decay

      --Make sure that force is bigger than 1
      if force < 1 then force = 1 end
      --and smaller than 36
      if force > 36 then force = 36 end

      --If you want just a random decay of a pixel
      --  on below pixel then add something like:
      --"local Grid[index] = force"
      --But just a random decay ins't enough
      --We want to write something like wind
      --This must be complex right?
      --Spoiler: No.
      --To do this just put a chance of
      --  a pixel to affect its neighborn and not
      --  just the below pixel
      Grid[index - decay] = force
    end
    Timer = 0 --Don't forget to reset the timer
  end
end
```
And now you get an upside down fire and it is more cool than a normal fire, right?
What?? Why not??? :(
Okay you win, let's fix this...

We have multiples ways to do this but I choose add one line to _love.draw_:
```lua
function love.draw()
  for index, force in ipairs(Grid) do
    --Here if we invert the index we can upside down
    --  the Grid order, just subtract the actual index from
    --  Grid's total length
    index = #Grid - index

    local x = ( index % rowSize ) * 4
    local y = math.floor(  (  index  -  1  )  /  rowSize )  *  4
    love.graphics.draw(Colors.ref, Colors[force], x, y)
  end
end
```

And now works, see the [complete code here](https://github.com/BRonen/Doom-Fire/blob/main/main.lua) :)
