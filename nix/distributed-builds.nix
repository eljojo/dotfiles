{
  config,
  pkgs,
  lib,
  ...
}:

let
in
{
  nix.buildMachines = [
    {
      hostName = "willie.eljojo.casa";
      sshUser = "remotebuild";
      sshKey = "/Users/jojo/.ssh/id_ecdsa";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
    }
    {
      hostName = "raccoon.eljojo.net";
      sshUser = "remotebuild";
      sshKey = "/Users/jojo/.ssh/id_ecdsa";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
    }
  ];
  nix.distributedBuilds = true;
  nix.settings = {
    builders-use-substitutes = true;

    extra-substituters = [
      "https://cache.saumon.network/proxmox-nixos"
    ];
    extra-trusted-public-keys = [
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
    ];
  };
}
