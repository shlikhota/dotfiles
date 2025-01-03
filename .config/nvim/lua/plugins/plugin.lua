return {
    {
        "iamcco/markdown-preview.nvim",
        init = function()
            vim.g.mkdp_theme = "light"
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_combine_preview = 1
            vim.g.mkdp_auto_close = 0
            vim.g.mkdp_preview_options = {
                maid = { theme = "neutral" },
            }
        end,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                version = "^1.0.0",
            },
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
            vim.keymap.set(
                "n",
                "<leader>fg",
                require("telescope").extensions.live_grep_args.live_grep_args,
                { noremap = true }
            )
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = false,
        lazy = false,
        opts = {
            -- auto_clean_after_session_restore = false,
            auto_restore_session_experimental = true,
        },
    },
    {
        "rmagatti/auto-session",
        lazy = false,
        config = function()
            require("auto-session").setup({
                auto_session_enable_last_session = false,
                auto_session_last_session_dir = vim.fn.stdpath("data") .. "/sessions/",
                auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
                auto_session_enabled = true,
                log_level = vim.log.levels.ERROR,
                auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
                auto_save_enabled = true,
                auto_session_create_enabled = true,
                session_lens = {
                    buftypes_to_ignore = {},
                    load_on_setup = true,
                    theme_conf = { border = true },
                    previewer = false,
                },
            })
            vim.keymap.set("n", "<Leader>ls", require("auto-session.session-lens").search_session, {
                noremap = true,
            })
        end,
    },
    {
        "michaelb/sniprun",
        init = function()
            vim.api.nvim_set_keymap("v", "<leader>f", "<Plug>SnipRun", { silent = true })
            vim.api.nvim_set_keymap("n", "<leader>f", "<Plug>SnipRunOperator", { silent = true })
            vim.api.nvim_set_keymap("n", "<leader>ff", "<Plug>SnipRun", { silent = true })
        end,
        config = function()
            require("sniprun").setup({
                display = { "Terminal" },
                show_no_output = { "Terminal" },
                inline_messages = false,
                display_options = {
                    terminal_scrollback = vim.o.scrollback, --# change terminal display scrollback lines
                    terminal_line_number = false, --# whether show line number in terminal window
                    terminal_signcolumn = false, --# whether show signcolumn in terminal window
                    terminal_position = "horizontal", --# or "horizontal", to open as horizontal split instead of vertical split
                    terminal_width = 25, --# change the terminal display option width (if vertical)
                    terminal_height = 10, --# change the terminal display option height (if horizontal)
                    notification_timeout = 5, --# timeout for nvim_notify output
                },
            })
        end,
    },
}
