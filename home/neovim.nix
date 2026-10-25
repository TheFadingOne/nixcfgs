{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      telescope-nvim
      vim-go
    ];

    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;
  };
}
