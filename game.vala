using GLib;

public struct Tile {
    public bool is_bomb;
    public bool is_revealed;
    public int bomb_neighbor_count;

    public Tile() {
        is_bomb = false;
        is_revealed = false;
        bomb_neighbor_count = 0;
    }
}

public class Game {
    public signal void board_update(int width, int height, Tile[,] board);
    public signal void lost();
    public signal void won();

    bool is_ongoing;
    bool is_first_reveal;
    int bombs;
    public int width {get; private set;}
    public int height {get; private set;}
    Tile[,] board;
    
    public Game(int width, int height, int bombs)
        requires(width * height > 9)
        requires(bombs <= width*height-9)
    {
        is_ongoing = true;
        is_first_reveal = true;

        this.bombs = bombs;
        this.width = width;
        this.height = height;
        this.board = new Tile[height, width];

        for (int i = 0; i < bombs; i++) {
            place_random_bomb();
        }

        calculate_bomb_neighbors();
    }

    public void reveal(int x, int y)
        requires(x >= 0 && x < width)
        requires(y >= 0 && y < height)
    {
        if (!is_ongoing) return;
        
        board[y, x].is_revealed = true;

        if (board[y, x].is_bomb) {
            if (is_first_reveal) {
                // Make sure the first one is not a bomb
                // to let the game start in the first place
                board[y, x].is_bomb = false;
                place_random_bomb();
            } else {
                this.is_ongoing = false;
                lost();
                reveal_every_bomb();
            }
        }

        if (is_first_reveal) {
            if (board[y, x].bomb_neighbor_count != 0) {
                for (int i = -1; i <= 1; i++)
                for (int j = -1; j <= 1; j++) {
                    if (!is_in_bounds(x+i, y+j)) continue;
                    board[y+j, x+i].is_revealed = true;
                }

                for (int i = -1; i <= 1; i++)
                for (int j = -1; j <= 1; j++) {
                    if (!is_in_bounds(x+i, y+j)) continue;
                    if (board[y+j, x+i].is_bomb) {
                        board[y+j, x+i].is_bomb = false;
                        place_random_bomb();
                    }
                }
                
                for (int i = -1; i <= 1; i++)
                for (int j = -1; j <= 1; j++) {
                    if (!is_in_bounds(x+i, y+j)) continue;
                    reveal_connected(x+i, y+j);
                }
            }
        }

        is_first_reveal = false;

        if (is_ongoing) {
            reveal_connected(x, y);

            if (has_won()) {
                this.is_ongoing = false;
                won();
                reveal_every_bomb();
            }
        }
        
        board_update(this.width, this.height, board);
    }

    private bool is_in_bounds(int x, int y) {
        if (x < 0 || x >= width || y < 0 || y >= height) return false;
        return true;
    }

    private bool has_won() {
        for (int i = 0; i < width; i++)
        for (int j = 0; j < height; j++) {
            if (board[j, i].is_bomb || board[j, i].is_revealed) continue;
            return false;
        }
        return true;
    }

    private void reveal_connected(int x, int y) {
        if (x < 0 || x >= width || y < 0 || y >= height) return;
        
        board[y, x].is_revealed = true;
        
        if (board[y, x].bomb_neighbor_count > 0) return;
        
        for (int i = -1; i <= 1; i++)
        for (int j = -1; j <= 1; j++) {
            if (i == 0 && j == 0) continue;
            var xpos = x+i;
            var ypos = y+j;
            var tile = board[ypos, xpos];
            if (!tile.is_bomb && !tile.is_revealed) {
                reveal_connected(xpos, ypos);
            }
        }
    }

    private void calculate_bomb_neighbors(
        int startx = 0, int starty = 0,
        int endx = width, int endy = height
    )
        requires(startx < endx)
        requires(starty < endy)
    {
        for (int i = startx; i < endx; i++) {
            if (i < 0 || i >= width) continue;
            for (int j = starty; j < endy; j++) {
                if (j < 0 || j >= height) continue;
    
                var neighbors = 0;
                for (int x = -1; x <= 1; x++)
                for (int y = -1; y <= 1; y++) {
                    if (x == 0 && y == 0) continue;
                    
                    var xpos = i+x;
                    var ypos = j+y;
                    if (!is_in_bounds(xpos, ypos)) continue;

                    var tile = board[ypos, xpos];
                    if (tile.is_bomb) neighbors++;
                }
                board[j, i].bomb_neighbor_count = neighbors;
            }
        }
    }

    private void place_random_bomb() 
        requires(!has_won())
    {
        int x, y;
        while (true) {
            x = Random.int_range(0, width);
            y = Random.int_range(0, height);
            if (board[y, x].is_bomb || board[y, x].is_revealed) continue;
            board[y, x].is_bomb = true;
            break;
        }
        //  calculate_bomb_neighbors(x-1, y-1, x+1, y+1);
        calculate_bomb_neighbors();
    }

    private void reveal_every_bomb() {
        for (int i = 0; i < width; i++)
        for (int j = 0; j < height; j++) {
            if (board[j, i].is_bomb) board[j, i].is_revealed = true;
        }
    }
}
