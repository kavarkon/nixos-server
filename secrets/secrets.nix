let
  kavarkon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUKrA0XuY+OiXWlDctkApwtFhawDpaHQdEXW/5DTmxw kavarkon@baton";
  users = [kavarkon];

  # ssh-keyscan -p 9922 localhost
  artist = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkHIWlcQNGtO10cISM+Z4FXBJBNBzX0DbCG/zbrE7qq";
  systems = [artist];
in {
  "tasks-api.age".publicKeys = users ++ systems;
}
