namespace GtkFrontend {
    class NewGameButton : Gtk.Button {
        public signal void confirmed(int width, int height, int bombs);
        public signal void get_defaults(out int width, out int height, out int bombs);

        public NewGameButton(Gtk.ApplicationWindow window) {
            this.icon_name = "tab-new";
            this.clicked.connect(() => {
                int width, height, bombs;
                get_defaults(out width, out height, out bombs);
                
                var dialog = new Gtk.Dialog.with_buttons("New Game", window, Gtk.DialogFlags.MODAL);
                
                var done_button = new Gtk.Button.with_label("Create");
                done_button.clicked.connect(() => {
                    confirmed(width, height, bombs);
                    dialog.close();
                });

                var cancel_button = new Gtk.Button.with_label("Cancel");
                cancel_button.clicked.connect(() => {
                    dialog.close();
                });

                var headerbar = new Gtk.HeaderBar();
                headerbar.show_title_buttons = false;
                headerbar.pack_start(cancel_button);
                headerbar.pack_end(done_button);
                dialog.titlebar = headerbar;
                
                var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
                vbox.margin_top = 15;
                vbox.margin_bottom = 15;
                vbox.margin_start = 20;
                vbox.margin_end = 20;

                var width_spin_button = new Gtk.SpinButton.with_range(4, 20, 1);
                width_spin_button.value = width;
                
                var height_spin_button = new Gtk.SpinButton.with_range(4, 20, 1);
                height_spin_button.value = height;
                
                var bombs_spin_button = new Gtk.SpinButton.with_range(1, width*height-9, 1);
                bombs_spin_button.value = bombs;
                width_spin_button.value_changed.connect((btn) => {
                    width = (int)btn.value;
                    bombs_spin_button.set_range(1, width*height-9);
                });
                height_spin_button.value_changed.connect((btn) => {
                    height = (int)btn.value;
                    bombs_spin_button.set_range(1, width*height-9);
                });
                bombs_spin_button.value_changed.connect((btn) => {
                    bombs = (int)btn.value;
                });

                vbox.append(new Gtk.Label("Width:"));
                vbox.append(width_spin_button);
                vbox.append(new Gtk.Label("Height:"));
                vbox.append(height_spin_button);
                vbox.append(new Gtk.Label("Bombs:"));
                vbox.append(bombs_spin_button);
                
                dialog.set_child(vbox);
                dialog.present();
            });
        }
    }
}
