{
  config,
  lib,
  pkgs,
  ...
}:

{
  age.secrets.postgres = {
    file = ./secrets/postgres.age;
    mode = "770";
    owner = "peertube";
    group = "wheel";
  };

  age.secrets.peertube = {
    file = ./secrets/peertube.age;
    mode = "770";
    owner = "peertube";
    group = "wheel";
  };
  
  age.secrets.redis = {
    file = ./secrets/redis.age;
    mode = "770";
    owner = "peertube";
    group = "wheel";
  };

  networking.extraHosts = ''
     127.0.0.1 peertube
  '';

  users.users.postgres.home = lib.mkForce "/peertube/postgres";
  users.users.redis-peertube.home = lib.mkForce "/peertube/redis";
  users.users.peertube.home = lib.mkForce "/peertube/peertube";

  systemd.tmpfiles.rules = [
        "d /peertube/postgres 0700 postgres postgres -"
        "d /peertube/redis 0700 redis-peertube redis-peertube -"
        "d /peertube/peertube 0700 peertube peertube -"
  ];

  services = {

    peertube = {
      dataDirs = [
        "/peertube/peertube"
      ];
      enable = true;
      localDomain = "peertube.coderbunker.ca";
      enableWebHttps = true;

      secrets.secretsFile = config.age.secrets.peertube.path;
      database = {
        host = "127.0.0.1";
        name = "peertube_local";
        user = "peertube_test";
        passwordFile = config.age.secrets.postgres.path;
      };
      redis = {
        host = "127.0.0.1";
        port = 31638;
        passwordFile = config.age.secrets.redis.path;
      };
      settings = {
        listen =  {
            hostname = "0.0.0.0";
            port = 9000;
        };
        webserver = {
            https = true;
            hostname = "peertube.coderbunker.ca";
            port = lib.mkForce 443;
        };
        instance.name = "Coderbunker Canada PeerTube";
      };
    };

    postgresql = {
      dataDir = "/peertube/postgres";
      enable = true;
      enableTCPIP = true;
      authentication = ''
        hostnossl peertube_local peertube_test 127.0.0.1/32 md5
      '';
      initialScript = pkgs.writeText "postgresql_init.sql" ''
        \set postgres_password `cat ${config.age.secrets.postgres.path}`
        CREATE ROLE peertube_test LOGIN PASSWORD ':postgres_password';
        CREATE ROLE peertube_test LOGIN PASSWORD NULL;
        CREATE DATABASE peertube_local TEMPLATE template0 ENCODING UTF8;
        CREATE ROLE peertube_db_owner NOLOGIN;
        ALTER DATABASE peertube_local OWNER TO peertube_db_owner;
        GRANT peertube_db_owner to peertube_test;
        \connect peertube_local
        CREATE EXTENSION IF NOT EXISTS pg_trgm;
        CREATE EXTENSION IF NOT EXISTS unaccent;
      '';
    };

    redis.servers.peertube = {
      enable = true;
      bind = "0.0.0.0";
      requirePassFile = config.age.secrets.redis.path;
      port = 31638;
      settings.dir = lib.mkForce "/peertube/redis";
    };

  };
}
