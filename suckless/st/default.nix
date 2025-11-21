{ lib, stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation {
  pname = "benedek-st-wl";
  version = "unstable-2025-11-21";

  src = fetchFromGitHub {
    owner = "FausztBenedek";
    repo = "st-wl";
    rev = "0b43f3bdbf5c160b629930ed886216c8ee47bcfc";
    hash = "sha256-tlWK8ebCkV+qXNELNKOES13W7YZuLO1ld4fkgjACO74=";
  };

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.gnumake
    pkgs.gcc
    pkgs.wayland
    pkgs.wayland-scanner
    pkgs.wayland-protocols
  ];

  buildInputs = [
    pkgs.freetype
    pkgs.fontconfig
    pkgs.libxkbcommon
    pkgs.pixman
    pkgs.harfbuzz

  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 st-wl $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "My fork of st";
    homepage = "https://github.com/FausztBenedek/st-wl";
    mainProgram = "benedek-st-wl";
    platforms = lib.platforms.all;
  };
}
