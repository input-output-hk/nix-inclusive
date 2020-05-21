{
  description = "A flake for whitelisting sources";

  edition = 201909;

  inputs.stdlib.url = "github:manveru/nix-lib";

  outputs = { self, stdlib }: {
    lib = { whitelist = import ./whitelist.nix { lib = stdlib.lib; }; };
  };
}
