{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "d /media 0755 root root 10d"
    "d /media/data 0755 abayoumy abayoumy 10d"
  ];

  fileSystems."/media/data" = {
    device = "10.0.0.15:/media/data";
    fsType = "nfs";
  };
  # nfs services
  services.rpcbind.enable = true;
  services.nfs.server.enable = true;
}
