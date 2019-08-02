--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BossChasingState = Class{__includes = BaseState}

function BossChasingState:init(tilemap, player, boss)
    self.tilemap = tilemap
    self.player = player
    self.boss = boss
    self.animation = Animation {
        frames = {10, 11},
        interval = 0.1
    }
    self.boss.currentAnimation = self.animation
    self.boss.y = 6 * TILE_SIZE - 18 --returns to normal if came from sliding
end
    
function BossChasingState:update(dt)
    self.boss.currentAnimation:update(dt)

    if self.player.x < self.boss.x then
        self.boss.direction = 'right'
        self.boss.x = self.boss.x - BOSS_MOVE_SPEED * dt
    else
        self.boss.direction = 'left'
        self.boss.x = self.boss.x + BOSS_MOVE_SPEED * dt
    end
    
    if self.boss.invulnerable then
        self.boss:changeState('slide')
    end
end