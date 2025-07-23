UI = {
    font = nil,       -- Основной шрифт для текста
    titleFont = nil,  -- Шрифт для заголовков
    arrowUp = nil,    -- Изображение стрелки вверх
    arrowDown = nil,  -- Изображение стрелки вниз
    arrowSize = 32,   -- Размер стрелок в пикселях
    debugMode = false -- Режим отладки
}

function UI:init(game)
    -- Пути к шрифтам
    local regularFontPath = "assets/fonts/Roboto-Regular.ttf"
    local boldFontPath = "assets/fonts/Roboto-Bold.ttf"

    -- Функция для проверки существования файла
    local function fileExists(path)
        return love.filesystem.getInfo(path) ~= nil
    end

    -- Загрузка основного шрифта
    if fileExists(regularFontPath) then
        self.font = love.graphics.newFont(regularFontPath, 24)
    else
        self.font = love.graphics.newFont(24)
    end

    -- Загрузка шрифта для заголовков
    if fileExists(boldFontPath) then
        self.titleFont = love.graphics.newFont(boldFontPath, 48)
    else
        self.titleFont = love.graphics.newFont(48)
    end

    -- Загрузка изображений стрелок (для меню)
    if fileExists("assets/images/arrow_up.png") then
        self.arrowUp = love.graphics.newImage("assets/images/arrow_up.png")
    end

    if fileExists("assets/images/arrow_down.png") then
        self.arrowDown = love.graphics.newImage("assets/images/arrow_down.png")
    end

    -- Улучшаем качество отображения
    self.font:setFilter("linear", "linear")
    self.titleFont:setFilter("linear", "linear")
end

