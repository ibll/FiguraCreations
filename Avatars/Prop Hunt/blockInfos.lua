-- blockInfos must be a table of
-- multiple blockInfo tables

-- while the line is fuzzy between them, these
-- are generally either groups or blocks

-- a group might look like this:
-- {
--     name* = String | The name of the group when hovered over in the action Wheel
--     uniquePageID* = String | The unique identifier for indexing the page. Duplicates will cause problems
--     variants* = Table of blockInfo tables (either groups or blocks) | Items to appear in the page when expanded
--     iconID = String | The minecraft item ID to appear in the action wheel. Fallbacks for this include a blockID or the first item in the variants key
--     rightClick = blockInfo table (either a group or block) | Alternate block or group to use, especially for alternate forms of blocks
-- }

-- a block might look like this:
-- {
--     name* = String | The name of the block when hovered over in the action wheel
--     blockID* = String | The minecraft block ID to set the player to
--     iconID = String | The minecraft item ID to appear in the action wheel
--     actionTexture = String | A registered texture to put on the action in the action wheel
--     rotate = "Any", "Limited", "LimitedFlipWE" | How the block should lock when snapping in place
--     offsetRot = Number | Degrees to turn the block at all times
--     rightClick = blockInfo table (either a group or block) | Alternate block or group to use, especially for alternate forms of blocks
-- }

-- Remember, groups can be within groups within rightClick's within groups and so on!

local blockInfos = {
    {
        name = "Natural",
        iconID = "minecraft:stone",
        uniquePageID = "natural",
        variants = {
            {
                name = "Dirt",
                blockID = "minecraft:dirt",
            },
            {
                name = "Sand",
                blockID = "minecraft:sand",
            },
            {
                name = "Stone",
                blockID = "minecraft:stone",
            },
            {
                name = "Cobblestone",
                blockID = "minecraft:cobblestone",
            },
            {
                name = "Andesite",
                blockID = "minecraft:andesite",
            },
            {
                name = "Diorite",
                blockID = "minecraft:diorite",
            },
            {
                name = "Granite",
                blockID = "minecraft:granite",
            },
            {
                name = "Bedrock",
                blockID = "minecraft:bedrock",
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
            },
            {
                name = "Lantern",
                blockID = "minecraft:lantern",
            },
            {
                name = "Anvil",
                blockID = "minecraft:anvil",
                rotate = "LimitedFlipWE",
            },
            {
                name = "Hay Bale",
                blockID = "minecraft:hay_block",
                actionTexture = "Click",
                rightClick = {
                    name = "Hay Bale",
                    blockID = "minecraft:hay_block[axis=z]",
                    rotate = "Limited",
                }
            },
        },
    },
    {
        name = "Colors",
        uniquePageID = "colors",
        iconID = "minecraft:pink_concrete",
        variants = {
            {
                name = "Wool",
                uniquePageID = "colors.wool",
                variants = {
                    {
                        name = "White Wool",
                        blockID = "minecraft:white_wool",
                    },
                    {
                        name = "Light Gray Wool",
                        blockID = "minecraft:light_gray_wool",
                    },
                    {
                        name = "Gray Wool",
                        blockID = "minecraft:gray_wool",
                    },
                    {
                        name = "Black Wool",
                        blockID = "minecraft:black_wool",
                    },
                    {
                        name = "Brown Wool",
                        blockID = "minecraft:brown_wool",
                    },
                    {
                        name = "Red Wool",
                        blockID = "minecraft:red_wool",
                    },
                    {
                        name = "Orange Wool",
                        blockID = "minecraft:orange_wool",
                    },
                    {
                        name = "Yellow Wool",
                        blockID = "minecraft:yellow_wool",
                    },
                    {
                        name = "Lime Wool",
                        blockID = "minecraft:lime_wool",
                    },
                    {
                        name = "Green Wool",
                        blockID = "minecraft:green_wool",
                    },
                    {
                        name = "Cyan Wool",
                        blockID = "minecraft:cyan_wool",
                    },
                    {
                        name = "Light Blue Wool",
                        blockID = "minecraft:light_blue_wool",
                    },
                    {
                        name = "Blue Wool",
                        blockID = "minecraft:blue_wool",
                    },
                    {
                        name = "Purple Wool",
                        blockID = "minecraft:purple_wool",
                    },
                    {
                        name = "Magenta Wool",
                        blockID = "minecraft:magenta_wool",
                    },
                    {
                        name = "Pink Wool",
                        blockID = "minecraft:pink_wool",
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
                    },
                    {
                        name = "Light Gray Concrete",
                        blockID = "minecraft:light_gray_concrete",
                    },
                    {
                        name = "Gray Concrete",
                        blockID = "minecraft:gray_concrete",
                    },
                    {
                        name = "Black Concrete",
                        blockID = "minecraft:black_concrete",
                    },
                    {
                        name = "Brown Concrete",
                        blockID = "minecraft:brown_concrete",
                    },
                    {
                        name = "Red Concrete",
                        blockID = "minecraft:red_concrete",
                    },
                    {
                        name = "Orange Concrete",
                        blockID = "minecraft:orange_concrete",
                    },
                    {
                        name = "Yellow Concrete",
                        blockID = "minecraft:yellow_concrete",
                    },
                    {
                        name = "Lime Concrete",
                        blockID = "minecraft:lime_concrete",
                    },
                    {
                        name = "Green Concrete",
                        blockID = "minecraft:green_concrete",
                    },
                    {
                        name = "Cyan Concrete",
                        blockID = "minecraft:cyan_concrete",
                    },
                    {
                        name = "Light Blue Concrete",
                        blockID = "minecraft:light_blue_concrete",
                    },
                    {
                        name = "Blue Concrete",
                        blockID = "minecraft:blue_concrete",
                    },
                    {
                        name = "Purple Concrete",
                        blockID = "minecraft:purple_concrete",
                    },
                    {
                        name = "Magenta Concrete",
                        blockID = "minecraft:magenta_concrete",
                    },
                    {
                        name = "Pink Concrete",
                        blockID = "minecraft:pink_concrete",
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
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Light Gray Glazed Terracotta",
                        blockID = "minecraft:light_gray_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Gray Glazed Terracotta",
                        blockID = "minecraft:gray_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Black Glazed Terracotta",
                        blockID = "minecraft:black_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Brown Glazed Terracotta",
                        blockID = "minecraft:brown_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Red Glazed Terracotta",
                        blockID = "minecraft:red_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Orange Glazed Terracotta",
                        blockID = "minecraft:orange_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Yellow Glazed Terracotta",
                        blockID = "minecraft:yellow_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Lime Glazed Terracotta",
                        blockID = "minecraft:lime_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Green Glazed Terracotta",
                        blockID = "minecraft:green_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Cyan Glazed Terracotta",
                        blockID = "minecraft:cyan_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Light Blue Glazed Terracotta",
                        blockID = "minecraft:light_blue_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Blue Glazed Terracotta",
                        blockID = "minecraft:blue_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Purple Glazed Terracotta",
                        blockID = "minecraft:purple_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Magenta Glazed Terracotta",
                        blockID = "minecraft:magenta_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    },
                    {
                        name = "Pink Glazed Terracotta",
                        blockID = "minecraft:pink_glazed_terracotta",
                        rotate = "Any",
                        offsetRot = 180,
                    }
                }
            },
        }
    },
}

local defaultBlockInfo = blockInfos[1].variants[1]

return blockInfos, defaultBlockInfo
