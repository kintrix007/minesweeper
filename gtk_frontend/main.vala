using GLib;

namespace GtkFrontend {
    const int TILE_WIDTH = 48;
    const int TILE_HEIGHT = 48;

    public int run(string[] args) {
        var app = new Gtk.Application(
            "me.kintrix.Minesweeper",
            ApplicationFlags.FLAGS_NONE
        );

        int width = 15, height = 15, bombs = 25;
        var game = new Game(width, height, bombs);
        
        app.activate.connect(() => {
            var is_revealing = true;
            
            var window = new Gtk.ApplicationWindow(app);
            window.title = "Minesweeper";
            window.icon_name = "kmines";
            //  window.resizable = false;
            window.set_default_size(width * TILE_WIDTH, height * TILE_HEIGHT);
            //  window.width_request = 1000;

            var new_game_button = new NewGameButton(window);
            var reveal_mode_button = new TileClickModeButton(is_revealing);

            var headerbar = new Gtk.HeaderBar();
            headerbar.pack_start(reveal_mode_button);
            headerbar.pack_start(new Gtk.Label("Bombs: 10"));
            headerbar.pack_end(new_game_button);
            window.titlebar = headerbar;

            var grid = new BombGrid();
            //  grid.make_button_grid(width, height);

            reveal_mode_button.mode_changed.connect((mode) => {
                is_revealing = mode == REVEAL;
            });

            grid.tile_clicked.connect((btn, x, y) => {
                if (is_revealing) {
                    if (!btn.is_flagged) game.reveal(x, y);
                } else {
                    btn.is_flagged = !btn.is_flagged;
                }
            });
            
            new_game_button.get_defaults.connect((out w, out h, out b) => {
                w = width;
                h = height;
                b = bombs;
            });

            new_game_button.confirmed.connect((w, h, b) => {
                width = w;
                height = h;
                bombs = b;
                grid.make_button_grid(w, h);
                window.set_default_size(w * TILE_WIDTH, h * TILE_HEIGHT);
                window.width_request = w * TILE_WIDTH;
                window.height_request = h * TILE_HEIGHT * (window.get_allocated_width() / (w * TILE_WIDTH));
                
                
                game = new Game(width, height, bombs);
                game.lost.connect(() => {
                    //  window.close();
                });
                game.won.connect(() => {
                    print("WON!\n");
                });
                game.board_update.connect((w, h, board) => {
                    grid.display_board(w, h, board);
                });
            });

            window.set_child(grid);
            window.present();
        });

        app.run(args);
        return 0;
    }
}
