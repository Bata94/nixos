{}:
{
  services.k3s = {
    enable      =  true;
    clusterInit =  true;
    role = "server";
    # extraFlags  = "--cluster-cidr=10.42.0.0/16,2a10:3781:25ac:2::/64 --service-cidr=10.43.0.0/16,2a10:3781:25ac:3::/112 --flannel-iface eno1";
  };
}
