Food = {
    position = { x = 0, y = 0 },
    color = { 1, 0.2, 0.2 } -- Красный
}

function Food.spawn()
    local w = math.floor(love.graphics.getWidth() / Game.gridSize)
    local h = math.floor(love.graphics.getHeight() / Game.gridSize)

    Food.position = {
        x = math.random(1, w),
        y = math.random(1, h)
    }

    -- Убедимся, что еда не появляется на змейке
    for _, segment in ipairs(Snake.position) do
        if segment.x == Food.position.x and segment.y == Food.position.y then
            return Food.spawn()
        end
    end
end

function Food.draw()
    love.graphics.setColor(Food.color)
    love.graphics.rectangle("fill",
        (Food.position.x - 1) * Game.gridSize,
        (Food.position.y - 1) * Game.gridSize,
        Game.gridSize, Game.gridSize, 5)
    love.graphics.setColor(1, 1, 1)
end
