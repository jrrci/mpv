-- Define the function to open a URL in the default web browser
function open_url()
    local url = "https://myanimelist.net/animelist/Plaintiff?status=1"
    os.execute('start "" "' .. url .. '"')
end

-- Register the keybind Alt+M to open the URL
mp.add_key_binding("Alt+m", "open_url", open_url)
