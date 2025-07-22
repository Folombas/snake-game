Snake = {
    body = {},           -- Сегменты змейки
    direction = "right", -- Направление движения
    nextDirection = "right"
}

function Snake:init(game)
    -- Начальная позиция змейки
    local startX = math.floor(game.width / 2)
    local startY = math.floor(game.height / 2)

    self.body = {
        { x = startX,     y = startY },
        { x = startX - 1, y = startY },
        { x = startX - 2, y = startY }
    }
    self.direction = "right"
    self.nextDirection = "right"
end

function Snake:update(game)
    -- Обновление направления
    self.direction = self.nextDirection

    -- Сохранение позиции головы
    local head = { x = self.body[1].x, y = self.body[1].y }

    -- Перемещение головы
    if self.direction == "right" then
        head.x = head.x + 1
    elseif self.direction == "left" then
        head.x = head.x - 1
    elseif self.direction == "up" then
        head.y = head.y - 1
    elseif self.direction == "down" then
        head.y = head.y + 1
    end

    -- Проверка границ
    if head.x < 0 or head.x >= game.width or head.y < 0 or head.y >= game.height then
        game.state = "game_over"
        return
    end

    -- Добавление новой головы
    table.insert(self.body, 1, head)

    -- Удаление хвоста
    table.remove(self.body, #self.body)
end

function Snake:draw(game)
    -- Отрисовка змейки
    for i, segment in ipairs(self.body) do
        local color = (i == 1) and { 0, 1, 0 } or { 0, 0.8, 0 } -- Голова зеленее
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            segment.x * game.gridSize,
            segment.y * game.gridSize,
            game.gridSize - 1,
            game.gridSize - 1
        )
    end
end

function Snake:changeDirection(key)
    -- Изменение направления с проверкой на противоположное
    if key == "right" and self.direction ~= "left" then
        self.nextDirection = "right"
    elseif key == "left" and self.direction ~= "right" then
        self.nextDirection = "left"
    elseif key == "up" and self.direction ~= "down" then
        self.nextDirection = "up"
    elseif key == "down" and self.direction ~= "up" then
        self.nextDirection = "down"
    end
end

function Snake:checkFoodCollision(food)
    return self.body[1].x == food.x and self.body[1].y == food.y
end

function Snake:checkSelfCollision()
    -- Проверка столкновения головы с телом
    for i = 2, #self.body do
        if self.body[1].x == self.body[i].x and self.body[1].y == self.body[i].y then
            return true
        end
    end
    return false
end

function Snake:grow()
    -- Добавление нового сегмента в конец
    local tail = self.body[#self.body]
    table.insert(self.body, { x = tail.x, y = tail.y })
end

return Snake
