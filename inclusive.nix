{ lib }:
let
  # NOTE: find a way to handle duplicates better, atm they may override each
  # other without warning
  mkInclusive = allowedPaths:
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

  isIncluded = patterns: name: type:
    let
      parts = pathToParts name;
      matchesTree = lib.hasAttrByPath parts patterns.tree;
      matchesPrefix = lib.any (pre: lib.hasPrefix pre name) patterns.prefixes;
    in matchesTree || matchesPrefix;

  inclusive = root: allowedPaths:
    let
      patterns = mkInclusive allowedPaths;
      filter = isIncluded patterns;
    in __filterSource filter root;
in inclusive
