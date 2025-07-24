Snake = {
    position = {},
    direction = "right",
    nextDirection = "right",
    length = 3,
    timer = 0,
    speed = 0.1,
    colors = {
        head = { 0.2, 0.8, 0.2 }, -- Зеленый для головы
        body = { 0.4, 0.9, 0.4 } -- Светло-зеленый для тела
    }
}

function Snake.init()
    Snake.position = {}
    for i = 1, Snake.length do
        table.insert(Snake.position, { x = i, y = 1 })
    end
    Snake.direction = "right"
    Snake.nextDirection = "right"
    Snake.length = 3
    Snake.timer = 0
end

function Snake.update(dt)
    Snake.timer = Snake.timer + dt
    if Snake.timer > Snake.speed then
        Snake.timer = 0
        Snake.move()
    end
end

function Snake.move()
    Snake.direction = Snake.nextDirection

    local newHead = { x = Snake.position[#Snake.position].x, y = Snake.position[#Snake.position].y }

    if Snake.direction == "right" then
        newHead.x = newHead.x + 1
    elseif Snake.direction == "left" then
        newHead.x = newHead.x - 1
    elseif Snake.direction == "down" then
        newHead.y = newHead.y + 1
    elseif Snake.direction == "up" then
        newHead.y = newHead.y - 1
    end

    table.insert(Snake.position, newHead)
    table.remove(Snake.position, 1)
end

function Snake.changeDirection(key)
    if key == "right" and Snake.direction ~= "left" then
        Snake.nextDirection = "right"
    elseif key == "left" and Snake.direction ~= "right" then
        Snake.nextDirection = "left"
    elseif key == "down" and Snake.direction ~= "up" then
        Snake.nextDirection = "down"
    elseif key == "up" and Snake.direction ~= "down" then
        Snake.nextDirection = "up"
    end
end

function Snake.grow()
    table.insert(Snake.position, 1, Snake.position[1])
    Snake.length = Snake.length + 1
end

function Snake.draw()
    for i, segment in ipairs(Snake.position) do
        local isHead = (i == #Snake.position)

        -- Устанавливаем цвет: голова и тело
        if isHead then
            love.graphics.setColor(Snake.colors.head)
        else
            love.graphics.setColor(Snake.colors.body)
        end

        -- Рисуем прямоугольник с закругленными углами
        local radius = 4
        if isHead then
            radius = 7
        end
        love.graphics.rectangle("fill",
            (segment.x - 1) * Game.gridSize,
            (segment.y - 1) * Game.gridSize,
            Game.gridSize, Game.gridSize, radius)
    end

    -- Сбрасываем цвет на белый
    love.graphics.setColor(1, 1, 1)
end

function Snake.checkWallCollision()
    local head = Snake.position[#Snake.position]
    local width = love.graphics.getWidth() / Game.gridSize
    local height = love.graphics.getHeight() / Game.gridSize

    return head.x < 1 or head.x > width or head.y < 1 or head.y > height
end

function Snake.checkSelfCollision()
    local head = Snake.position[#Snake.position]
    for i = 1, #Snake.position - 1 do
        if head.x == Snake.position[i].x and head.y == Snake.position[i].y then
            return true
        end
    end
    return false
end

function Snake.checkFoodCollision(foodPos)
    local head = Snake.position[#Snake.position]
    return head.x == foodPos.x and head.y == foodPos.y
end
