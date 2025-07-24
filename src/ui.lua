UI = {}

function UI.drawGameUI()
    love.graphics.setFont(ResourceManager.fonts.regular)

    -- Прозрачный фон для текста
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 5, 5, 200, 60, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. Game.score, 10, 10)
    love.graphics.print("High Score: " .. Game.highScore, 10, 40)

    if Game.state == "paused" then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setFont(ResourceManager.fonts.bold)
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf("PAUSED", 0, 200, love.graphics.getWidth(), "center")
        love.graphics.setFont(ResourceManager.fonts.regular)
        love.graphics.printf("Press P to continue", 0, 250, love.graphics.getWidth(), "center")
    end
end

function UI.drawMenu()
    love.graphics.setFont(ResourceManager.fonts.bold)
    love.graphics.setColor(0.2, 0.6, 0.2)
    love.graphics.printf("SNAKE GAME", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(ResourceManager.fonts.regular)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press ENTER to start", 0, 300, love.graphics.getWidth(), "center")
    love.graphics.printf("Arrow keys to control", 0, 350, love.graphics.getWidth(), "center")
    love.graphics.printf("Press P to pause", 0, 400, love.graphics.getWidth(), "center")
end

function UI.drawGameOver()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setFont(ResourceManager.fonts.bold)
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.printf("GAME OVER", 0, 200, love.graphics.getWidth(), "center")

    love.graphics.setFont(ResourceManager.fonts.regular)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: " .. Game.score, 0, 250, love.graphics.getWidth(), "center")
    love.graphics.printf("Press ENTER to restart", 0, 300, love.graphics.getWidth(), "center")
end
