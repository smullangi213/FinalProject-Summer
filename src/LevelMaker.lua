--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    lockLocation = 1
    local keySpawned = false
    local lockSpawned = false
    keyLockColor = math.random(#KEYS)
    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end
    
    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness but not on column character or flag is spawned over (column x = 1)
        if (math.random(7) == 1) and (not(x == 1)) and (not(x == width - 1)) then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar but not where flag is spawned to keep it flat normal land
            if math.random(8) == 1 and (not(x == width - 1)) then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                --chance to spawn a key or lock on the top of a pillar
                if (not(keySpawned) and (math.random(width/4) == 1 or x >= width-4)) then
                    table.insert (objects, 
                        GameObject {
                            texture = 'keys-locks',
                                x = (x - 1) * TILE_SIZE,
                                y = (4 - 1) * TILE_SIZE,
                                width = 16,
                                height = 16, 
                                frame = keyLockColor,
                                collidable = true,
                                consumable = true,
                                solid = false,
                              
                                onConsume = function (player, object)
                                    gSounds['pickup']:play()
                                    player.keyConsumed = true
                                  
                                    objects[lockLocation].consumable = true
                                    objects[lockLocation].solid = false
                                end
                            })
                    keySpawned = true
                
                elseif (not(lockSpawned) and (math.random(width/4) == 1 or x >= width-2)) then
                    lockLocation = #objects + 1
                
                    table.insert (objects, 
                        GameObject {
                            texture = 'keys-locks',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16, 
                            frame = keyLockColor + 4,
                            collidable = true,
                            consumable = false,
                            solid = true,
                          
                            onCollide = function () end,
                          
                            onConsume = function (player, object)
                                gSounds['pickup']:play()
                                player.lockConsumed = true
                              
                                --spawn the pole and flag when the player unlocks (consumes) the lock
                                table.insert (objects,
                                    GameObject {
                                        texture = 'poles',
                                        --x is offset by eight to make the flag look like it is on the pole
                                        x = (width - 1) * TILE_SIZE - 8,
                                        y = (4 - 1) * TILE_SIZE,
                                        width = 16,
                                        height = 64, 
                                        frame = math.random(#POLES),
                                        solid = false,
                                        collidable = true,
                                        consumable = true,
                                
                                        onConsume = function(object)
                                            gStateMachine:change('play',
                                                {levelWidth = width+20,
                                                score = player.score})
                                        end
                                    })
                                table.insert (objects,
                                    GameObject {
                                        texture = 'flags',
                                        x = (width - 1) * TILE_SIZE,
                                        y = (4.3 - 1) * TILE_SIZE,
                                        width = 16,
                                        height = 16,
                                        frame = FLAGS[math.random(#FLAGS)],
                                        collidable = false
                                    })
                              end
                          })
                    lockSpawned = true
                
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            
            --same code as above, spawns lock and key on ground
            elseif (not(keySpawned) and (math.random(width/4) == 1 or x >= width - 4)) then
                table.insert (objects, 
                    GameObject {
                          texture = 'keys-locks',
                              x = (x - 1) * TILE_SIZE,
                              y = (6 - 1) * TILE_SIZE,
                              width = 16,
                              height = 16, 
                              frame = keyLockColor,
                              collidable = true,
                              consumable = true,
                              solid = false,
                              
                              onConsume = function (player, object)
                                  gSounds['pickup']:play()
                                  player.keyConsumed = true
                                  
                                  --make the lock able to be consumed and disappear
                                  objects[lockLocation].consumable = true
                                  objects[lockLocation].solid = false
                              end
                            })
                keySpawned = true
                
            elseif (not(lockSpawned) and (math.random(width/4) == 1 or x >= width-2)) then
                --store location of lock in the array
                lockLocation = #objects + 1
                
                table.insert (objects, 
                    GameObject {
                          texture = 'keys-locks',
                          x = (x - 1) * TILE_SIZE,
                          y = (6 - 1) * TILE_SIZE,
                          width = 16,
                          height = 16, 
                          frame = keyLockColor + 4,
                          collidable = true,
                          consumable = false,
                          solid = true,
                          
                          onCollide = function () end,
                          
                          onConsume = function (player, object)
                              gSounds['pickup']:play()
                              player.lockConsumed = true
                              
                              table.insert (objects,
                                  GameObject {
                                      texture = 'poles',
                                      x = (width - 1) * TILE_SIZE - 8,
                                      y = (4 - 1) * TILE_SIZE,
                                      width = 16,
                                      height = 64, 
                                      frame = math.random(#POLES),
                                      solid = false,
                                      collidable = true,
                                      consumable = true,
                              
                                      onConsume = function(object)
                                          gStateMachine:change('play',
                                              {levelWidth = width+20,
                                              score = player.score})
                                      end
                              })
                              table.insert (objects,
                                  GameObject {
                                      texture = 'flags',
                                      x = (width - 1) * TILE_SIZE,
                                      y = (4.3 - 1) * TILE_SIZE,
                                      width = 16,
                                      height = 16,
                                      frame = FLAGS[math.random(#FLAGS)],
                                      collidable = false
                                  })
                            end
                })
            lockSpawned = true
          end
          if (x == width) then
              
            end
            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end