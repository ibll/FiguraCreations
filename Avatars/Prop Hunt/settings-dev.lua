local settings = {}

settings.SECONDS_TO_RESNAP = 1

settings.BLOCKS = {
    {
        name = "Rotations",
        uniquePageID = "rotations",
        variants = {
            {
                name = "Crafting Table",
                blockID = "minecraft:crafting_table",
            },
            {
                name = "Hay (Sideways)",
                blockID = "minecraft:hay_block[axis=z]",
                rotate = "Limited"
            },
            {
                name = "Anvil",
                blockID = "minecraft:anvil",
                rotate = "LimitedFlipWE"
            },
            {
                name = "Magenta Glazed Terracotta",
                blockID = "minecraft:magenta_glazed_terracotta",
                rotate = "Any",
                offsetRot = 180,
            }
        }
    },
    {
        name = "Errors",
        uniquePageID = "errors",
        variants = {
            {
                
            },
            {
                blockID = "minecraft:stone"
            },
            {
                name = "Wrong ID",
                blockID = "minecraft:bullshitID"
            },
            {
                name = "Wrong Rot",
                rotate = "Incorrect",
                blockID = "minecraft:stone"
            }
        }
    }
}

settings.DEFAULT_BLOCK = settings.BLOCKS[1].variants[1]

return settings
