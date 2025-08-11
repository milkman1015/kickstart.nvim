return {
  'windwp/nvim-ts-autotag',
  dependencies = { 'nvim-treesitting/nvim-treesitter' },
  ft = { 'html', 'xml', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
  config = function()
    require('nvim-ts-autotag').setup()
  end,
}
