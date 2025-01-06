{
  config,
  lib,
  ...
}: let
  inherit (lib) filterAttrs mapAttrs mkEnableOption mkIf pipe;
in {
  options.topology.extractors.proxmox.enable =
    mkEnableOption "topology proxmox extractor"
    // {
      default = true;
    };

  config = let
    proxmox = config.services.proxmox or null;
  in
    mkIf (config.topology.extractors.proxmox.enable
      && proxmox != null
      && proxmox.enable) {
      topology.self.services.proxmox = {
        name = "Proxmox";
        icon = "services.proxmox";
        details = pipe proxmox.servers [
          (filterAttrs (_: s: s.enable))
          (mapAttrs (_: v: {text = toString v.ipAddress;}))
        ];
      };
    };
}
