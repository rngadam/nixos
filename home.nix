{ pkgs, ... }:
{
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file.".vimrc".source = ./vim_configuration;
  programs.git = {
      enable = true;
      userName = "Ricky Ng-Adam";
      userEmail = "ricky@coderbunker.ca";
      ignores = [ ".DS_Store" ];
      extraConfig = {
	  init.defaultBranch = "main";
	  push.autoSetupRemote = true;
      };
  };
  programs.bash = {
      enable = true;
      shellAliases = {
	  switch = "nixos-rebuild switch --use-remote-sudo";
      };
  };

  programs.starship = {
    enable = true;
  };
}
