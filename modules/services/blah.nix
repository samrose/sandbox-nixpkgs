{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.blah;
in

{
  options.services.blah = {
    enable = mkEnableOption "Blah";

    package = mkOption {
      default = pkgs.blah;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.blah = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/manage.py runserver 0.0.0.0:8000";
    };
  };
}
