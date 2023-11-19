int main(string[] args) {
#if PREPROCESSOR_CLI
    CliFrontend.run(args);
#else
    GtkFrontend.run(args);
#endif

    return 0;
}
