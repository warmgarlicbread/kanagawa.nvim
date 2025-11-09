local M = {}

---@class PaletteColors
local palette = {
    -- Bg Shades (Tomorrow Night)
    sumiInk0 = "#1d1f21",
    sumiInk1 = "#1d1f21",
    sumiInk2 = "#1d1f21",
    sumiInk3 = "#1d1f21",
    sumiInk4 = "#282a2e",
    sumiInk5 = "#373b41",
    sumiInk6 = "#707880",

    -- Popup and Floats
    waveBlue1 = "#2D4F67",
    waveBlue2 = "#223249",

    -- Diff and Git
    winterGreen = "#2B3328",
    winterYellow = "#49443C",
    winterRed = "#43242B",
    winterBlue = "#252535",
    autumnGreen = "#b5bd68",
    autumnRed = "#cc6666",
    autumnYellow = "#f0c674",

    -- Diag
    samuraiRed = "#cc6666",
    roninYellow = "#f0c674",
    waveAqua1 = "#7AA89F",
    dragonBlue = "#81a2be",

    -- Fg and Comments
    oldWhite = "#707880",
    fujiWhite = "#c5c8c6",
    fujiGray = "#707880",

    oniViolet = "#b294bb",
    oniViolet2 = "#b294bb",
    crystalBlue = "#81a2be",
    springViolet1 = "#b294bb",
    springViolet2 = "#9fb5c9",
    springBlue = "#9fb5c9",
    lightBlue = "#81a2be",
    waveAqua2 = "#87a987",

    -- Main colors
    waveRed = "#cc6666",
    surimiOrange = "#de935f",
    carpYellow = "#f0c674",
    springGreen = "#b5bd68",
    sakuraPink = "#c4746e",

    -- Dragon theme
    dragonInk0 = "#0d0c0c",
    dragonInk1 = "#12120f",
    dragonInk2 = "#1D1C19",
    dragonInk3 = "#181616",
    dragonInk4 = "#282727",
    dragonInk5 = "#393836",
    dragonInk6 = "#625e5a",

    dragonBlack0 = "#0d0c0c",
    dragonBlack1 = "#12120f",
    dragonBlack2 = "#1D1C19",
    dragonBlack3 = "#181616",
    dragonBlack4 = "#282727",
    dragonBlack5 = "#393836",
    dragonBlack6 = "#625e5a",

    dragonWhite = "#c5c8c6",
    dragonGreen = "#b5bd68",
    dragonGreen2 = "#87a987",
    dragonPink = "#c4746e",
    dragonOrange = "#de935f",
    dragonOrange2 = "#de935f",
    dragonGray = "#707880",
    dragonGray2 = "#707880",
    dragonGray3 = "#373b41",
    dragonBlue2 = "#81a2be",
    dragonViolet = "#b294bb",
    dragonRed = "#cc6666",
    dragonAqua = "#87a987",
    dragonAsh = "#373b41",
    dragonTeal = "#7AA89F",
    dragonYellow = "#f0c674",

    -- Lotus theme
    lotusInk0 = "#545454",
    lotusInk1 = "#545454",
    lotusInk2 = "#43436c",
    lotusGray = "#707880",
    lotusGray2 = "#707880",
    lotusGray3 = "#707880",
    lotusWhite0 = "#d5cea3",
    lotusWhite1 = "#dcd5ac",
    lotusWhite2 = "#e5ddb0",
    lotusWhite3 = "#f2ecbc",
    lotusWhite4 = "#e7dba0",
    lotusWhite5 = "#e4d794",
    lotusViolet1 = "#a09cac",
    lotusViolet2 = "#766b90",
    lotusViolet3 = "#c9cbd1",
    lotusViolet4 = "#624c83",
    lotusBlue1 = "#c7d7e0",
    lotusBlue2 = "#b5cbd2",
    lotusBlue3 = "#9fb5c9",
    lotusBlue4 = "#4d699b",
    lotusBlue5 = "#5d57a3",
    lotusGreen = "#b5bd68",
    lotusGreen2 = "#87a987",
    lotusGreen3 = "#87a987",
    lotusPink = "#c4746e",
    lotusOrange = "#de935f",
    lotusOrange2 = "#de935f",
    lotusYellow = "#f0c674",
    lotusYellow2 = "#f0c674",
    lotusYellow3 = "#f0c674",
    lotusYellow4 = "#f0c674",
    lotusRed = "#cc6666",
    lotusRed2 = "#cc6666",
    lotusRed3 = "#cc6666",
    lotusRed4 = "#cc6666",
    lotusAqua = "#87a987",
    lotusAqua2 = "#7AA89F",
    lotusTeal1 = "#7AA89F",
    lotusTeal2 = "#7AA89F",
    lotusTeal3 = "#7AA89F",
    lotusCyan = "#81a2be",
}

--- Generate colors based on the provided palette and config options
--- @param opts? { colors?: table, theme?: string }
--- @return { theme: ThemeColors, palette: PaletteColors}
function M.setup(opts)
    opts = opts or {}
    local override_colors = opts.colors or require("kanagawa").config.colors
    local theme = opts.theme or require("kanagawa")._CURRENT_THEME

    if not theme then
        theme = vim.o.background == "light" and "lotus" or "wave"
    end

    -- Add to and/or override palette_colors
    local updated_palette_colors = vim.tbl_extend("force", palette, override_colors.palette or {})

    -- Generate the theme according to the updated palette colors
    local theme_colors = require("kanagawa.themes")[theme](updated_palette_colors)

    -- Add to and/or override theme_colors  
    local function nested_extend(base, override)
        for k, v in pairs(override) do
            if type(v) == "table" and type(base[k]) == "table" then
                nested_extend(base[k], v)
            else
                base[k] = v
            end
        end
    end

    local override_theme_colors = override_colors.theme
    if override_theme_colors and override_theme_colors[theme] then
        nested_extend(theme_colors, override_theme_colors[theme])
    end

    if override_theme_colors and override_theme_colors.all then
        nested_extend(theme_colors, override_theme_colors.all)
    end

    return { palette = updated_palette_colors, theme = theme_colors }
end

return M
