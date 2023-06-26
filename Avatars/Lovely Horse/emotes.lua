-- v1.1
EmotesAPI = {}

local savedEmoteList
local lastEmote

local function repeatLast()
	pings.emote(lastEmote.model, lastEmote.anim)
end

function EmotesAPI.init(emoteList, setPage, returnPage)
    savedEmoteList = emoteList

    local defaultEmote = savedEmoteList[1]
    lastEmote = {
        model = defaultEmote.model,
        anim = defaultEmote.anim
    }

    keybinds:newKeybind("Repeat Last Emote", "key.keyboard.m")
        :setOnPress(repeatLast)

    local emoteWheel = action_wheel:newPage("Emotes")

    for index, value in ipairs(savedEmoteList) do
        emoteWheel:newAction()
            :title(value.name)
            :item(value.item)
            :onLeftClick(function()
                pings.emote(value.model, value.anim)
                if returnPage then
                    action_wheel:setPage(returnPage)
                end
            end )
    end

    if returnPage then
        emoteWheel:newAction(8)
            :title("Back")
            :item('minecraft:barrier')
            :onLeftClick(function() action_wheel:setPage(returnPage) end)
    end

    if setPage then action_wheel:setPage(emoteWheel) end
    return emoteWheel
end

function EmotesAPI.tick()
	if player:isSprinting() then
		animations[lastEmote.model][lastEmote.anim]:stop()
	end
end

function pings.emote(model, anim)
    local last = animations[lastEmote.model][lastEmote.anim]
    local emote = animations[model][anim]

	if last.name == emote.name and
        emote:getPlayState() == "PLAYING" and
        emote:getTime() < emote:getLength() then
		return
	end
	last:stop()
	emote:play()

	lastEmote = {
        model = model,
        anim = anim
    }
end

return EmotesAPI