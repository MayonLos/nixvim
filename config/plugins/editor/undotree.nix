{
    plugins.undotree = {
        enable = true;
        lazyLoad.settings = {
            keys = [
                {
                    __unkeyed-1 = "<leader>u";
                    __unkeyed-2 = "<cmd>UndotreeToggle<cr>";
                    mode = [ "n" ];
                    desc = "Toggle Undotree";
                }
            ];
        };
    };
}