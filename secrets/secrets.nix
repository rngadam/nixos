let 
    nixos02 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPk+adV2Jf1oNAHXP2xr17tN40osdv4q943cHGJ7Px6v root@nixos02";
in
{
    "tailscale.age".publicKeys = [ nixos02 ];
    "peertube.age".publicKeys = [ nixos02 ];
    "postgres.age".publicKeys = [ nixos02 ];
    "redis.age".publicKeys = [ nixos02 ];
}
