{
  modulesPath,
  pkgs,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../sys/tty.nix
    ../sys/aliases.nix
    ../sys/nix.nix
    ../services/journald.nix
    ../services/net/nginx.nix
    ../services/net/sshd.nix
    ../services/databases/postgresql-templebar.nix
  ];
  age.identityPaths = ["/home/kavarkon/.ssh/id_ed25519" "/mnt/host-ssh/id_ed25519"];
  age.secrets.templebar-api = {
    file = ../secrets/templebar-api.age;
  };
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    neovim
    nano
    ripgrep
    fzf
    gitMinimal
    curl
    curlie
    bottom
    ncdu
    rsync
    zoxide
    bat
    tealdeer
  ];
  users.users.kavarkon = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUKrA0XuY+OiXWlDctkApwtFhawDpaHQdEXW/5DTmxw kavarkon@baton"
    ];
    initialHashedPassword = "$y$j9T$H52H7Xta1XhESYb2vE07C/$diE1gF.OIIOCBo6jzKATasjiKwXKhbLCEWmJd.PBZM1";
  };
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUKrA0XuY+OiXWlDctkApwtFhawDpaHQdEXW/5DTmxw kavarkon@baton"
      ];
    };
  };
  users.defaultUserShell = pkgs.fish;
  networking = {
    useDHCP = true;
    hostName = "templebar";
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };
  system.stateVersion = "24.05";
  documentation.nixos.enable = false;
  services.nginx.virtualHosts."api.templebar.local" = {
    forceSSL = false;
    enableACME = false;
    locations."/" = {
      proxyPass = "http://localhost:8080";
      extraConfig = ''
        proxy_read_timeout 1d;
      '';
    };
  };
  systemd.services.templebar-api = {
    wantedBy = ["multi-user.target"];
    after = ["network.target" "postgresql.service"];
    serviceConfig = {
      ExecStart = "${inputs.templebar-api.packages.${pkgs.system}.default}/bin/templebar-api";
      DynamicUser = true;
      StateDirectory = "templebar-api";
      EnvironmentFile = config.age.secrets.templebar-api.path;
    };
  };
}
