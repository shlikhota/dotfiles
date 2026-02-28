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
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        lazy = true,
        opts = {
            follow_current_file = {
                enabled = true,
            },
            buffers = {
                leave_dirs_open = true,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                bind_to_cwd = false,
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        },
    },
    {
        "folke/persistence.nvim",
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "PersistenceSavePre",
                callback = function()
                    -- Close neo-tree and all non-file buffers before saving session
                    vim.cmd("Neotree close")
                    -- Clear arglist so "." directory arg doesn't trigger neo-tree on restore
                    vim.cmd("%argdelete")
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local bt = vim.bo[buf].buftype
                        local name = vim.api.nvim_buf_get_name(buf)
                        if bt ~= "" or vim.fn.isdirectory(name) == 1 then
                            pcall(vim.api.nvim_buf_delete, buf, { force = true })
                        end
                    end
                end,
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "PersistenceLoadPost",
                callback = function()
                    vim.cmd("Neotree show")
                end,
            })
            -- Auto-restore session when opening nvim with no file arguments
            vim.api.nvim_create_autocmd("VimEnter", {
                nested = true,
                callback = function()
                    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
                        require("persistence").load()
                    end
                end,
            })
        end,
    },
    {
        "michaelb/sniprun",
        init = function()
            vim.api.nvim_set_keymap("v", "<leader>r", "<Plug>SnipRun", { silent = true })
            vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>SnipRunOperator", { silent = true })
            vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
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
