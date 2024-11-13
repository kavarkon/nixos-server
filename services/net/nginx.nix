{
  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      charset utf-8;
      source_charset utf-8;
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "kavarkon.dev@gmail.com";
  };
}
