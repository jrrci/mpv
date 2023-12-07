local mp = require "mp"

function openMALPage()
    local filename = mp.get_property("filename")

    if not filename then
        mp.osd_message("No filename available")
        return
    end

    -- Remove the file extension
    local baseName = filename:gsub("%..*$", "")

    -- Remove specific patterns enclosed in square brackets and parentheses
    baseName = baseName:gsub("%b[]", "")  -- Remove patterns enclosed in square brackets
    baseName = baseName:gsub("%b()", "")  -- Remove patterns enclosed in parentheses

    -- Remove season and episode patterns like S01E01
    baseName = baseName:gsub("S%d+E%d+", "")

    -- Remove single-letter "S" followed by a number
    baseName = baseName:gsub("S%d+", "")

    -- Split the baseName using dashes as a delimiter and keep the portion before the dash
    baseName = baseName:match("^(.-)%s*%-") or baseName

    -- Remove digits
    baseName = baseName:gsub("%d", "")  -- Remove digits/numbers

    -- Remove common torrent-related terms
    local terms_to_exclude = {
        "RAW", "WEB", "CAM", "CAMRIP", "HDRip", "BRRip", "DVDRip", "TS", "HDTS", "HDTC",
        "WEB-DL", "WEBRip", "HDCAM", "DVDScr", "BluRay", "BluRay 720p", "BluRay 1080p", "4K", "UHD",
        "REMUX", "HC", "PROPER", "Unrated", "Extended Cut", "DUAL AUDIO", "Episode"
    }

    for _, term in ipairs(terms_to_exclude) do
        baseName = baseName:gsub(term, "")
    end

    -- Trim extra spaces at the beginning and end
    baseName = baseName:match("^%s*(.-)%s*$")

    if baseName == "" then
        mp.osd_message("No valid search query remaining")
        return
    end

    -- Construct the MAL search URL using the cleaned filename as the query
    local mal_url = "https://myanimelist.net/anime.php?q=" .. baseName

    -- Open the MAL page for the anime in the default web browser
    local cmd = 'start "" "' .. mal_url .. '"'
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    if result then
        mp.osd_message("Searching MAL for " .. baseName)
    else
        mp.osd_message("Failed to open MAL page")
    end
end

mp.add_key_binding("ctrl+m", "open_mal_page", openMALPage)
