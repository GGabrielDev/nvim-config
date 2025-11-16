local keymap = vim.keymap

keymap.set('n', '<leader>jt', ':JavaTestCurrentMethod<CR>', { desc = "Run the current test method" })
keymap.set('n', '<leader>jT', ':JavaTestCurrentClass<CR>', { desc = "Run the current test class" })
keymap.set('n', '<leader>jr', ':JavaRunnerRunMain<CR>', { desc = "Run the main class" })
