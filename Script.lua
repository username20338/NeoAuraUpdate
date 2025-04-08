-==[ NeoAura Script by Carlos ]==--

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "NeoAura"
gui.ResetOnSpawn = false

--// Intro
local intro = Instance.new("Frame", gui)
intro.Size = UDim2.new(1,0,1,0)
intro.BackgroundColor3 = Color3.fromRGB(10,10,10)
intro.BackgroundTransparency = 1

local label = Instance.new("TextLabel", intro)
label.Size = UDim2.new(0,400,0,100)
label.Position = UDim2.new(0.5,-200,0.5,-50)
label.BackgroundTransparency = 1
label.Text = "NeoAura"
label.Font = Enum.Font.GothamBlack
label.TextColor3 = Color3.fromRGB(0,255,180)
label.TextScaled = true
label.TextTransparency = 1

local TweenService = game:GetService("TweenService")
TweenService:Create(intro, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
wait(2.5)
TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(intro, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
wait(0.6)
intro:Destroy()

--// Interface
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 220)
frame.Position = UDim2.new(0, 20, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true

-- Drag
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos, storedPos = false

local function update(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    frame.Position = newPos
    storedPos = newPos
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        frame.BackgroundTransparency = 0.3
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                frame.BackgroundTransparency = 0
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        input.Changed:Connect(function()
            if dragging then update(input) end
        end)
    end
end)

-- Botão fechar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Função do Super Ring
local RunService = game:GetService("RunService")
local rings = {}
local spinning = false
local mode = "Ring"
local speed = 2

local function createRing(radius, index)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(0.5, 0.5, 0.5)
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromHSV(index / 8, 1, 1)
    part.Parent = workspace
    table.insert(rings, part)
end

for i = 1, 8 do createRing(4, i) end

local angle = 0
RunService.RenderStepped:Connect(function()
    if not spinning then
        for _, ring in ipairs(rings) do ring.Transparency = 1 end
        return
    end

    angle += speed / 100
    for i, ring in ipairs(rings) do
        ring.Transparency = 0
        local theta = math.rad((i - 1) * 360 / #rings + angle * 360)
        local offset

        if mode == "Ring" then
            offset = Vector3.new(math.cos(theta), 0, math.sin(theta)) * 4
            ring.Color = Color3.fromHSV(i / #rings, 1, 1)

        elseif mode == "Flor" then
            offset = Vector3.new(0, math.cos(theta) * 3, math.sin(theta) * 3)
            ring.Color = Color3.fromRGB(255, 105, 180)

        elseif mode == "Sickle Star" then
            offset = Vector3.new(math.cos(theta), math.sin(theta), 0) * 4
            ring.Color = Color3.fromRGB(255, 0, 0)

        elseif mode == "Wither Storm" then
            offset = Vector3.new(math.cos(theta) * 5, math.sin(theta) * 1.5, math.sin(theta) * 5)
            ring.Color = Color3.fromRGB(70, 0, 140)
        end

        ring.Position = player.Character.HumanoidRootPart.Position + offset
    end
end)

-- Botões
local function makeBtn(name, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeBtn("Ativar Anel", 10, function() spinning = not spinning end)
makeBtn("Trocar Modo", 50, function()
    local modos = {"Ring", "Flor", "Sickle Star", "Wither Storm"}
    for i, m in pairs(modos) do
        if m == mode then
            mode = modos[(i % #modos) + 1]
            break
        end
    end
end)
makeBtn("Velocidade +", 90, function() speed = speed + 1 end)
makeBtn("Velocidade -", 130, function() speed = math.max(1, speed - 1) end)
makeBtn("Discord", 170, function()
    setclipboard("https://discord.gg/S7BjQ7F4")
end)

-- Restaurar posição
player.CharacterAdded:Connect(function()
    repeat wait() until player:FindFirstChild("PlayerGui"):FindFirstChild("NeoAura")
    if storedPos then frame.Position = storedPos end
end)
