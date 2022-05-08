namespace CliFrontend {
    public int run(string[] args) {
        var game = new Game(10, 10, 10);
        game.won.connect(() => print("Won!\n"));
        game.lost.connect(() => print("Lost!\n"));
        game.board_update.connect((width, height, board) => {
            for (int j = 0; j < height; j++) {
                for (int i = 0; i < width; i++) {
                    var tile = board[i, j];
                    if (tile.is_revealed) {
                        if (tile.is_bomb) print("@");
                        else {
                            var neighbors = tile.bomb_neighbor_count;
                            print(neighbors == 0 ? " " : @"$neighbors");
                            //  print(@"$neighbors");
                        }
                    } else {
                        print("?");
                    }
                    print(" ");
                }
                print("\n");
            }
            print("\n");
        });
        
        game.reveal(7, 5);
        game.reveal(3, 5);
        return 0;
    }
}
