--- Generated by h-lua(https://github.com/h-lua/h-lua)


local skill = hslk_ability({
    Name = "精灵球星爆",
    Ubertip = hcolor.greenLight("精灵球星爆"),
    Hotkey = "Q",
    _parent = "ANcl",
    DataA = { 0 },
    EffectArt = "",
    TargetArt = "",
    CasterArt = "",
    Cool = { 3 },
    DataB = { 1 },
    Cost = { 0 },
    DataD = { 0 },
    DataC = { 1 },
    Rng = { 1000 },
    DataF = { "channel" },
    targs = { "enemies" },
    DataE = { 0 },
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