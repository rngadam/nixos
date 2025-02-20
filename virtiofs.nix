{ config, pkgs, ... }:

{
    users.groups.lxc_shares = {
        gid = 10100;
        members = [ "rngadam" ];
    };
    fileSystems."/media" = {
        device = "108-media";
        fsType = "virtiofs";
        options = [
            "nofail"
        ];
    };
}
