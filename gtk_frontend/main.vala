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
            var flagged_count = 0;
            var is_revealing = true;
            
            var window = new Gtk.ApplicationWindow(app);
            window.title = "Minesweeper";
            window.icon_name = "kmines";
            //  window.resizable = false;
            window.set_default_size(width * TILE_WIDTH, height * TILE_HEIGHT);

            var new_game_button = new NewGameButton(window);
            var reveal_mode_button = new TileClickModeButton(is_revealing);
            var bomb_count_label = new Gtk.Label(@"Bombs: $bombs");

            var headerbar = new Gtk.HeaderBar();
            headerbar.pack_start(reveal_mode_button);
            headerbar.pack_start(bomb_count_label);
            headerbar.pack_end(new_game_button);
            window.titlebar = headerbar;

            var grid = new BombGrid();
            grid.make_button_grid(width, height);  // ? Also need to connect up signals from 'game' on application open
            connect_game_signals(game, window, grid);

            reveal_mode_button.mode_changed.connect((mode) => {
                is_revealing = mode == REVEAL;
            });

            grid.tile_clicked.connect((btn, x, y) => {
                if (is_revealing) {
                    if (!btn.is_flagged) game.reveal(x, y);
                } else {
                    btn.is_flagged = !btn.is_flagged;
                    if (btn.is_flagged) flagged_count++; else flagged_count--;
                    bomb_count_label.label = @"Bombs: $(bombs - flagged_count)";
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
                window.height_request = h * TILE_HEIGHT;
                bomb_count_label.label = @"Bombs: $bombs";
                
                game = new Game(width, height, bombs);
                connect_game_signals(game, window, grid);
            });

            window.set_child(grid);
            window.present();
        });

        app.run(args);
        return 0;
    }

    void connect_game_signals(Game game, Gtk.ApplicationWindow window, BombGrid grid) {
        game.lost.connect(() => {
            grid.disable_all(game.width, game.height);

            var dialog = new Gtk.Dialog.with_buttons("You Lost!", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.USE_HEADER_BAR);
            var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 30);
            vbox.margin_top = 35;
            vbox.margin_bottom = 15;
            vbox.margin_start = 50;
            vbox.margin_end = 50;
            var label = new Gtk.Label("You triggered a mine!");
            var button = new Gtk.Button.with_label("Okay!");
            button.clicked.connect(() => {
                dialog.close();
            });
            vbox.append(label);
            vbox.append(button);
            dialog.set_child(vbox);
            Timeout.add(1000, () => {
                dialog.present();
                return false;
            });
        });
        
        game.won.connect(() => {
            grid.disable_all(game.width, game.height);
            
            var dialog = new Gtk.Dialog.with_buttons("You Won!", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.USE_HEADER_BAR);
            var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 30);
            vbox.margin_top = 35;
            vbox.margin_bottom = 15;
            vbox.margin_start = 50;
            vbox.margin_end = 50;
            var label = new Gtk.Label("Congratualtions!");
            var button = new Gtk.Button.with_label("Okay!");
            button.clicked.connect(() => {
                dialog.close();
            });
            vbox.append(label);
            vbox.append(button);
            dialog.set_child(vbox);
            Timeout.add(1000, () => {
                dialog.present();
                return false;
            });
        });

        game.board_update.connect((w, h, board) => {
            grid.display_board(w, h, board);
        });
    }
}
