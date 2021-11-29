--- Generated by h-lua-sdk(https://github.com/hunzsig-warcraft3/h-lua-sdk)

local skill = hslk_ability({
    Name = "伪魂之挽歌",
    Hotkey = "Q",
    _parent = "ANcl",
    DataA = { 0 },
    EffectArt = "",
    TargetArt = "",
    CasterArt = "",
    Cool = { 2 },
    DataB = { 0 },
    Cost = { 0 },
    DataD = { 0 },
    DataC = { 1 },
    Rng = { 1000 },
    DataF = { "channel" },
    targs = { "enemies" },
    DataE = { 0 },
    _onSkillEffect = _onSkillEffect(function(evtData)
        local u = evtData.triggerUnit
        local x = hunit.x(u)
        local y = hunit.y(u)
        for i = 1, 10 do
            local ang = 36 * i
            local xy = math.polarProjection(x,y,2000,ang)
            local onlyOne = {}
            hskill.missile({
                missile = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
                scale = 2,
                hover = 50,
                speed = 1000,
                sourceUnit = u,
                targetX = xy.x,
                targetY = xy.y,
                onMove = function(unit,_, x, y)
                    local g = hgroup.createByXY(x, y, 100, function(filterUnit)
                        return his.enemy(unit, filterUnit) and his.alive(filterUnit)
                    end)
                    hgroup.forEach(g, function(enumUnit, _)
                        --不重复伤害
                        if (onlyOne[enumUnit] == nil) then
                            onlyOne[enumUnit] = 1
                            hskill.damage({
                                sourceUnit = unit, --伤害来源(可选)
                                targetUnit = enumUnit, --目标单位
                                damage = hattr.get(unit,"str") * 10, --实际伤害
                                damageSrc = CONST_DAMAGE_SRC.skill,
                                damageType = { CONST_DAMAGE_TYPE.dark }
                            })
                        end
                    end)
                    g = nil
                    return true
                end
            })
        end
    end)
})

hslk_unit({
    _parent = "hpea",
    Name = "天选勇者",
    HP = 10000,
    abilList = string.implode(",", { skill._id }),
    Builds = ""
})

hslk_unit({
    _parent = "Obla",
    Name = "剑人",
    HP = 10000,
    abilList = string.implode(",", { skill._id }),
})