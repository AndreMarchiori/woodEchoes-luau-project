--Services

--CONSTANTS
local MAX_APPLES = 175
local MAX_WATERMELONS = 35
local SPAWN_DELAY = 30

--Members
local appleTrees:Folder = game:GetService("Workspace").AppleTrees
local melonBushes:Folder = game:GetService("Workspace").MelonBushes
local foods:Folder = game:GetService("Workspace").Foods
local apples:Folder = foods.Apples
local watermelons:Folder = foods.Watermelons
local ServerStorage = game:GetService("ServerStorage")

local function spawnApple()
    local allTrees = appleTrees:GetChildren()
    local selectedTree = allTrees[math.random(1, #allTrees)]
    local randomTreeAppleSpawner = selectedTree:FindFirstChild("AppleSpawner")

    if randomTreeAppleSpawner then
        local positionSelected = randomTreeAppleSpawner.CFrame
        local newApple = ServerStorage.Foods.Apple:Clone()

        -- Define a PrimaryPart se não estiver definida
        if not newApple.PrimaryPart then
            newApple.PrimaryPart = newApple:FindFirstChild("ApplePart")
        end

        newApple.Parent = apples
        newApple.PrimaryPart.CFrame = positionSelected * CFrame.new(math.random(-8, 8), 5, math.random(-8, 8))
    else
        warn("AppleSpawner não encontrado na árvore selecionada: " .. selectedTree.Name)
    end
end


local function spawnMelon()
    local allBushes = melonBushes:GetChildren()
    if #allBushes == 0 then
        warn("Nenhum arbusto foi encontrado em melonBushes!")
        return
    end

    local randomBush = allBushes[math.random(1, #allBushes)]

    if not randomBush.PrimaryPart then
        warn("O arbusto " .. randomBush.Name .. " não tem uma PrimaryPart definida!")
        return
    end

    local randomValue1 = math.random(-5, 5)
    local randomValue2 = math.random(-5, 5)
    local positionSelected = randomBush.PrimaryPart.CFrame

    local newWatermelon = ServerStorage.Foods.Watermelon:Clone()

    -- Verifica se a melancia tem uma PrimaryPart
    if not newWatermelon.PrimaryPart then
        newWatermelon.PrimaryPart = newWatermelon:FindFirstChild("Watermelon")
        if not newWatermelon.PrimaryPart then
            warn("A melancia clonada não tem uma PrimaryPart válida!")
            return
        end
    end

    newWatermelon.Parent = watermelons
    newWatermelon.PrimaryPart.CFrame = positionSelected * CFrame.new(randomValue1, 0, randomValue2)
end


task.delay(1, function()
    while true do
        if #apples:GetChildren() < MAX_APPLES then
           spawnApple()
           task.wait(SPAWN_DELAY)
        else
            task.wait(60) 
        end
    end
end)

while true do
    if #watermelons:GetChildren() < MAX_WATERMELONS then
        spawnMelon()
        task.wait(SPAWN_DELAY*5)
    else
        task.wait(60)
    end
end
