namespace GtkFrontend {
    class InfoDialog : Gtk.Dialog {
        public InfoDialog(Gtk.Window? parent, string? title, string label_text) {
            this.transient_for = parent;
            this.modal = true;
            this.titlebar = new Gtk.HeaderBar();
            this.title = title;

            var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 30);
            vbox.margin_top = 35;
            vbox.margin_bottom = 15;
            vbox.margin_start = 50;
            vbox.margin_end = 50;

            var label = new Gtk.Label(label_text);
            var button = new Gtk.Button.with_label("Okay!");
            button.clicked.connect(() => {
                this.close();
            });

            vbox.append(label);
            vbox.append(button);
            this.set_child(vbox);
        }
    }
}
