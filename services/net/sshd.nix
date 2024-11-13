{lib, ...}: {
  services.openssh = {
    enable = true;
    ports = [9922];
    extraConfig = ''
      permitRootLogin = yes
      passwordAuthentication = no
    '';
  };
}
