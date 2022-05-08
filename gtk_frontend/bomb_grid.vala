namespace GtkFrontend {
    class BombGrid : Gtk.Grid {
        public signal void tile_clicked(GridTileButton button, int x, int y);

        public BombGrid() {
            this.row_homogeneous = true;
            this.column_homogeneous = true;
        }
        
        public void make_button_grid(int width, int height) {
            Gtk.Widget? child = null;
            do {
                child = this.get_first_child();
                child?.unparent();
            } while (child != null);

            for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++) {
                var button = new GridTileButton(i, j);
                button.clicked.connect(() => {
                    tile_clicked(button, button.x, button.y);
                });
                this.attach(button, i, j);
            }
        }

        public void display_board(int width, int height, Tile[,] board) {
            for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++) {
                var tile = board[j, i];
                var child = this.get_child_at(i, j) as GridTileButton;
                if (tile.is_revealed) {
                    child.remove_css_class("hidden");

                    if (tile.is_bomb) child.set_icon_name("kmines");
                    else if (!child.is_flagged) {
                        var neighbors = tile.bomb_neighbor_count;
                        var label = child.get_child() as Gtk.Label;
                        label.set_markup(neighbors == 0 ? " " : @"<b><span color='blue'>$neighbors</span></b>");
                        child.sensitive = false;
                    }
                } else {
                    child.add_css_class("hidden");

                    child.update_is_flagged_label();
                }
            }
        }
    }

    class GridTileButton : Gtk.Button {
        public int x {get; private set;}
        public int y {get; private set;}
        bool _is_flagged = false;

        public bool is_flagged {
            set {
                _is_flagged = value;
                update_is_flagged_label();
            }
            get {
                return _is_flagged;
            }
        }

        public GridTileButton(int x, int y) {
            this.is_flagged = false;
            this.x = x;
            this.y = y;
        }

        public void update_is_flagged_label() {
            if (_is_flagged) this.icon_name = "flag-red";
            else this.label = "??";
        }
    }
}