function UI:draw(game)
    -- Устанавливаем основной шрифт
    love.graphics.setFont(self.font)

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    -- Главное меню
    if game.state == "main_menu" then
        -- Заголовок
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(0, 1, 0) -- Зеленый
        love.graphics.printf("ЗМЕЙКА", 0, 50, windowWidth, "center")

        -- Пункты меню
        love.graphics.setFont(self.font)
        for i, item in ipairs(game.menuItems) do
            if i == game.selectedMenuItem then
                love.graphics.setColor(1, 1, 0) -- Желтый для выбранного пункта
            else
                love.graphics.setColor(1, 1, 1) -- Белый для остальных
            end
            love.graphics.printf(item, 0, 200 + i * 50, windowWidth, "center")
        end

        -- Подсказка управления с графическими стрелками
        love.graphics.setColor(0.7, 0.7, 0.7)

        -- Если есть изображения стрелок, рисуем их
        if self.arrowUp and self.arrowDown then
            local text = "Управление: "
            local textWidth = self.font:getWidth(text)

            -- Рассчитываем позиции
            local totalWidth = textWidth + self.arrowSize * 2 + 20
            local startX = (windowWidth - totalWidth) / 2
            local yPos = windowHeight - 60

            -- Текст
            love.graphics.print(text, startX, yPos + 5)

            -- Стрелка вверх
            local arrowX = startX + textWidth
            love.graphics.draw(self.arrowUp, arrowX, yPos, 0,
                self.arrowSize / self.arrowUp:getWidth(),
                self.arrowSize / self.arrowUp:getHeight())

            -- Слэш между стрелками
            love.graphics.print("/", arrowX + self.arrowSize + 5, yPos + 5)

            -- Стрелка вниз
            arrowX = arrowX + self.arrowSize + 25
            love.graphics.draw(self.arrowDown, arrowX, yPos, 0,
                self.arrowSize / self.arrowDown:getWidth(),
                self.arrowSize / self.arrowDown:getHeight())

            -- Завершающий текст
            love.graphics.print(" для выбора, Enter - подтвердить", arrowX + self.arrowSize + 5, yPos + 5)
        else
            -- Запасной вариант без изображений
            love.graphics.printf("Управление: Стрелки ВВЕРХ/ВНИЗ для выбора, Enter - подтвердить",
                0, windowHeight - 50, windowWidth, "center")
        end

        -- Меню настроек
    elseif game.state == "settings" then
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(0, 1, 1) -- Голубой
        love.graphics.printf("НАСТРОЙКИ", 0, 50, windowWidth, "center")

        love.graphics.setFont(self.font)
        love.graphics.setColor(1, 1, 1) -- Белый
        love.graphics.printf("Текущая сложность: " .. game.difficulty,
            0, 150, windowWidth, "center")

        -- Пункты настроек
        for i, item in ipairs(game.menuItems) do
            if i == game.selectedMenuItem then
                love.graphics.setColor(1, 1, 0) -- Желтый
            else
                love.graphics.setColor(1, 1, 1) -- Белый
            end
            love.graphics.printf(item, 0, 200 + i * 50, windowWidth, "center")
        end

        -- Экран рекордов
    elseif game.state == "records" then
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(1, 0.5, 0) -- Оранжевый
        love.graphics.printf("РЕКОРДЫ", 0, 50, windowWidth, "center")

        love.graphics.setFont(self.font)
        love.graphics.setColor(1, 1, 1) -- Белый

        -- Проверяем, есть ли рекорды
        if #game.Records.scores > 0 then
            -- Отображение таблицы рекордов
            for i, score in ipairs(game.Records.scores) do
                love.graphics.printf(i .. ". " .. score, 0, 150 + i * 40, windowWidth, "center")
            end
        else
            love.graphics.printf("Рекордов пока нет!", 0, 200, windowWidth, "center")
        end

        -- Подсказка возврата
        love.graphics.printf("Нажмите ESC для возврата",
            0, windowHeight - 100, windowWidth, "center")

        -- Экран "Об игре"
    elseif game.state == "about" then
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(0.5, 0, 1) -- Фиолетовый
        love.graphics.printf("ОБ ИГРЕ", 0, 50, windowWidth, "center")

        love.graphics.setFont(self.font)
        love.graphics.setColor(1, 1, 1) -- Белый
        love.graphics.printf("Классическая игра Змейка", 0, 150, windowWidth, "center")
        love.graphics.printf("Разработано на Lua с Love2D", 0, 200, windowWidth, "center")
        love.graphics.printf("Версия 1.0", 0, 250, windowWidth, "center")
        love.graphics.printf("© " .. os.date("%Y"), 0, 300, windowWidth, "center")

        -- Подсказка возврата
        love.graphics.printf("Нажмите ESC для возврата",
            0, windowHeight - 100, windowWidth, "center")

        -- Игровой процесс и экран завершения игры
    elseif game.state == "playing" or game.state == "game_over" then
        -- Панель информации
        love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
        love.graphics.rectangle("fill", 0, 0, windowWidth, 80)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Счет: " .. game.score, 10, 10)
        love.graphics.print("Рекорд: " .. game.highScore, 10, 40)
        love.graphics.print("Сложность: " .. game.difficulty, windowWidth - 200, 10)

        -- Экран завершения игры
        if game.state == "game_over" then
            -- Затемнение экрана
            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)

            -- Сообщение о завершении
            love.graphics.setFont(self.titleFont)
            love.graphics.setColor(1, 0.2, 0.2) -- Красный
            love.graphics.printf("ИГРА ОКОНЧЕНА!", 0, 150, windowWidth, "center")

            -- Счет игрока
            love.graphics.setFont(self.font)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("Ваш счет: " .. game.score, 0, 220, windowWidth, "center")

            -- Проверка на новый рекорд
            if game.Records:isHighScore(game.score) then
                love.graphics.setColor(1, 1, 0) -- Желтый
                love.graphics.printf("НОВЫЙ РЕКОРД!", 0, 260, windowWidth, "center")
            end

            -- Подсказки действий
            love.graphics.setColor(0.8, 0.8, 1)
            love.graphics.printf("Нажмите ПРОБЕЛ для рестарта", 0, 320, windowWidth, "center")
            love.graphics.printf("Нажмите ESC для выхода в меню", 0, 360, windowWidth, "center")
        end

        -- Подсказка управления (внизу экрана)
        love.graphics.setColor(0.7, 0.7, 0.7)
        -- ИСПРАВЛЕНИЕ: Заменяем символы стрелок на текстовое описание
        love.graphics.print("Управление: Стрелки ВЛЕВО, ВПРАВО, ВВЕРХ, ВНИЗ", 10, windowHeight - 30)
    end
end

return UI
