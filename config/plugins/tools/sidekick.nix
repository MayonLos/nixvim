{pkgs, lib, ...}:

{
    plugins.sidekick = {
        enable = true;
        settings = {
            cli = {
                mux = {
                    backend = "tmux";
                    enabled = true;
                };
            };
        };
    };
}