# Whitelist function for Nix

This is simply a function that helps whitelisting files from more complex
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

  src = whitelist ./. [
    ./something.sh
    ./otherthing.rb
    ./some/nested/thing
  ];

  ...
}
```
