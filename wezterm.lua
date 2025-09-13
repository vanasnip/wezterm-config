-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Function to determine border color based on directory
wezterm.on('update-status', function(window, pane)
  local cwd = pane:get_current_working_dir()
  if cwd then
    local path = cwd.file_path
    local overrides = window:get_config_overrides() or {}
    
    -- Define directory-to-color mappings
    local border_color = '#979797ff'  -- Default Dracula purple
    
    if path:match('/anim/') then
      border_color = '#0b85f4'  -- Blue for animation directory
    elseif path:match('/Documents/') then
      border_color = '#8be9fd'  -- Cyan for documents
    elseif path:match('/Downloads/') then
      border_color = '#ffb86c'  -- Orange for downloads
    elseif path:match('/Projects/') then
      border_color = '#ff79c6'  -- Pink for projects
    elseif path == wezterm.home_dir then
      border_color = '#f1fa8c'  -- Yellow for home directory
    elseif path:match('/Documents/') then
      border_color = '#8be9fd' 
    end
    
    -- Apply the color change
    overrides.window_frame = {
      border_left_width = '0',
      border_right_width = '0',
      border_bottom_height = '0',
      border_top_height = '11px',
      border_left_color = '#1e2029',
      border_right_color = '#1e2029',
      border_bottom_color = '#1e2029',
      border_top_color = border_color,
    }
    
    window:set_config_overrides(overrides)
  end
end)

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 14
config.color_scheme = 'Dracula'

-- Add gradient background
config.window_background_gradient = {
  -- 'Vertical' or 'Horizontal' gradient
  orientation = 'Vertical',
  
  -- Gradient colors (from lighter gray to Dracula background)
  colors = {
    '#353846ff',  -- Lighter gray at top
    '#1e2029ff',  -- Dracula background color at bottom
  },
  
  -- Interpolation (can be 'Linear', 'Basis' or 'CatmullRom')
  interpolation = 'Linear',
  
  -- Blend factor
  blend = 'Rgb',
}

-- Add top border effect using padding
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,  -- This creates space for a visual top border
  bottom = 0,
}

-- Window frame configuration for border appearance
config.window_frame = {
  border_left_width = '0',
  border_right_width = '0',
  border_bottom_height = '0',
  border_top_height = '11px',
  border_left_color = '#1e2029',
  border_right_color = '#1e2029',
  border_bottom_color = '#1e2029',
  border_top_color = '#bd93f9',  -- Dracula purple for top border
}

config.window_decorations = 'RESIZE'

-- Mouse selection highlighting
config.selection_foreground = 'none'  -- Keep original text color
config.selection_background = '#44475a'  -- Dracula selection color (lighter gray)

-- Enable mouse interactions
config.mouse_bindings = {
  -- Right click pastes from clipboard
  {
    event = {Up = {streak = 1, button = 'Right'}},
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  -- Ctrl-click opens hyperlinks
  {
    event = {Up = {streak = 1, button = 'Left'}},
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- Finally, return the configuration to wezterm:
return config