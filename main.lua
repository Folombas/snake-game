function love.load()
    require("src.game")    -- Загружаем игровую логику
    require("src.records") -- Загружаем систему рекордов
    Game:init()            -- Инициализируем игру
end

function love.update(dt)
    Game:update(dt) -- Обновление состояния игры
end

function love.draw()
    Game:draw() -- Отрисовка игры
end

function love.keypressed(key)
    Game:keypressed(key) -- Обработка нажатий клавиш
end

-- Обработчик ошибок для отладки
function love.errorhandler(msg)
    print("Error: " .. msg)
    print(debug.traceback())

    return function()
        love.graphics.clear(0.1, 0.1, 0.1)
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("ERROR: " .. msg, 50, 50, love.graphics.getWidth() - 100, "left")
        love.graphics.present()
    end
end
