project('minesweeper-gtk', 'vala', 'c', version: '1.0.0')

cli_only = get_option('cli_only')

if cli_only
  add_project_arguments(['-D', 'PREPROCESSOR_CLI'], language: 'vala')
endif

deps = [
  dependency('gtk4'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
]

sources = files(
  'main.vala',
  'game.vala',
  'cli_frontend/main.vala',
  'cli_frontend/parse_args.vala',
  'gtk_frontend/main.vala',
  'gtk_frontend/new_game_button.vala',
  'gtk_frontend/bomb_grid.vala',
  'gtk_frontend/tile_click_mode_button.vala',
  'gtk_frontend/info_dialog.vala',
  'gtk_frontend/game_manager.vala',
)

# if cli_only
#   sources += files('cli_frontend/main.vala'),
# else
#   sources += files(
#     'gtk_frontend/main.vala',
#     'gtk_frontend/new_game_button.vala',
#     'gtk_frontend/bomb_grid.vala',
#     'gtk_frontend/tile_click_mode_button.vala',
#     'gtk_frontend/info_dialog.vala',
#     'gtk_frontend/game_manager.vala',
#   )
# endif

executable('minesweeper',
  sources,
  dependencies: deps,
  install: true,
  gui_app: true,
)
