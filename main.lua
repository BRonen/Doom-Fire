local rowSize = 128
local columnSize = 64
local gridSize = columnSize*rowSize

function love.load()
    Debug = false
    
    Colors = {}
    Colors.ref = love.graphics.newImage("colors.png")
    for i=1,36 do
        Colors[i] = love.graphics.newQuad(
            ( ( ( i - 1 ) * 24 ) + i ), 0,
            4, 4,
            Colors.ref:getDimensions()
        )
    end
    
    Grid = {}
    for i=1,gridSize do
        Grid[i] = 36
    end
    
    Callbacks = setKeyCallback()
end

Timer = 0

function love.update(dt)
    Timer = Timer + dt
    if Timer >= 0.05 then
        for i in ipairs(Grid) do
            if i <= rowSize then
                i = i+rowSize
            end
            local decay = math.random(0, 1)
            Grid[i-decay] = Grid[i-rowSize] - decay
        end
        Timer = 0
    end
end

function love.draw()
    for i, force in ipairs(Grid) do
        i = #Grid-i+1
        x = 16 + (i%rowSize)*4
        y = 16 + math.floor((i-1)/rowSize)*4
        if force < 1 then force = 1 end
        if force > 36 then force = 36 end
        love.graphics.draw(Colors.ref, Colors[force], x, y)
    end
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 32, 48)
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 32, 64)
end

function love.keypressed(key)
    love.event.push('quit')
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    love.event.push('quit')
end
