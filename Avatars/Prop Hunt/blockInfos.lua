local blockInfos = {
    {
        name = "Natural",
        -- blockID = "minecraft:stone",
        uniquePageID = "",
        variants = {
            {
                name = "Hello"
            }
        }
    },
    {
        name = "Dirt",
        blockID = "minecraft:dirt",
        bone = "Block",
        texture = "minecraft:textures/block/dirt.png",
    },
    {
        name = "Cobblestone",
        blockID = "minecraft:cobblestone",
        bone = "Block",
        texture = "minecraft:textures/block/cobblestone.png",
    },
    {
        name = "Bedrock",
        blockID = "minecraft:bedrock",
        bone = "Block",
        texture = "minecraft:textures/block/bedrock.png",
    },
    {
        name = "Lantern",
        blockID = "minecraft:lantern",
        bone = "Lantern",
        texture = "minecraft:textures/block/lantern.png",
    },
    {
        name = "Crafting Table",
        blockID = "minecraft:crafting_table",
        bone = "Block",
        textures = {
            Bottom = "minecraft:textures/block/oak_planks.png",
            Top = "minecraft:textures/block/crafting_table_top.png",
            North = "minecraft:textures/block/crafting_table_front.png",
            South = "minecraft:textures/block/crafting_table_side.png",
            East = "minecraft:textures/block/crafting_table_side.png",
            West = "minecraft:textures/block/crafting_table_front.png",
        },
    },
    {
        name = "Anvil",
        blockID = "minecraft:anvil",
        rotate = true,
        bone = "Anvil",
        textures = {
            TopTop = "minecraft:textures/block/anvil_top.png",
            TopBody = "minecraft:textures/block/anvil.png",
            Middle = "minecraft:textures/block/anvil.png",
            LowerMid = "minecraft:textures/block/anvil.png",
            Base = "minecraft:textures/block/anvil.png",
        },
    },
    {
        name = "Wool",
        uniquePageID = "wool",
        variants = {
            {
                name = "White Wool",
                blockID = "minecraft:white_wool",
                bone = "Block",
                texture = "minecraft:textures/block/white_wool.png"
            },
            {
                name = "Light Gray Wool",
                blockID = "minecraft:light_gray_wool",
                bone = "Block",
                texture = "minecraft:textures/block/light_gray_wool.png"
            },
            {
                name = "Gray Wool",
                blockID = "minecraft:gray_wool",
                bone = "Block",
                texture = "minecraft:textures/block/gray_wool.png"
            },
            {
                name = "Black Wool",
                blockID = "minecraft:black_wool",
                bone = "Block",
                texture = "minecraft:textures/block/black_wool.png"
            },
            {
                name = "Brown Wool",
                blockID = "minecraft:brown_wool",
                bone = "Block",
                texture = "minecraft:textures/block/brown_wool.png"
            },
            {
                name = "Red Wool",
                blockID = "minecraft:red_wool",
                bone = "Block",
                texture = "minecraft:textures/block/red_wool.png"
            },
            {
                name = "Orange Wool",
                blockID = "minecraft:orange_wool",
                bone = "Block",
                texture = "minecraft:textures/block/orange_wool.png"
            },
            {
                name = "Yellow Wool",
                blockID = "minecraft:yellow_wool",
                bone = "Block",
                texture = "minecraft:textures/block/yellow_wool.png"
            },
            {
                name = "Lime Wool",
                blockID = "minecraft:lime_wool",
                bone = "Block",
                texture = "minecraft:textures/block/lime_wool.png"
            },
            {
                name = "Green Wool",
                blockID = "minecraft:green_wool",
                bone = "Block",
                texture = "minecraft:textures/block/green_wool.png"
            },
            {
                name = "Cyan Wool",
                blockID = "minecraft:cyan_wool",
                bone = "Block",
                texture = "minecraft:textures/block/cyan_wool.png"
            },
            {
                name = "Light Blue Wool",
                blockID = "minecraft:light_blue_wool",
                bone = "Block",
                texture = "minecraft:textures/block/light_blue_wool.png"
            },
            {
                name = "Blue Wool",
                blockID = "minecraft:blue_wool",
                bone = "Block",
                texture = "minecraft:textures/block/blue_wool.png"
            },
            {
                name = "Purple Wool",
                blockID = "minecraft:purple_wool",
                bone = "Block",
                texture = "minecraft:textures/block/purple_wool.png"
            },
            {
                name = "Magenta Wool",
                blockID = "minecraft:magenta_wool",
                bone = "Block",
                texture = "minecraft:textures/block/magenta_wool.png"
            },
            {
                name = "Pink Wool",
                blockID = "minecraft:pink_wool",
                bone = "Block",
                texture = "minecraft:textures/block/pink_wool.png"
            }
        }
    }
}

local defaultBlockInfo = blockInfos[2]

return blockInfos, defaultBlockInfo