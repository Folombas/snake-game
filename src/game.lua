Game = {
    gridSize = 20,        -- Размер одной клетки
    width = 40,           -- Ширина поля в клетках
    height = 30,          -- Высота поля в клетках
    state = "main_menu",  -- Состояние игры: main_menu, settings, records, about, playing, game_over
    score = 0,            -- Счет игрока
    highScore = 0,        -- Рекорд
    menuItems = { "Старт!", "Настройки", "Рекорды", "Об игре", "Выход" },
    selectedMenuItem = 1, -- Выбранный пункт меню
    difficulty = "medium" -- Уровень сложности: easy, medium, hard
}

function Game:init()
    -- Загрузка модулей
    self.Snake = require("src.snake")
    self.Food = require("src.food")
    self.UI = require("src.ui")
    self.Records = require("src.records")

    -- Инициализация компонентов
    self.Snake:init(self)
    self.Food:spawn(self)
    self.UI:init(self)
    self.Records:load()

    -- Начальные значения
    self.score = 0
    self.timer = 0
    self.highScore = self.Records.scores[1] or 0
    self.state = "main_menu"
    self.selectedMenuItem = 1
end

function Game:resetGame()
    -- Сброс игры без перезагрузки всего
    self.Snake:init(self)
    self.Food:spawn(self)
    self.score = 0
    self.state = "playing"

    -- Настройка сложности
    if self.difficulty == "easy" then
        self.updateInterval = 0.15
    elseif self.difficulty == "medium" then
        self.updateInterval = 0.10
    else -- hard
        self.updateInterval = 0.07
    end
end

function Game:update(dt)
    if self.state ~= "playing" then return end

    self.timer = self.timer + dt
    if self.timer >= self.updateInterval then
        self.timer = 0
        self.Snake:update(self)

        -- Проверка столкновения с едой
        if self.Snake:checkFoodCollision(self.Food) then
            self.Snake:grow()
            self.Food:spawn(self)
            self.score = self.score + 10
            self.highScore = math.max(self.score, self.highScore)
        end

        -- Проверка столкновения с собой
        if self.Snake:checkSelfCollision() then
            self.state = "game_over"
            if self.Records:isHighScore(self.score) then
                self.Records:save(self.score)
                self.highScore = self.Records.scores[1]
            end
        end
    end
end

function Game:draw()
    -- Очистка экрана
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Отрисовка сетки (только в игровом режиме)
    if self.state == "playing" or self.state == "game_over" then
        for x = 0, self.width do
            for y = 0, self.height do
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.rectangle("line", x * self.gridSize, y * self.gridSize, self.gridSize, self.gridSize)
            end
        end
    end

    -- Отрисовка игровых объектов
    if self.state == "playing" or self.state == "game_over" then
        self.Food:draw(self)
        self.Snake:draw(self)
    end

    -- Отрисовка интерфейса
    self.UI:draw(self)

    -- Отладочная информация (можно закомментировать)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("State: " .. self.state, 10, 100)
    love.graphics.print("Timer: " .. string.format("%.2f", self.timer), 10, 130)
    love.graphics.print("Direction: " .. self.Snake.direction, 10, 160)
end

function Game:keypressed(key)
    if key == "escape" then
        if self.state == "playing" then
            self.state = "main_menu"
        elseif self.state == "settings" or self.state == "records" or self.state == "about" then
            self.state = "main_menu"
            self.menuItems = { "Старт!", "Настройки", "Рекорды", "Об игре", "Выход" }
            self.selectedMenuItem = 1
        else
            love.event.quit()
        end
    end

    -- Навигация по меню
    if self.state == "main_menu" or self.state == "settings" then
        if key == "down" then
            self.selectedMenuItem = (self.selectedMenuItem % #self.menuItems) + 1
        elseif key == "up" then
            self.selectedMenuItem = self.selectedMenuItem > 1 and self.selectedMenuItem - 1 or #self.menuItems
        elseif key == "return" then
            self:handleMenuSelection()
        end
    end

    -- Обработка в игре и конце игры
    if self.state == "playing" then
        if key == "right" or key == "left" or key == "up" or key == "down" then
            self.Snake:changeDirection(key)
        end
    elseif self.state == "game_over" then
        if key == "space" then
            self:resetGame()
        end
    end
end

function Game:handleMenuSelection()
    local item = self.menuItems[self.selectedMenuItem]

    if item == "Старт!" then
        self:resetGame()
    elseif item == "Настройки" then
        self.state = "settings"
        self.menuItems = { "Легко", "Средне", "Сложно", "Назад" }
        self.selectedMenuItem = self.difficulty == "easy" and 1 or self.difficulty == "medium" and 2 or 3
    elseif item == "Рекорды" then
        self.state = "records"
    elseif item == "Об игре" then
        self.state = "about"
    elseif item == "Выход" then
        love.event.quit()
    elseif item == "Назад" then
        self.state = "main_menu"
        self.menuItems = { "Старт!", "Настройки", "Рекорды", "Об игре", "Выход" }
        self.selectedMenuItem = 1
    elseif item == "Легко" then
        self.difficulty = "easy"
    elseif item == "Средне" then
        self.difficulty = "medium"
    elseif item == "Сложно" then
        self.difficulty = "hard"
    end
end

return Game
