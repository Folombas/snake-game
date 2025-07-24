Records = {
    filename = "records.dat"
}

function Records.load()
    if not love.filesystem.getInfo(Records.filename) then
        love.filesystem.write(Records.filename, "0")
    end
end

function Records.save(score)
    local currentHigh = Records.getHighScore()
    if score > currentHigh then
        love.filesystem.write(Records.filename, tostring(score))
    end
end

function Records.getHighScore()
    Records.load()
    local content = love.filesystem.read(Records.filename)
    return tonumber(content) or 0
end
