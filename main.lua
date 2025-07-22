function love.load()
    require("src.game") -- Загружаем игровую логику
    Game:init()         -- Инициализируем игру
end

function love.update(dt)
    Game:update(dt) -- Обновление состояния игры
end

function love.draw()
    Game:draw() -- Рисуем игровое поле
end

function love.keypressed(key)
    Game:keypressed(key) -- Обрабатываем нажатие клавиш
end
