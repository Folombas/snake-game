Food = {
    x = 0,
    y = 0
}

function Food:spawn(game)
    -- Генерация случайной позиции
    self.x = math.random(0, game.width - 1)
    self.y = math.random(0, game.height - 1)

    -- Проверка, чтобы еда не появилась на змейке
    for _, segment in ipairs(game.Snake.body) do
        if segment.x == self.x and segment.y == self.y then
            return self:spawn(game) -- Рекурсия, если позиция занята
        end
    end
end

function Food:draw(game)
    -- Отрисовка еды
    love.graphics.setColor(1, 0, 0) -- Красный цвет
    love.graphics.rectangle(
        "fill",
        self.x * game.gridSize,
        self.y * game.gridSize,
        game.gridSize - 1,
        game.gridSize - 1
    )
end

return Food
