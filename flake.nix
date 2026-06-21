{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";

    templebar-api.url = "github:kavarkon/templebar-api";
    templebar-api.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    disko,
    agenix,
    templebar-api,
    ...
  } @ inputs: {
    # firstvds
    # nixos-rebuild switch --flake .#artist --target-host root@artist --fast
    nixosConfigurations.artist = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./disko-vda.nix
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./hosts/artist.nix
      ];
      specialArgs.inputs = inputs;
    };

    nixosConfigurations.templebar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./disko-vda.nix
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./hosts/templebar.nix
      ];
      specialArgs.inputs = inputs;
    };

    nixosConfigurations.templebar-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        agenix.nixosModules.default
        ./hosts/templebar.nix
        ({ lib, ... }: {
          fileSystems."/" = {
            device = "/dev/vda";
            fsType = "ext4";
          };

          boot.loader.grub = {
            enable = lib.mkForce true;
            devices = lib.mkForce ["/dev/vda"];
            efiSupport = lib.mkForce true;
            efiInstallAsRemovable = lib.mkForce true;
          };

          networking.useDHCP = lib.mkForce true;
          networking.hostName = lib.mkForce "templebar-vm";
          networking.interfaces.ens3 = lib.mkForce {};
          networking.defaultGateway = lib.mkForce null;

          virtualisation.vmVariant.virtualisation = {
            memorySize = 2048;
            diskSize = 4096;
            forwardPorts = [
              { from = "host"; host.port = 8080; guest.port = 80; }
              { from = "host"; host.port = 2222; guest.port = 9922; }
            ];
            sharedDirectories.host-ssh = {
              source = "/home/kavarkon/.ssh";
              target = "/mnt/host-ssh";
              securityModel = "none";
            };
          };
        })
      ];
      specialArgs.inputs = inputs;
    };

    # nix run github:nix-community/nixos-anywhere -- --flake .#installer root@artist
    nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./hosts/installer.nix
      ];
    };
  };
}
