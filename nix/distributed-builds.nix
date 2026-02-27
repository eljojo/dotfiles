{
  config,
  pkgs,
  lib,
  hostName,
  ...
}:

let
  isM4 = hostName == "jojo-m4-mini";
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
      # willie also supports aarch64-linux via binfmt emulation
      hostName = "raccoon.eljojo.net";
      sshUser = "remotebuild";
      sshKey = "/Users/jojo/.ssh/id_ecdsa";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU1PKy9DTm1PSlhnZlQ3cmY0YWNBZDhpS3pRWlpZWFRxVUxjQUc1S3g0WmUgcm9vdEByYWNvb24tMwo=";
    }
  ] ++ lib.optionals (!isM4) [
    {
      hostName = "100.120.142.98"; # jojo-m4-mini
      sshUser = "jojo";
      sshKey = "/Users/jojo/.ssh/id_ecdsa";
      system = "aarch64-darwin";
      protocol = "ssh";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUhVaFZaUEZuWktqcGloWHlEZml5TGZBaFlGQ1d1SXBxTTNua2pmYnZha28gCg==";
    }
  ];
  nix.distributedBuilds = true;
  nix.settings = {
    builders-use-substitutes = true;
  };
}
