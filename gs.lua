local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local backpack = player:WaitForChild("Backpack")

--------------------------------------------------
-- TWEEN INFO
--------------------------------------------------

local tweenInfo = TweenInfo.new(
	1.2,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out
)

local function tweenTo(cf)
	local tween = TweenService:Create(hrp, tweenInfo, { CFrame = cf })
	tween:Play()
	tween.Completed:Wait()
end

--------------------------------------------------
-- WYPOSAŻENIE MIOTŁY
--------------------------------------------------

local function equipBroom()
	local broom = backpack:FindFirstChild("Broom")
	if broom and humanoid then
		humanoid:EquipTool(broom)
		task.wait(0.15)
	end
end

--------------------------------------------------
-- SZUKANIE NAJBLIŻSZEGO LITTERA
--------------------------------------------------

local function getNearestLitter()
	local nearest
	local shortest = math.huge

	for _, model in ipairs(workspace:GetChildren()) do
		if model:IsA("Model") and model.Name == "Litter" then
			local part = model:FindFirstChild("Litter")
			if part and part:IsA("BasePart") then
				local dist = (hrp.Position - part.Position).Magnitude
				if dist < shortest then
					shortest = dist
					nearest = part
				end
			end
		end
	end

	return nearest
end

--------------------------------------------------
-- GŁÓWNA PĘTLA (AUTO FARM)
--------------------------------------------------

while task.wait(0.1) do
	local litterPart = getNearestLitter()
	if not litterPart then
		task.wait(0.5)
		continue
	end

	-- 1️⃣ podejście do littera
	tweenTo(litterPart.CFrame * CFrame.new(0, 0, -2))

	-- 2️⃣ miotła
	equipBroom()

	-- 3️⃣ ProximityPrompt
	local prompt = litterPart:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt then
		task.wait(0.1)

		-- 4️⃣ interakcja
		fireproximityprompt(prompt, prompt.HoldDuration)

		-- 5️⃣ czekamy aż litter ZNIKNIE
		local start = tick()
		repeat
			task.wait()
		until not litterPart:IsDescendantOf(workspace) or tick() - start > 3
	end
end
