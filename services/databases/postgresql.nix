{pkgs, ...}: {
  services.postgresql = {
    enable = true;

    package = pkgs.postgresql_16;

    ensureUsers = [
      {
        name = "tasks";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "tasks"
    ];

   authentication = ''
      local   all             postgres                                peer

      local   tasks          tasks                                  md5

      host    tasks          tasks                127.0.0.1/32      md5
    '';
  };

  services.postgresqlBackup = {
    enable = true;

    databases = ["tasks"];
  };
}
