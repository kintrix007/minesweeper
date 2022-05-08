project('minesweeper-gtk', 'vala')
deps = [ dependency('gtk4') ]
executable(
  'minesweeper',
  [
    'main.vala', 'game.vala',
    'cli_frontend/main.vala',
    'gtk_frontend/main.vala', 'gtk_frontend/new_game_button.vala', 'gtk_frontend/bomb_grid.vala', 'gtk_frontend/tile_click_mode_button.vala',
  ],
  dependencies: deps,
  install: false,
)
