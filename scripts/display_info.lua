local options = require("mp.options")
local msg = require("mp.msg")

local settings = {
    key_binding = "Ctrl+t",
    display_duration = 86400, -- OSD display duration in seconds
    osd_position_x = 0.0, -- Horizontal alignment (0.0 = left, 1.0 = right)
    osd_position_y = 0.0, -- Vertical alignment (0.0 = top, 1.0 = bottom)
}

options.read_options(settings)

local function format_time(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local osd_visible = false -- Variable to track OSD visibility

local function show_end_time()
    osd_visible = not osd_visible -- Toggle OSD visibility
    if osd_visible then
        local remaining_time = mp.get_property_number("playtime-remaining", -1)
        local current_time = mp.get_property_number("time-pos", -1)
        local total_time = mp.get_property_number("duration", -1)
        local playback_speed = mp.get_property_number("speed", 1.0) -- Get the playback speed
        local file_name = mp.get_property("filename") -- Without file extension; add "/no-ext" to remove the file extension e.g.("filename/no-ext")

        if remaining_time >= 0 then
            local current_time_formatted = format_time(current_time)
            local total_time_formatted = format_time(total_time)

            local current_local_time = os.date("%I:%M:%S %p")
            local end_time = os.date("%I:%M:%S %p", os.time() + remaining_time)
            local remaining_time_formatted = format_time(remaining_time)

            -- Calculate the total duration
            local total_duration_formatted = format_time(total_time)

            -- Define the message components with the desired layout
            local message = string.format(
                "Filename: %s\n\nLocal time: %s\nCurrent: %s / %s\n\nTime remaining: %s\nSpeed: %.2fx\n\nVideo ends at: %s",
                file_name, current_local_time, current_time_formatted, total_duration_formatted, remaining_time_formatted, playback_speed, end_time
            )

            -- Set the OSD bar alignment
            mp.set_property_number("osd-bar-align-x", settings.osd_position_x)
            mp.set_property_number("osd-bar-align-y", settings.osd_position_y)

            mp.osd_message(message, settings.display_duration)
        else
            mp.osd_message("Cannot determine remaining time", settings.display_duration)
        end
    else
        mp.osd_message("") -- Clear OSD when toggling off
    end
end

mp.add_key_binding(settings.key_binding, "show-end-time", show_end_time)