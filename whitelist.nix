{ lib }:
let
  # NOTE: find a way to handle duplicates better, atm they may override each
  # other without warning
  mkWhiteList = allowedPaths:
    lib.foldl' (sum: allowed:
      if (lib.pathIsDirectory allowed) then {
        tree = lib.recursiveUpdate sum.tree
          (lib.setAttrByPath (pathToParts allowed) true);
        prefixes = sum.prefixes ++ [ (toString allowed) ];
      } else {
        tree = lib.recursiveUpdate sum.tree
          (lib.setAttrByPath (pathToParts allowed) false);
        prefixes = sum.prefixes;
      }) {
        tree = { };
        prefixes = [ ];
      } allowedPaths;

  pathToParts = path: (__tail (lib.splitString "/" (toString path)));

  isWhiteListed = patterns: name: type:
    let
      parts = pathToParts name;
      matchesTree = lib.hasAttrByPath parts patterns.tree;
      matchesPrefix = lib.any (pre: lib.hasPrefix pre name) patterns.prefixes;
    in matchesTree || matchesPrefix;

  whitelist = root: allowedPaths:
    let
      patterns = mkWhiteList allowedPaths;
      filter = isWhiteListed patterns;
    in __filterSource filter root;
in whitelist
