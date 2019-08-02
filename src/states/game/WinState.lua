--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WinState = Class{__includes = BaseState}

function WinState:enter (def)
    finalScore = def.score
end

function WinState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function WinState:render()
    
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('VICTORY', 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Final Score: ' .. finalScore, 1, VIRTUAL_HEIGHT / 2 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Final Score: ' .. finalScore, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Press Enter to Restart', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter to Restart', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')

end