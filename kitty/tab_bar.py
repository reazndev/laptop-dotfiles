import os
from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    TabAccessor,
    as_rgb,
)

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Use the specific tab being drawn
    tab_accessor = TabAccessor(tab.tab_id)

    old_fg = screen.cursor.fg
    old_bg = screen.cursor.bg

    # --- Start of Tab Drawing ---

    # 1. Draw left indicator (using active/inactive background colors)
    if tab.is_active:
        # Use active_bg as foreground color for the separator
        screen.cursor.fg = as_rgb(int(draw_data.active_bg)) 
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
    elif extra_data.prev_tab is None or extra_data.prev_tab.tab_id != tab.tab_id:
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
        # Use inactive_fg (or another defined color) for the separator
        screen.cursor.fg = as_rgb(int(draw_data.inactive_fg)) 

    # Determine what to show: cwd for fish, else application ID
    display_name = "?"
    exe_name = tab_accessor.active_oldest_exe or "?"
    if exe_name.lower() == "fish":
        cwd = tab_accessor.active_oldest_wd or "?"
        if cwd and isinstance(cwd, str):
            home = os.path.expanduser("~")
            if cwd.startswith(home):
                cwd = "~" + cwd[len(home):]
            last_component = os.path.basename(cwd.rstrip("/"))
            display_name = last_component if last_component else cwd
    else:
        display_name = exe_name

    # Truncate if too long
    if len(display_name) > 30:
        display_name = display_name[:30] + "…"

    # 2. Draw the main tab cell
    
    # Use config colors for background
    bg_color = as_rgb(int(draw_data.active_bg)) if tab.is_active else as_rgb(int(draw_data.inactive_bg))
    
    # Use config colors for foreground (text)
    fg_color = as_rgb(int(draw_data.active_fg)) if tab.is_active else as_rgb(int(draw_data.inactive_fg))
    
    screen.cursor.fg = fg_color
    screen.cursor.bg = bg_color
    screen.draw(f"  {display_name} ")

    # 3. Right-side active indicator
    if tab.is_active:
        screen.cursor.fg = as_rgb(int(draw_data.active_bg))
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))

    # Reset cursor colors
    screen.cursor.fg = old_fg
    screen.cursor.bg = old_bg
    
    return screen.cursor.x
