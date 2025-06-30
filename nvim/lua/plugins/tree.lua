-- No load this plugin yet --
if true then
    return {
        'prichrd/netrw.nvim', opts = {}
    }
end
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
            {
                "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
                version = "2.*",
                config = function()
                    require("window-picker").setup({
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                                -- if the buffer type is one of following, the window will be ignored
                                buftype = { "terminal", "quickfix" },
                            },
                        },
                    })
                end,
            },
        },
        lazy = false,
        -----Instead of using `config`, you can use `opts` instead, if you'd like:
        -----@module "neo-tree"
        -----@type neotree.Config
        --opts = {},
        config = function()
            require("neo-tree").setup({
                visible = false,
                vim.keymap.set("n", "<leader>o", "<Cmd>Neotree focus<CR>"),
                vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
            })
        end,
    },
}
