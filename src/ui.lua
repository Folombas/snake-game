UI = {
    font = nil
}

function UI:init(game)
    -- Загрузка шрифта с поддержкой кириллицы
    local fontPath = "assets/fonts/Roboto-VariableFont_wdth,wght.ttf"

    -- Проверка существования файла шрифта
    local fontInfo = love.filesystem.getInfo(fontPath)
    if fontInfo then
        self.font = love.graphics.newFont(fontPath, 24)
    else
        -- Если файл не найден, используем системный шрифт
        print("Предупреждение: Шрифт не найден - " .. fontPath)
        self.font = love.graphics.newFont(24)
    end
end

function UI:draw(game)
    love.graphics.setFont(self.font)

    -- Отображение счета
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Счет: " .. game.score, 10, 10)
    love.graphics.print("Рекорд: " .. game.highScore, 10, 40)

    -- Сообщения в зависимости от состояния
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    if game.state == "menu" then
        love.graphics.printf("ЗМЕЙКА", 0, 200, windowWidth, "center")
        love.graphics.printf("Нажмите ПРОБЕЛ для старта", 0, 300, windowWidth, "center")
    elseif game.state == "game_over" then
        love.graphics.printf("ИГРА ОКОНЧЕНА!", 0, 200, windowWidth, "center")
        love.graphics.printf("Ваш счет: " .. game.score, 0, 250, windowWidth, "center")
        love.graphics.printf("Нажмите ПРОБЕЛ для рестарта", 0, 300, windowWidth, "center")
    end

    -- Управление
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Управление: Стрелки", 10, windowHeight - 30)
end

return UI
