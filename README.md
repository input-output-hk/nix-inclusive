# Inclusive file selection function for Nix

This is simply a function that helps selecting files from more complex
directory structures.

This is sometimes preferrable over simple filters or gitignore implementations
since it allows very granular but easy to understand control over what is
included in your builds and makes splitting derivations easier so they don't
rebuild when their files don't change.

Example usage:

```nix
stdenv.mkDerivation {
  name = "example";

  ...

  src = inclusive ./. [
    ./something.sh
    ./otherthing.rb
    ./some/nested/thing
  ];

  ...
}
```

## Notes

* Directories will be added recursively
* Only path types are allowed in the inclusive list.
* There is an issue that selecting a directory and later a subdirectory may
  only add the latter one.

## Installing with niv

```
$ niv add manveru/nix-inclusive
```

Then:

```nix
{ sources ? import ./sources.nix }:     # import the sources
let
  overlay = _: pkgs: {
    manveru.nix-inclusive = pkgs.callPackage "${sources.nix-inclusive}/inclusive.nix" {};
  };
in import sources.nixpkgs
  { overlays = [ overlay ] ; config = {}; }
```

and then use `src = pkgs.manveru.nix-inclusive ./. [ ... ]`