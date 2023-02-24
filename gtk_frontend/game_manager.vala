namespace GtkFrontend {
    class GameManager {
        public signal void board_update(int width, int height, Tile[,] board);
        public signal void lost();
        public signal void won();
        
        public int width {get; private set;}
        public int height {get; private set;}
        public int bombs {get; private set;}

        Game game;

        public GameManager(int def_width, int def_height, int def_bombs) {
            new_game(def_width, def_height, def_bombs);
        }

        public void new_game(int width, int height, int bombs) {
            this.width = width;
            this.height = height;
            this.bombs = bombs;
            
            if (game != null) {
                game.board_update.disconnect(emit_board_update);
                game.lost.disconnect(emit_lost);
                game.won.disconnect(emit_won);
            }

            this.game = new Game(width, height, bombs);
            
            game.board_update.connect(emit_board_update);
            game.lost.connect(emit_lost);
            game.won.connect(emit_won);
        }

        private void emit_board_update(int w, int h, Tile[,] board) { board_update(w, h, board); }
        private void emit_lost() { lost(); }
        private void emit_won() { won(); }

        public void reveal(int x, int y) {
            game.reveal(x, y);
        }
    }
}