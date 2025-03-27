{ stdenv, ... }:

stdenv.mkDerivation {
  name = "hyprland-launcher";
  src = ./.;
  installPhase = ''
    mkdir -p $out/share/applications
    cp $src/hyprland-launcher.desktop $out/share/applications/hyprland-launcher.desktop
  '';

}
