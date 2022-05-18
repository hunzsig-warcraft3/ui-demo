--- Generated by h-lua(https://github.com/h-lua/h-lua)

require "h-lua" -- h-lua库
require "scripts.alias" -- alias h-lua库别称（参考）
require "scripts.setup" -- setup 游戏准备
require "scripts.ui" -- UI

-- h-lua main function 主函数入口
-- The game starts here 游戏从main函数开始运行
function main()

    SETUP()
    UI()

    THUNDER_ON_HEAD = function(options)
        local whichUnit = options.whichUnit
        local model = options.model
        local qty = options.qty or 1
        local height = options.height or 100
        if (whichUnit == nil or model == nil or qty <= 0) then
            return
        end
        local duration = options.duration or 0
        local radius = options.radius or 100
        if (duration <= 0) then
            duration = 0
        end
        local effs = {}
        for _ = 1, qty, 1 do
            table.insert(effs, cj.AddSpecialEffect(model, hunit.x(whichUnit), hunit.y(whichUnit)))
        end
        local angle = 180 / (qty - 1)
        local frequency = 0.02
        local ci = 0
        local call = options.call
        local callFrq = call.frequency or 1
        local callRadius = call.radius or 600
        htime.setInterval(frequency, function(curTimer)
            if (duration > 0) then
                duration = duration - frequency
                if (duration <= 0) then
                    curTimer.destroy()
                    for _, e in ipairs(effs) do
                        cj.DestroyEffect(e)
                    end
                    return
                end
            end
            if (his.unitDestroyed(whichUnit) or his.dead(whichUnit)) then
                curTimer.destroy()
                for _, e in ipairs(effs) do
                    cj.DestroyEffect(e)
                end
                return
            end
            ci = ci + frequency
            local ux = hunit.x(whichUnit)
            local uy = hunit.y(whichUnit)
            for i = 1, qty, 1 do
                local a = angle * (i - 1)
                local d = 0
                local h = 0
                if (angle == 0 or angle == 180) then
                    d = radius
                    h = 0
                elseif (angle == 90) then
                    d = 0
                    h = radius
                else
                    d = radius * math.cos(math_deg2rad * a)
                    h = radius * math.cos(math_deg2rad * (90 - a))
                end
                local f = hunit.getFacing(whichUnit)
                if (a < 90) then
                    f = f - 90
                else
                    f = f + 90
                end
                d = math.abs(d)
                h = math.abs(h)
                local px, py
                local z = height + h + hunit.z(whichUnit) + hunit.getFlyHeight(whichUnit)
                if (d > 0) then
                    px, py = math.polarProjection(ux, uy, d, f)
                else
                    px, py = ux, uy
                end
                hjapi.EXSetEffectXY(effs[i], px, py)
                hjapi.EXSetEffectZ(effs[i], z)
                if (type(call.action) == "function") then
                    if (ci >= callFrq) then
                        local g = hgroup.createByXY(px, py, callRadius,
                            function(filterUnit)
                                return his.alive(filterUnit) and his.enemy(whichUnit, filterUnit)
                            end
                        )
                        if (#g > 0) then
                            local tag = table.random(g)
                            call.action({
                                sourceUnit = whichUnit,
                                targetUnit = tag,
                                x = px,
                                y = py,
                                z = z
                            })
                        end
                        g = nil
                    end
                end
            end
            if (ci >= callFrq) then
                ci = 0
            end
        end)
    end

    local me = hunit.create({
        whichPlayer = hplayer.players[1],
        id = hslk.n2i("天选勇者"),
        x = 0,
        y = 0,
        isOpenSlot = true,
        attr = {
            life = "+1000",
            move = "+150",
        }
    })

    -- 头顶雷
    THUNDER_ON_HEAD({
        whichUnit = me,
        qty = 5,
        radius = 100,
        model = "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl",
        call = {
            frequency = 2.0,
            radius = 600,
            action = function(evtData)
                hlightning.xyz2xyz(
                    hlightning.type.shan_dian_lian_zhu,
                    evtData.x, evtData.y, evtData.z,
                    hunit.x(evtData.targetUnit), hunit.y(evtData.targetUnit), hunit.z(evtData.targetUnit),
                    0.2)
                local dmg = math.random(10, 99)
                hskill.damage({
                    sourceUnit = evtData.sourceUnit,
                    targetUnit = evtData.targetUnit,
                    damage = dmg,
                    damageSrc = CONST_DAMAGE_SRC.skill,
                    effect = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
                })
                hunit.addCurLife(evtData.sourceUnit, dmg)
            end
        }
    })

    henemy.create({
        id = hslk.n2i("被电小怪"),
        qty = 10,
        x = 300,
        y = 300,
        attr = {
            life = "=1000",
            move = "=50",
        }
    })

end