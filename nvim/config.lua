local augroup = vim.api.nvim_create_augroup
local tverdyyGroup = augroup('tverdyyGroup', {})

local autocmd = vim.api.nvim_create_autocmd

function R(name)
        require("plenary.reload").reload_module(name)
end

autocmd({ "BufWritePre" }, {
        group = tverdyyGroup,
        pattern = "*",
        command = [[%s/\s\+$//e]],
})

vim.opt.guicursor = ""

vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
