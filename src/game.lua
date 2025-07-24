Game = {
    state = "menu", -- menu, playing, paused, gameover
    gridSize = 20,
    score = 0,
    highScore = 0
}

function Game.init()
    Records.load()
    Game.highScore = Records.getHighScore()
    Snake.init()
    Food.spawn()

    -- Запуск музыки
    if ResourceManager.sounds.music then
        love.audio.play(ResourceManager.sounds.music)
    end
end

function Game.update(dt)
    if Game.state == "playing" then
        Snake.update(dt)
        Game.checkCollisions()
    end
end

function Game.draw()
    -- Рисуем сетку игрового поля
    love.graphics.setColor(0.9, 0.9, 0.9, 0.3)
    for x = 0, love.graphics.getWidth(), Game.gridSize do
        love.graphics.line(x, 0, x, love.graphics.getHeight())
    end
    for y = 0, love.graphics.getHeight(), Game.gridSize do
        love.graphics.line(0, y, love.graphics.getWidth(), y)
    end
    love.graphics.setColor(1, 1, 1)

    if Game.state == "menu" then
        UI.drawMenu()
    elseif Game.state == "playing" or Game.state == "paused" then
        Food.draw()
        Snake.draw()
        UI.drawGameUI()
    elseif Game.state == "gameover" then
        Food.draw()
        Snake.draw()
        UI.drawGameOver()
    end
end

function Game.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif Game.state == "menu" and key == "return" then
        Game.state = "playing"
    elseif Game.state == "playing" and key == "p" then
        Game.state = "paused"
    elseif Game.state == "paused" and key == "p" then
        Game.state = "playing"
    elseif Game.state == "gameover" and key == "return" then
        Game.reset()
    end

    if Game.state == "playing" then
        Snake.changeDirection(key)
    end
end

function Game.checkCollisions()
    if Snake.checkSelfCollision() or Snake.checkWallCollision() then
        if ResourceManager.sounds.crash then
            love.audio.play(ResourceManager.sounds.crash)
        end
        Game.state = "gameover"
        Records.save(Game.score)
        Achievements.check(Snake.length)
    end

    if Snake.checkFoodCollision(Food.position) then
        if ResourceManager.sounds.eat then
            love.audio.play(ResourceManager.sounds.eat)
        end
        Snake.grow()
        Food.spawn()
        Game.score = Game.score + 10
        if Game.score > Game.highScore then
            Game.highScore = Game.score
        end
    end
end

function Game.reset()
    Snake.init()
    Food.spawn()
    Game.score = 0
    Game.state = "playing"
end
