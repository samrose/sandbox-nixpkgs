{ config, lib, pkgs, ... }:

{
  imports = [ ../modules ];
  nixpkgs.overlays = [ (import ../overlays/example-nixpkgs) ];
  services.mingetty.autologinUser = "root";
  services.example.enable = true;
  services.blah.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 8000 ];
  
    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/".proxyPass = "http://0.0.0.0:8000/";
      };
    };
}
