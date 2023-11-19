public const string VERSION = "1.0.0";

int main(string[] args) {
#if PREPROCESSOR_CLI
    CliFrontend.run(args);
#else
    GtkFrontend.run(args);
#endif

    return 0;
}
