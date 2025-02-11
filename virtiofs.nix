{ config, pkgs, ... }:

{
    fileSystems."/media" = {
        device = "108-media";
        fsType = "virtiofs";
        options = [
            "nofail"
        ];
    };
}
