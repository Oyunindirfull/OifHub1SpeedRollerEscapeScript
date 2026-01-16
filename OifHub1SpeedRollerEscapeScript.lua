local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Oif Hub | +1 Speed Roller Escape Script",
   LoadingTitle = "Oif Hub Loading...",
   LoadingSubtitle = "Oif Hub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OifScripts",
      FileName = "MainConfig"
   }
})

local MainTab = Window:CreateTab("General Features", 4483362458)
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local DiscordTab = Window:CreateTab("Discord", 4483362458) -- Discord sekmesi eklendi

-- DEĞİŞKENLER
local lp = game.Players.LocalPlayer
local FlySpeed = 50
local Flying = false
local Noclip = false
local AutoFarm = false
local RunService = game:GetService("RunService")

-- KOORDİNATLAR
local WinPos = Vector3.new(4326.2890625, 133.6610565185547, -41.61949157714844)
local StartPos = Vector3.new(-28.620498657226562, 1.5000050067901611, -70.98098754882812)

-- DISCORD KISMI
DiscordTab:CreateButton({
   Name = "Discord Join Us! (Link Copy!)",
   Callback = function()
      setclipboard("https://discord.com/invite/yHSXgTfVJ8") -- Buraya kendi discord linkini yazabilirsin
      Rayfield:Notify({
         Title = "Successful!",
         Content = "The Discord link has been successfully copied.",
         Duration = 3
      })
   end,
})

-- NOCLIP DÖNGÜSÜ
RunService.Stepped:Connect(function()
    if Noclip then
        if lp.Character then
            for _, part in pairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

--- ULTRA HIZLI AUTO FARM SİSTEMİ ---
local function startAutoFarm()
    task.spawn(function()
        while AutoFarm do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = lp.Character.HumanoidRootPart
                
                -- 1. Win Pozisyonuna Işınlan
                hrp.Velocity = Vector3.new(0,0,0) 
                hrp.CFrame = CFrame.new(WinPos)
                task.wait(0.1)

                -- 2. Çok Hızlı Sağ-Sol-İleri-Geri Hareket (3.5 Saniye Jitter)
                local startTick = tick()
                while tick() - startTick < 3.5 and AutoFarm do
                    local jitter = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                    hrp.CFrame = CFrame.new(WinPos + jitter)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    task.wait(0.03)
                end

                -- 3. Başlangıç Pozisyonuna Geri Işınlan
                if AutoFarm then
                    hrp.Velocity = Vector3.new(0,0,0)
                    hrp.CFrame = CFrame.new(StartPos)
                end
                
                task.wait(0.2)
            else
                task.wait(1)
            end
        end
    end)
end

-- AUTO FARM TOGGLE
FarmTab:CreateToggle({
   Name = "Auto Win Farm (+Speed)",
   CurrentValue = false,
   Callback = function(Value)
      AutoFarm = Value
      if AutoFarm then
          startAutoFarm()
      end
   end,
})

-- SPEED HACK
MainTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
         lp.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- INFINITE JUMP
MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      _G.InfJump = Value
      game:GetService("UserInputService").JumpRequest:Connect(function()
         if _G.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
         end
      end)
   end,
})

-- TAM 3D FLY
MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      local char = lp.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      
      if Flying then
          local root = char.HumanoidRootPart
          local camera = workspace.CurrentCamera
          
          local bg = Instance.new("BodyGyro", root)
          bg.P = 9e4
          bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
          bg.cframe = root.CFrame
          
          local bv = Instance.new("BodyVelocity", root)
          bv.velocity = Vector3.new(0, 0, 0)
          bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
          
          task.spawn(function()
              while Flying and char and char:FindFirstChild("Humanoid") do
                  task.wait()
                  char.Humanoid.PlatformStand = true
                  local moveDir = char.Humanoid.MoveDirection
                  
                  if moveDir.Magnitude > 0 then
                      local lookVec = camera.CFrame.LookVector
                      local rightVec = camera.CFrame.RightVector
                      local direction = Vector3.new(0,0,0)
                      
                      direction = direction + (lookVec * (moveDir:Dot(lookVec)))
                      direction = direction + (rightVec * (moveDir:Dot(rightVec)))
                      
                      bv.velocity = direction.Unit * FlySpeed
                  else
                      bv.velocity = Vector3.new(0, 0, 0)
                  end
                  bg.cframe = camera.CFrame
              end
              
              if char:FindFirstChild("Humanoid") then
                  char.Humanoid.PlatformStand = false
              end
              bg:Destroy()
              bv:Destroy()
          end)
      end
   end,
})

-- NOCLIP TOGGLE
MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      Noclip = Value
   end,
})

-- FLY HIZ AYARI
MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      FlySpeed = Value
   end,
})

Rayfield:Notify({
   Title = "Oif Hub Script Ready",
   Content = "Fly, Noclip And Speed Farm",
   Duration = 5
})