{ config, lib, pkgs, ... }: {
  age.secrets.postgresql-templebar = {
    file = ../../secrets/postgresql-templebar.age;
    owner = "postgres";
  };

  services.postgresql = {
    enable = true;

    package = pkgs.postgresql_18;

    settings.listen_addresses = "localhost";

    ensureUsers = [
      {
        name = "templebar";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "templebar"
    ];

   authentication = ''
      local   all             postgres                                peer

      local   templebar          templebar                                  md5

      host    templebar          templebar                127.0.0.1/32      md5
    '';
  };

  systemd.services.postgresql-setup.script = lib.mkAfter ''
    PASSWORD=$(cat ${config.age.secrets.postgresql-templebar.path})
    psql -tAc "ALTER ROLE templebar PASSWORD '$PASSWORD';"
  '';

  services.postgresqlBackup = {
    enable = true;

    databases = ["templebar"];
  };
}
