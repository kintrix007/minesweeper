project('minesweeper-gtk', 'vala', 'c')

deps = [
  dependency('gtk4'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
]

sources = files(
  'main.vala', 'game.vala',
  'cli_frontend/main.vala',
  'gtk_frontend/main.vala', 'gtk_frontend/new_game_button.vala',
  'gtk_frontend/bomb_grid.vala', 'gtk_frontend/tile_click_mode_button.vala',
  'gtk_frontend/info_dialog.vala', 'gtk_frontend/game_manager.vala',
)

executable('minesweeper',
  sources,
  dependencies: deps,
  install: false,
)
