{
  environment.shellAliases = {
    # sys
    j = "z"; # zoxide
    h = "tldr";
    s = "sudo";
    ports = "sudo lsof -Pni"; # ports | fzf
    pgrep = "pgrep --full";
    pkill = "pkill --full";
    i = "host-info";
    bat = "bat --paging=never -n";

    # fs
    r = "rsync -ra --no-links --info=progress2";
    l = "ls -lahXF --group-directories-first";
    tree = "exa --tree";
    fd = "fd --hidden --exclude .git";

    # systemd
    log = "sudo journalctl --output cat -u"; # log sshd -f
    log-previous-boot = "sudo journalctl --boot=-1";
    ss = "sudo systemctl stop";
    sr = "sudo systemctl restart";
    ssu = "systemctl stop --user";
    sru = "systemctl restart --user";

    # nix
    e = "nvim /etc/nixos/configuration.nix";
    b = "sudo nixos-rebuild switch";
    search = "nix search nixpkgs";
    wipe-user-packages = "nix-env -e '*'";
    nix-gc = "sudo nix-collect-garbage --delete-older-than 30d";
    inspect-store = "nix path-info -rSh /run/current-system | sort -k2h ";

    # vim
    v = "nvim";

    # sec
    p = "gopass";
    pc = "gopass show -c";

    # git
    g = "git";
    gamend = "git add . && git commit --amend";
    gco = "git checkout";
    gc = "git commit --message";
    gca = "git commit --all --message";
    gs = "git status --short";
    gd = "git diff";
    gdc = "git diff --cached";
    gfr = "git pull --rebase";
    gl = "git lg";
    gp = "git push";
    gso = "git log -p --all --source -S "; # search string in all branches, gso <string>
  };
}
