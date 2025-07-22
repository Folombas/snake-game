Game = {
    gridSize = 20,  -- Размер одной клетки
    width = 40,     -- Ширина поля в клетках
    height = 30,    -- Высота поля в клетках
    state = "menu", -- Состояние игры: menu, playing, game_over
    score = 0,      -- Счет игрока
    highScore = 0   -- Рекорд
}

function Game:init()
    -- Загрузка модулей
    self.Snake = require("src.snake")
    self.Food = require("src.food")
    self.UI = require("src.ui")

    -- Инициализация компонентов
    self.Snake:init(self)
    self.Food:spawn(self)
    self.UI:init(self)

    self.score = 0
    self.timer = 0
    self.updateInterval = 0.1 -- Скорость обновления (сек)
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
        end
    end
end

function Game:draw()
    -- Очистка экрана
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Отрисовка сетки
    for x = 0, self.width do
        for y = 0, self.height do
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("line", x * self.gridSize, y * self.gridSize, self.gridSize, self.gridSize)
        end
    end

    -- Отрисовка игровых объектов
    self.Food:draw(self)
    self.Snake:draw(self)
    self.UI:draw(self)
end

function Game:keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" or key == "space" then
        if self.state == "menu" or self.state == "game_over" then
            self:init()
            self.state = "playing"
        end
    elseif self.state == "playing" then
        self.Snake:changeDirection(key)
    end
end
