{
  description = "A flake for inclusive file selection in Nix";

  edition = 201909;

  inputs.stdlib.url = "github:manveru/nix-lib";

  outputs = { self, stdlib }: {
    lib = { inclusive = import ./inclusive.nix { lib = stdlib.lib; }; };
  };
}
