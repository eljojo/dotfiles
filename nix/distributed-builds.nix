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
      # bart, not willie: willie is a hypervisor whose guests pin 44 of its
      # 62.7 GiB, and build load there was competing with guest memory.
      hostName = "bart.eljojo.casa";
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
      # obtained with `base64 -w0 /etc/ssh/ssh_host_ed25519_key.pub`
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5WT1B4QjV6bGFqR1ozK3gyVEc3RUxWempDRURTTytSYXovOWdxYmN2QnEgcm9vdEBiYXJ0Cg==";
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
