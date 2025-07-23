Records = {
    file = "records.txt",
    scores = {}
}

function Records:load()
    if love.filesystem.getInfo(self.file) then
        local contents = love.filesystem.read(self.file)
        self.scores = {}
        for score in contents:gmatch("%d+") do
            table.insert(self.scores, tonumber(score))
        end
        table.sort(self.scores, function(a, b) return a > b end)
    else
        -- Начальные значения рекордов
        self.scores = { 300, 250, 200, 150, 100 }
        self:saveScores()
    end
end

function Records:saveScores()
    local content = table.concat(self.scores, "\n")
    love.filesystem.write(self.file, content)
end

function Records:save(score)
    table.insert(self.scores, score)
    table.sort(self.scores, function(a, b) return a > b end)

    -- Сохраняем только топ-5
    if #self.scores > 5 then
        self.scores = { table.unpack(self.scores, 1, 5) }
    end

    self:saveScores()
end

function Records:isHighScore(score)
    return #self.scores < 5 or score > self.scores[#self.scores]
end

return Records
