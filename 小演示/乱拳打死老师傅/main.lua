--- Generated by h-lua(https://github.com/h-lua/h-lua)

require "h-lua" -- h-lua库
require "scripts.alias" -- alias h-lua库别称（参考）
require "scripts.setup" -- setup 游戏准备
require "scripts.skill" -- skill 技能
require "scripts.ui" -- UI

-- h-lua main function 主函数入口
-- The game starts here 游戏从main函数开始运行
function main()

    SETUP()
    SKILL()
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
            x = math.random(500, 1500),
            y = math.random(500, 1500),
        })
    end

end