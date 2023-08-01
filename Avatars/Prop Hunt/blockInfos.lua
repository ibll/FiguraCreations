local blockInfos = {
    {
        name = "Natural",
        blockID = "minecraft:stone",
        uniquePageID = "natural",
        variants = {
            {
                name = "Dirt",
                blockID = "minecraft:dirt",
                bone = "Block",
                texture = "minecraft:textures/block/dirt.png",
            },
            {
                name = "Sand",
                blockID = "minecraft:sand",
                bone = "Block",
                texture = "minecraft:textures/block/sand.png",
            },
            {
                name = "Stone",
                blockID = "minecraft:stone",
                bone = "Block",
                texture = "minecraft:textures/block/stone.png",
            },
            {
                name = "Cobblestone",
                blockID = "minecraft:cobblestone",
                bone = "Block",
                texture = "minecraft:textures/block/cobblestone.png",
            },
            {
                name = "Andesite",
                blockID = "minecraft:andesite",
                bone = "Block",
                texture = "minecraft:textures/block/andesite.png",
            },
            {
                name = "Diorite",
                blockID = "minecraft:diorite",
                bone = "Block",
                texture = "minecraft:textures/block/diorite.png"
            },
            {
                name = "Granite",
                blockID = "minecraft:granite",
                bone = "Block",
                texture = "minecraft:textures/block/granite.png",
            },
            {
                name = "Bedrock",
                blockID = "minecraft:bedrock",
                bone = "Block",
                texture = "minecraft:textures/block/bedrock.png",
            },
        }
    },
    {
        name = "Man-Made",
        uniquePageID = "man-made",
        variants = {
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
                name = "Lantern",
                blockID = "minecraft:lantern",
                bone = "Lantern",
                texture = "minecraft:textures/block/lantern.png",
            },
            {
                name = "Anvil",
                blockID = "minecraft:anvil",
                rotate = "Any",
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
                name = "Hay Bale",
                blockID = "minecraft:hay_block",
                bone = "Block",
                actionTexture = "Click",
                textures = {
                    Bottom = "minecraft:textures/block/hay_block_top.png",
                    Top = "minecraft:textures/block/hay_block_top.png",
                    North = "minecraft:textures/block/hay_block_side.png",
                    South = "minecraft:textures/block/hay_block_side.png",
                    East = "minecraft:textures/block/hay_block_side.png",
                    West = "minecraft:textures/block/hay_block_side.png",
                },
                rightClick = {
                    name = "Hay Bale",
                    blockID = "minecraft:hay_block",
                    bone = "Sideways",
                    rotate = "Limited",
                    textures = {
                        Bottom = "minecraft:textures/block/hay_block_side.png",
                        Top = "minecraft:textures/block/hay_block_side.png",
                        North = "minecraft:textures/block/hay_block_top.png",
                        South = "minecraft:textures/block/hay_block_top.png",
                        East = "minecraft:textures/block/hay_block_side.png",
                        West = "minecraft:textures/block/hay_block_side.png",
                    }
                }
            },
        },
    },
    {
        name = "Colors",
        uniquePageID = "colors",
        blockID = "minecraft:pink_concrete",
        variants = {
            {
                name = "Wool",
                uniquePageID = "colors.wool",
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
            },
            {
                name = "Concrete",
                uniquePageID = "colors.concrete",
                variants = {
                    {
                        name = "White Concrete",
                        blockID = "minecraft:white_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/white_concrete.png"
                    },
                    {
                        name = "Light Gray Concrete",
                        blockID = "minecraft:light_gray_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/light_gray_concrete.png"
                    },
                    {
                        name = "Gray Concrete",
                        blockID = "minecraft:gray_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/gray_concrete.png"
                    },
                    {
                        name = "Black Concrete",
                        blockID = "minecraft:black_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/black_concrete.png"
                    },
                    {
                        name = "Brown Concrete",
                        blockID = "minecraft:brown_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/brown_concrete.png"
                    },
                    {
                        name = "Red Concrete",
                        blockID = "minecraft:red_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/red_concrete.png"
                    },
                    {
                        name = "Orange Concrete",
                        blockID = "minecraft:orange_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/orange_concrete.png"
                    },
                    {
                        name = "Yellow Concrete",
                        blockID = "minecraft:yellow_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/yellow_concrete.png"
                    },
                    {
                        name = "Lime Concrete",
                        blockID = "minecraft:lime_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/lime_concrete.png"
                    },
                    {
                        name = "Green Concrete",
                        blockID = "minecraft:green_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/green_concrete.png"
                    },
                    {
                        name = "Cyan Concrete",
                        blockID = "minecraft:cyan_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/cyan_concrete.png"
                    },
                    {
                        name = "Light Blue Concrete",
                        blockID = "minecraft:light_blue_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/light_blue_concrete.png"
                    },
                    {
                        name = "Blue Concrete",
                        blockID = "minecraft:blue_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/blue_concrete.png"
                    },
                    {
                        name = "Purple Concrete",
                        blockID = "minecraft:purple_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/purple_concrete.png"
                    },
                    {
                        name = "Magenta Concrete",
                        blockID = "minecraft:magenta_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/magenta_concrete.png"
                    },
                    {
                        name = "Pink Concrete",
                        blockID = "minecraft:pink_concrete",
                        bone = "Block",
                        texture = "minecraft:textures/block/pink_concrete.png"
                    }
                }
            },
            {
                name = "Glazed Terracotta",
                uniquePageID = "colors.glazed_terracotta",
                variants = {
                    {
                        name = "White Glazed Terracotta",
                        blockID = "minecraft:white_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/white_glazed_terracotta.png"
                    },
                    {
                        name = "Light Gray Glazed Terracotta",
                        blockID = "minecraft:light_gray_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/light_gray_glazed_terracotta.png"
                    },
                    {
                        name = "Gray Glazed Terracotta",
                        blockID = "minecraft:gray_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/gray_glazed_terracotta.png"
                    },
                    {
                        name = "Black Glazed Terracotta",
                        blockID = "minecraft:black_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/black_glazed_terracotta.png"
                    },
                    {
                        name = "Brown Glazed Terracotta",
                        blockID = "minecraft:brown_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/brown_glazed_terracotta.png"
                    },
                    {
                        name = "Red Glazed Terracotta",
                        blockID = "minecraft:red_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/red_glazed_terracotta.png"
                    },
                    {
                        name = "Orange Glazed Terracotta",
                        blockID = "minecraft:orange_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/orange_glazed_terracotta.png"
                    },
                    {
                        name = "Yellow Glazed Terracotta",
                        blockID = "minecraft:yellow_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/yellow_glazed_terracotta.png"
                    },
                    {
                        name = "Lime Glazed Terracotta",
                        blockID = "minecraft:lime_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/lime_glazed_terracotta.png"
                    },
                    {
                        name = "Green Glazed Terracotta",
                        blockID = "minecraft:green_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/green_glazed_terracotta.png"
                    },
                    {
                        name = "Cyan Glazed Terracotta",
                        blockID = "minecraft:cyan_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/cyan_glazed_terracotta.png"
                    },
                    {
                        name = "Light Blue Glazed Terracotta",
                        blockID = "minecraft:light_blue_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/light_blue_glazed_terracotta.png"
                    },
                    {
                        name = "Blue Glazed Terracotta",
                        blockID = "minecraft:blue_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/blue_glazed_terracotta.png"
                    },
                    {
                        name = "Purple Glazed Terracotta",
                        blockID = "minecraft:purple_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/purple_glazed_terracotta.png"
                    },
                    {
                        name = "Magenta Glazed Terracotta",
                        blockID = "minecraft:magenta_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/magenta_glazed_terracotta.png"
                    },
                    {
                        name = "Pink Glazed Terracotta",
                        blockID = "minecraft:pink_glazed_terracotta",
                        bone = "Block",
                        rotate = "Any",
                        texture = "minecraft:textures/block/pink_glazed_terracotta.png"
                    }
                }
            },
        }
    },
}

local defaultBlockInfo = blockInfos[1].variants[1]

return blockInfos, defaultBlockInfo
