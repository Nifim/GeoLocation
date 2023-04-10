_addon = {}
_addon.name = 'GeoLocation'
_addon.version = '1.1.0'
_addon.author = 'Nifim'
_addon.commands = {'geo', 'geolocation'}

local geo_location = {}

require('sets')
require('logger')
require('strings')
local packets = require('packets')

local geo_spells = {}
local function load_geo_spells()
    local res = require('resources')
    local learned_spells = windower.ffxi.get_spells()

    for key, value in pairs(res.spells) do
        if learned_spells[key] and value.type == 'Geomancy' and value.en:match('^Geo-') then
            geo_spells[value.en:lower()] = value
        end
    end
end
load_geo_spells()

function geo_location.command(raw_spell, raw_primaty_target, ...)
    local location_args = {...}

    local spell = geo_location.get_spell(raw_spell)
    local primary_target = windower.ffxi.get_mob_by_target(raw_primaty_target)

    local location_target
    if #location_args == 1 then
        location_target = geo_location.get_target(location_args[1])
    elseif #location_args >= 2 then
        local axis1 = location_args[1]:lower()
        local axis2 = location_args[3]:lower()
        location_target = {
            [axis1] = tonumber(location_args[2] + primary_target[axis1]),
            [axis2] = tonumber(location_args[4] + primary_target[axis2]),
            z = primary_target.z,
        }
    else
        location_target = {
            x = 0,
            y = 0,
            z = 0,
        }
    end

    if primary_target and location_target and spell then
        geo_location.cast(spell, primary_target, location_target)
    end
end
windower.register_event('addon command', geo_location.command)

function geo_location.get_spell(spell_name)
    spell_name = spell_name:lower()
    for key, value in pairs(geo_spells) do
        if key:find(spell_name, 1, true) then
            return value
        end
    end
end

function geo_location.get_target(raw_target)
    local target
    local pattern = '<([^<>]+)>'
    local by_target = raw_target:match(pattern)
    if by_target then
        target = windower.ffxi.get_mob_by_target(by_target)
    elseif raw_target:match('%d+') then
        local id = tonumber(raw_target)
        target = windower.ffxi.get_mob_by_id(id)
    else
        target = geo_location.get_target_by_name(raw_target)
    end

    return target
end

function geo_location.get_target_by_name(name)
    local pattern = string.format('^%s', name:gsub("^%l", string.upper))

    local matches = {}
    local mob_array = windower.ffxi.get_mob_array()
    for _, mob in pairs(mob_array) do
        if mob.name:match(pattern) then
            table.insert(matches, mob)
        end
    end

    if #matches == 1 then
        return matches[1]
    elseif #matches == 0 then
        print(string.format('No matches found for: %s', name))
    else
        print(string.format('Too many matchs for: %s', name))
        for _, match in ipairs(matches) do
            print(string.format('    %s', match.name))
        end
    end
end

function geo_location.cast(spell, target, target_location)
    local packet = packets.new('outgoing', 0x01A, {
        ["Target"] = target.id,
        ["Target Index"] = target.index,
        ["Category"] = 3,
        ["Param"] = spell.id,
        ["_unknown1"] = 0,
        ["X Offset"] = target_location.x - target.x,
        ["Y Offset"] = target_location.y - target.y,
        ["Z Offset"] = target_location.z - target.z
    })
    packets.inject(packet)
end

--[[
Copyright © 2023, Nifim
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Nifim nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL NIFIM BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
