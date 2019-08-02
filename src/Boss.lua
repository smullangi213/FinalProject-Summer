Boss = Class{__includes = Entity}

function Boss:init(def)
    Entity.init(self, def)
    self.invulnerable = false
    self.slideLevel = 1
end

function Boss:damage()
    if not self.invulnerable then
        self.health = self.health - 1
        self.invulnerable = true
        return self.health <= 0
    end
end

function Boss:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 8, 0, self.direction == 'left' and 1 or -1, 1, 8, 10)
end