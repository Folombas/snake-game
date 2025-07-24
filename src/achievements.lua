Achievements = {
    unlocked = {}
}

function Achievements.check(length)
    if length >= 10 and not Achievements.unlocked["10_snake"] then
        Achievements.unlocked["10_snake"] = true
        if ResourceManager.sounds.bonus then
            love.audio.play(ResourceManager.sounds.bonus)
        end
    end

    if length >= 20 and not Achievements.unlocked["20_snake"] then
        Achievements.unlocked["20_snake"] = true
        if ResourceManager.sounds.bonus then
            love.audio.play(ResourceManager.sounds.bonus)
        end
    end
end
