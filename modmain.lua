local require = GLOBAL.require
local math = GLOBAL.math

local growth_interval = GetModConfigData('GROWTH_INTERVAL')

local mob_health_grow_rate = GetModConfigData('MOB_HEALTH_GROWTH_RATE')
local mob_health_grow_cap = GetModConfigData('MOB_HEALTH_GROWTH_CAP')
local mob_damage_grow_rate = GetModConfigData('MOB_DAMAGE_GROWTH_RATE')
local mob_damage_grow_cap = GetModConfigData('MOB_DAMAGE_GROWTH_CAP')

local boss_health_grow_rate = GetModConfigData('BOSS_HEALTH_GROWTH_RATE')
local boss_health_grow_cap = GetModConfigData('BOSS_HEALTH_GROWTH_CAP')
local boss_damage_grow_rate = GetModConfigData('BOSS_DAMAGE_GROWTH_RATE')
local boss_damage_grow_cap = GetModConfigData('BOSS_DAMAGE_GROWTH_CAP')

local follower_grow_percent = GetModConfigData('FOLLOWER_GROWTH_PERCENTAGE')

local follower_list = {}
local exception_list = {
	abigail = true
}

local function HasLeader(inst)
	return inst.components.follower
		and inst.components.follower.leader
		and inst.components.follower.leader:IsValid()
		and inst.components.follower.leader:HasTag("player")
end

local function Grow(inst)
	-- print("GROW")
	if not inst:IsValid() then
		return
	end

	local cycles = GLOBAL.TheWorld.state.cycles
  	local total_growths = math.floor(cycles / growth_interval)

  	local health_rate = mob_health_grow_rate
  	local damage_rate = mob_damage_grow_rate
  	local health_cap = mob_health_grow_cap
  	local damage_cap = mob_damage_grow_cap

  	if inst:HasTag("epic") then
  		health_rate = boss_health_grow_rate
  		damage_rate = boss_damage_grow_rate
  		health_cap = boss_health_grow_cap
  		damage_cap = boss_damage_grow_cap
  	end

  	if (follower_list[inst.prefab] or HasLeader(inst)) and not exception_list[inst.prefab] then
  		total_growths = math.floor(total_growths * follower_grow_percent)
  		health_cap = health_cap * follower_grow_percent
  		damage_cap = damage_cap * follower_grow_percent
  	end

  	local growths_health_left = total_growths - inst.__growths_health
  	local growths_damage_left = total_growths - inst.__growths_damage

  	local delta_health_rate = health_rate * growths_health_left
  	if health_cap >= 0 then
  		delta_health_rate = math.min(delta_health_rate, math.max(0, health_cap - inst.__growths_health * health_rate))
  	end

  	local delta_damage_rate = damage_rate * growths_damage_left
  	if damage_cap >= 0 then
  		delta_damage_rate = math.min(delta_damage_rate, math.max(0, damage_cap - inst.__growths_damage * damage_rate))
  	end

  	if inst.components.health and inst.__growths_health ~= nil then
  		if inst.__origin_maxhealth ~= nil then
			local delta_health = delta_health_rate * inst.__origin_maxhealth

			-- print("DELTA HEALTH ", inst, delta_health)
			local current_percent = inst.components.health:GetPercent()
			inst.components.health.maxhealth = math.max(
				inst.__origin_maxhealth,
				inst.components.health.maxhealth + delta_health
			)

			inst.components.health:SetPercent(current_percent)
			inst.__growths_health = total_growths
		end
  	end

  	if inst.components.combat and inst.__growths_damage ~= nil then
  		if inst.__origin_damagemultipler then
			local delta_multiplier = delta_damage_rate * inst.__origin_damagemultipler

			-- print("DELTA DAMAGE MULT ", inst, delta_multiplier)
			local basemultiplier = inst.components.combat.damagemultiplier or 1
			inst.components.combat.damagemultiplier =
				math.max(inst.__origin_damagemultipler, basemultiplier + delta_multiplier)
		end

		if inst.__origin_areahitdamagepercent ~= nil and inst.components.combat.areahitdamagepercent ~= nil then
			local delta_multiplier = delta_damage_rate * inst.__origin_areahitdamagepercent

			-- print("DELTA AREA DAMAGE MULT ", inst, delta_multiplier)
			inst.components.combat.areahitdamagepercent = math.max(
				inst.__origin_areahitdamagepercent,
				inst.components.combat.areahitdamagepercent + delta_multiplier
			)
		end

		inst.__growths_damage = total_growths
  	end
end

local function OnCyclesChanged(inst, cycles)
	Grow(inst)
end

local function OnStopFollowing(inst)
	-- print("STOP FOLLOWING")
	Grow(inst)
end

local function OnStartFollowing(inst)
	-- print("START FOLLOWING")
	Grow(inst)
end

local blacklist = {}

local function MakePrefabGrowth(inst)
	if not GLOBAL.TheWorld.ismastersim then
    	return
  	end

  	if inst:HasTag("player") then
  		return
  	end

  	if inst:HasTag("shadow") then
  		return
  	end

  	if blacklist[inst.prefab] then
  		return
  	end

  	if not(
  		inst:HasTag("monster")
  		or inst:HasTag("animal")
  		or inst:HasTag("character")
  		or inst:HasTag("insect")
  	) then
  		return
  	end

  	if not(inst.components.combat and inst.components.health) then
  		return
  	end

  	inst.__growths_health = 0
  	inst.__growths_damage = 0
  	inst.__origin_maxhealth = inst.components.health.maxhealth
  	inst.__origin_damagemultipler = inst.components.combat.damagemultiplier or 1
  	inst.__origin_areahitdamagepercent = inst.components.combat.areahitdamagepercent

  	-- print("ORIGIN MAX HEALTH ", inst.__origin_maxhealth)

	Grow(inst)

	local oldSetMaxHealth = inst.components.health.SetMaxHealth

	inst.components.health.SetMaxHealth = function(comp, amount, ...)
		oldSetMaxHealth(comp, amount, ...)

		-- print("SET MAX HEALTH ", amount)

		-- Reset health growth
		inst.__origin_maxhealth = amount
		inst.__growths_health = 0
		Grow(inst)
	end

	inst:WatchWorldState("cycles", OnCyclesChanged)
	inst:ListenForEvent("stopfollowing", OnStopFollowing)
	inst:ListenForEvent("startfollowing", OnStartFollowing)
end

AddPrefabPostInitAny(MakePrefabGrowth)
