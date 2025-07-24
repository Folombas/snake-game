-- Этот файл не используется в текущей реализации,
-- но оставлю на случай, если захотите добавить эффекты
ParticleSystem = {}

function ParticleSystem.create(x, y)
    return {
        x = x,
        y = y,
        particles = {},
        colors = {
            { 1, 0, 0 }, -- Red
            { 0, 1, 0 }, -- Green
            { 0, 0, 1 } -- Blue
        }
    }
end

function ParticleSystem:update(dt)
    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p.life = p.life - dt

        if p.life <= 0 then
            table.remove(self.particles, i)
        else
            p.x = p.x + p.vx * dt
            p.y = p.y + p.vy * dt
        end
    end
end

function ParticleSystem:emit(count)
    for i = 1, count do
        local color = self.colors[math.random(#self.colors)]
        table.insert(self.particles, {
            x = self.x,
            y = self.y,
            vx = math.random(-100, 100),
            vy = math.random(-100, 100),
            life = math.random(0.5, 1.5),
            color = color,
            size = math.random(2, 5)
        })
    end
end

function ParticleSystem:draw()
    for _, p in ipairs(self.particles) do
        love.graphics.setColor(p.color)
        love.graphics.circle("fill", p.x, p.y, p.size)
    end
    love.graphics.setColor(1, 1, 1)
end
