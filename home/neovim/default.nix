{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      telescope-nvim
      vim-go
      lean-nvim
      diffview-nvim
      catppuccin-nvim
      neorg
      oil-nvim
    ];

    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;
  };

  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
