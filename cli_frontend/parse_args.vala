namespace CliFrontend {
    public const string help_sheet = """
usage: minesweeper [-h | --help] [-v | --version] [-m | --mines <amount>]
                   [-s | --size <width> <height>]

options:
    -h, --help        Display this help sheet and exit
    -v, --version     Display the version information and exit
    -m, --mines N     Set the amount of mines to be genereted for the field
    -s, --size W H    Set the width (W) and height (H) of the field

""";

    public bool parse_args(
        string[] args, ref int width,
        ref int height, ref int bombs,
        out bool help = null,
        out bool version = null
    ) {
        help = false;
        version = false;

        int i = 0;
        int argc = args.length;
        while (i < argc) {
            var arg = args[i++];
            switch (arg) {

            case "--size":
            case "-s": {
                if (argc - i < 2) {
                    return false;
                }

                if (!int.try_parse(args[i++], out width)) return false;
                if (!int.try_parse(args[i++], out height)) return false;
                break;
            }

            case "--mines":
            case "-m": {
                if (argc - i < 1) {
                    return false;
                }

                if (!int.try_parse(args[i++], out bombs)) return false;
                break;
            }

            case "--help":
            case "-h": {
                help = true;
                break;
            }

            case "--version":
            case "-v": {
                version = true;
                break;
            }

            }
        }

        return true;
    }
}
