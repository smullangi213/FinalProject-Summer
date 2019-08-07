--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BossSlidingState = Class{__includes = BaseState}

function BossSlidingState:init(tilemap, player, boss)
    self.tilemap = tilemap
    self.player = player
    self.boss = boss
    self.animation = Animation {
        frames = {8},
        interval = 1
    }
    self.boss.currentAnimation = self.animation
    self.boss.y = 6 * TILE_SIZE - 20 --makes it look like he is hovering 
    
    self.timer = 0
    
end

function BossSlidingState:update(dt)
    Timer.every(5, function ()
        self.timer = self.timer + 1
        end)
        
    self.boss.currentAnimation:update(dt)

    --Switches if he gets too far from the player or if he hit the edge of the window
    if self.boss.x <= math.max (self.player.x - 150, 0) then
        self.boss.direction = 'left'
    end
    
    --Switches if he gets too far from the player or if he hit the edge of the window
    if self.boss.x + self.boss.width >= math.min (self.player.x + self.player.width + 150, VIRTUAL_WIDTH) then
        self.boss.direction = 'right'
    end
    
    if self.boss.direction == 'right' then
        --speeds up each time boss slides
        self.boss.x = self.boss.x - (150 + (100* (self.boss.slideLevel - 1))) * dt
    else
        --speeds up each time boss slides
        self.boss.x = self.boss.x + (150 + (100* (self.boss.slideLevel - 1))) * dt
    end
    
    if self.timer >= 1 then
        self.boss.invulnerable = false
    end
    
    if not self.boss.invulnerable then
        self.boss:changeState('chase')
        
        --increase the times that the boss has slided
        self.boss.slideLevel = self.boss.slideLevel + 1
    end
    
end