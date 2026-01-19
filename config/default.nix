{
  version.enableNixpkgsReleaseCheck = false;
  imports = [
    ./options.nix
    ./keymappings.nix
    ./plugins
  ];
}
