-- Добавляем определение таблицы ResourceManager
ResourceManager = {
    images = {},
    fonts = {},
    sounds = {}
}

function ResourceManager.loadAssets()
    -- Загрузка шрифтов
    if love.filesystem.getInfo("assets/fonts/Roboto-Bold.ttf") then
        ResourceManager.fonts.bold = love.graphics.newFont("assets/fonts/Roboto-Bold.ttf", 24)
    else
        ResourceManager.fonts.bold = love.graphics.newFont(24)
        print("Шрифт Aa Roboto-Bold.ttf не найден, используется системный")
    end

    if love.filesystem.getInfo("assets/fonts/Roboto-Regular.ttf") then
        ResourceManager.fonts.regular = love.graphics.newFont("assets/fonts/Roboto-Regular.ttf", 18)
    else
        ResourceManager.fonts.regular = love.graphics.newFont(18)
        print("Шрифт Aa Roboto-Regular.ttf не найден, используется системный")
    end

    -- Загрузка звуков
    if love.filesystem.getInfo("assets/sounds/eat.wav") then
        ResourceManager.sounds.eat = love.audio.newSource("assets/sounds/eat.wav", "static")
    else
        print("Звук eat.wav не найден")
    end

    if love.filesystem.getInfo("assets/sounds/crash.wav") then
        ResourceManager.sounds.crash = love.audio.newSource("assets/sounds/crash.wav", "static")
    else
        print("Звук crash.wav не найден")
    end

    if love.filesystem.getInfo("assets/sounds/bonus.wav") then
        ResourceManager.sounds.bonus = love.audio.newSource("assets/sounds/bonus.wav", "static")
    else
        print("Звук bonus.wav не найден")
    end

    if love.filesystem.getInfo("assets/sounds/music.wav") then
        ResourceManager.sounds.music = love.audio.newSource("assets/sounds/music.wav", "stream")
        ResourceManager.sounds.music:setLooping(true)
    else
        print("Музыка music.wav не найдена")
    end
end
