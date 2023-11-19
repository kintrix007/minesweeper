namespace CliFrontend {
    public int run(string[] args) {
        int width = 10, height = 10, bombs = 11;
        bool help, version;
        parse_args(args, ref width, ref height, ref bombs,
            out help, out version);

        if (help) {
            print(help_sheet);
            return 0;
        }
        if (version) {
            print(@"Minesweeper version $VERSION\n");
            return 0;
        }

        if (width * height - bombs < 9) {
            printerr("There must be at least 9 empty tiles.\n");
            return 1;
        }

        var game = new Game(width, height, bombs);
        var is_game_alive = true;
        var won = false;

        game.won.connect(() => {
            is_game_alive = false;
            won = true;
        });

        game.lost.connect(() => {
            is_game_alive = false;
            won = false;
        });

        game.board_update.connect((width, height, board) => {
            print("\n");
            print("   ");
            for (int x = 0; x < width; x++) {
                print(left_pad_spaces(x+1));
            }
            print("\n\n");

            for (int y = 0; y < height; y++) {
                print(left_pad_spaces(y+1));
                print("  ");

                for (int x = 0; x < width; x++) {
                    var tile = board[y, x];
                    var visual = get_tile_visuals(tile);
                    print(@"$visual ");
                }

                print(" ");
                print(left_pad_spaces(y+1));

                print("\n");
            }

            print("\n");
            print("   ");
            for (int x = 0; x < width; x++) {
                print(left_pad_spaces(x+1));
            }
            print("\n\n");
        });
        
        game.update();

        while (is_game_alive) {
            print("x y to reveal? (separated by spaces) ");
            stdout.flush();
            var coords = stdin.read_line().split(" ");
            int x, y;

            if (coords[0] == "" || coords[1] == "") {
                print("Please give two whole numbers with a space between.\n");
                continue;
            }

            var valid_x = int.try_parse(coords[0], out x);
            var valid_y = int.try_parse(coords[1], out y);

            if (!valid_x || !valid_y) {
                print("Please give two whole numbers with a space between.\n");
                continue;
            }

            print(@"x: $x, y: $y");
            print("\n");

            x--;
            y--;
            game.reveal(x, y);
        }

        if (won) {
            print("\n\n");
            print(".--------------.\n");
            print("|   YOU WON!   |\n");
            print("'--------------'\n");
            print("\n\n");
        } else {
            print("\n\n");
            print(".---------------.\n");
            print("|   YOU LOST!   |\n");
            print("'---------------'\n");
            print("\n\n");
        }

        return 0;
    }

    string get_tile_visuals(Tile tile) {
        if (!tile.is_revealed) {
            return "?";
        }

        if (tile.is_bomb) {
            return "@";
        } else {
            var neighbors = tile.bomb_neighbor_count;
            return neighbors == 0 ? " " : @"$neighbors";
        }
    }

    string left_pad_spaces(int n) {
        if (n < 10) {
            return @" $n";
        } else {
            return @"$n";
        }
    }
}
