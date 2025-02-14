
{
  config,
  lib,
  pkgs,
  ...
}:

{
    virtualisation.docker.enable = true;
    users.users.rngadam.extraGroups = [ "docker" ];
}
