{
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      sandbox = true;
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 4;

    extraOptions = ''
      experimental-features = nix-command flakes
      connect-timeout = 5
    '';
  };
}
