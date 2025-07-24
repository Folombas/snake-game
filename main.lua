function love.load()
    -- Загрузка менеджера ресурсов с защитой от ошибок
    local resourceSuccess, resourceError = pcall(function()
        require "src.lib.resource_manager"
        ResourceManager.loadAssets()
    end)

    if not resourceSuccess then
        print("Ошибка загрузки ресурсов: " .. resourceError)
        -- Создаем запасные ресурсы
        ResourceManager = {
            fonts = {
                bold = love.graphics.newFont(24),
                regular = love.graphics.newFont(18)
            },
            sounds = {}
        }
    end

    -- Загрузка игровых модулей с защитой от ошибок
    local gameModules = {
        "src.game",
        "src.snake",
        "src.food",
        "src.ui",
        "src.records",
        "src.achievements"
    }

    for _, module in ipairs(gameModules) do
        local success, err = pcall(require, module)
        if not success then
            print("Ошибка загрузки модуля " .. module .. ": " .. err)
        end
    end

    -- Инициализация игры с защитой от ошибок
    local initSuccess, initError = pcall(Game.init)
    if not initSuccess then
        print("Ошибка инициализации игры: " .. initError)
        Game.state = "error"
        Game.errorMessage = "Ошибка инициализации: " .. initError
    end
end

function love.update(dt)
    if Game.update and Game.state ~= "error" then
        local success, err = pcall(Game.update, dt)
        if not success then
            print("Ошибка в Game.update: " .. err)
            Game.state = "error"
            Game.errorMessage = "Ошибка обновления: " .. err
        end
    end
end

function love.draw()
    if Game.draw and Game.state ~= "error" then
        local success, err = pcall(Game.draw)
        if not success then
            print("Ошибка в Game.draw: " .. err)
            love.graphics.setColor(1, 0, 0)
            love.graphics.print("Ошибка отрисовки: " .. err, 100, 100)
        end
    elseif Game.state == "error" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(ResourceManager.fonts.bold)
        love.graphics.print("ПРОИЗОШЛА ОШИБКА", 100, 100)
        love.graphics.setFont(ResourceManager.fonts.regular)
        love.graphics.print(Game.errorMessage, 100, 150)
        love.graphics.print("Проверьте консоль для подробностей", 100, 200)
        love.graphics.print("Нажмите ESC для выхода", 100, 250)
    end
end

function love.keypressed(key)
    if Game.keypressed and Game.state ~= "error" then
        local success, err = pcall(Game.keypressed, key)
        if not success then
            print("Ошибка в Game.keypressed: " .. err)
            Game.state = "error"
            Game.errorMessage = "Ошибка обработки ввода: " .. err
        end
    elseif key == "escape" then
        love.event.quit()
    end
end
