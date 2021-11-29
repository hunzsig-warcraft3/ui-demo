--- Generated by h-lua-cli(https://github.com/hunzsig-warcraft3/h-lua-sdk)

require "h-lua" -- h-lua库
require "scripts.alias" -- alias h-lua库别称（参考）
require "scripts.setup" -- setup 游戏准备
require "scripts.ui" -- UI

-- h-lua main function 主函数入口
-- The game starts here 游戏从main函数开始运行
function main()

    SETUP()
    UI()

    print("hello world!")
    echo("你好，世界！")

    hitem.create({
        id = hslk.n2i("物理学圣剑"),
        x = 100,
        y = 0,
    })

    hunit.create({
        whichPlayer = hplayer.players[1],
        id = hslk.n2i("剑人"),
        x = 0,
        y = 0,
        isOpenSlot = true,
    })
    for _ = 1, 10 do
        henemy.create({
            whichPlayer = hplayer.players[1],
            id = hslk.n2i("天选勇者"),
            x = math.random(500,1500),
            y = math.random(500,1500),
        })
    end

    --[[
        无敌斩
        options = {
            sourceUnit, --伤害来源（必须有！不管有没有伤害）
            targetUnit, --冲击的目标单位（必须有）
            qty = 1, --（跳跃次数，默认1）
            radius = 0, --（选目标半径范围，默认0无效）
            speed = 10, --冲击的速度（可选的，默认10，0.02秒的移动距离,大概1秒500px)
            filter = [function], --必须有
            effectMovement = nil, --移动过程，每个间距的特效（可选的，采用的0秒删除法，请使用explode类型的特效）
            damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
            damageType = {CONST_DAMAGE_TYPE} --伤害的类型,注意是table（可选）
            damageEnd = 0, --移动结束时对目标的伤害（可选的，默认为0）
        }
    ]]
    WUDIZHAN = function(options)

        local qty = options.qty or 1
        local radius = options.radius or 0
        if (radius <= 0) then
            print_err("reflex: -radius")
            return
        end
        if (options.sourceUnit == nil) then
            print_err("reflex: -sourceUnit")
            return
        end
        if (type(options.filter) ~= "function") then
            print_err("reflex: -filter")
            return
        end
        if (options.targetUnit == nil) then
            print_err("reflex: -target")
            return
        end
        options.x = nil
        options.y = nil
        options.arrowUnit = options.sourceUnit

        options.onEnding = function(x, y)
            qty = qty - 1
            hunit.animate(options.sourceUnit,"attack")
            htime.setTimeout(0.3,function(curTimer)
                curTimer.destroy()
                if (qty >= 1) then
                    local g = hgroup.createByXY(x, y, radius, options.filter)
                    local closer = hgroup.getClosest(g, x, y)
                    if (closer ~= nil) then
                        options.prevUnit = options.targetUnit
                        options.targetUnit = closer
                        hskill.leap(options)
                    end
                end
            end)

        end
        hskill.leap(options)
    end
end