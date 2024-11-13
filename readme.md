create installer iso

```
nix build .#nixosConfigurations.installer.config.system.build.isoImage
```