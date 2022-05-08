namespace GtkFrontend {
    public enum Mode { REVEAL, FLAG }

    class TileClickModeButton : Gtk.Button {

        public signal void mode_changed(Mode new_mode);

        Mode mode;

        public TileClickModeButton(bool is_revealing = true) {
            mode = is_revealing ? Mode.REVEAL : Mode.FLAG;
            
            update_icon_name();

            this.clicked.connect(() => {
                mode = (mode == REVEAL ? Mode.FLAG : Mode.REVEAL);
                update_icon_name();
                mode_changed(mode);
            });
        }

        void update_icon_name() {
            switch (mode) {
            case REVEAL:
                this.icon_name = "edit-select-all";
                break;
            case FLAG:
                this.icon_name = "flag-red";
                break;
            }
        }
    }
}