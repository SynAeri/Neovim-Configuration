{ lib, config, pkgs, ... }:

{
# User Configuration
  users.users.jordanm = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "jordan maquiran";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" "video" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
    ];
  };
}
