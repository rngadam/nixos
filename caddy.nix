{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nss.tools
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };
  services.caddy = {
    enable = true;
    virtualHosts."localhost".extraConfig = ''
      respond "Hello, world!"
    '';
    virtualHosts."peertube.hopto.org".extraConfig = ''
      respond "Hello, world!"
    '';
    virtualHosts."peertube.coderbunker.ca".extraConfig = ''
      reverse_proxy http://peertube:9000 {
      }
    '';
  };
}
