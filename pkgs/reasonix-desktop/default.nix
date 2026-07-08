{ lib, stdenv, fetchurl, autoPatchelfHook, copyDesktopItems, makeDesktopItem
, gtk3, webkitgtk_4_1, glib, gdk-pixbuf, pango, cairo, atk
, libsoup_3, harfbuzz, libxml2
, libGL, libX11, libxcb, libXcursor, libXrandr, libXinerama, libXi, libXext
, mesa, fontconfig, freetype
, glib-networking, gsettings-desktop-schemas, dconf
}:
let
  version = "1.17.6";

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/esengine/DeepSeek-Reasonix/main-v2/desktop/frontend/src/assets/logo-symbol.svg";
    hash = "sha256-1glkdqj1l2vjafhqsw2rgpvkdmad3f1816ybd7x4mz4gvlanclwz";
  };
in
stdenv.mkDerivation {
  pname = "reasonix-desktop";
  inherit version;

  src = fetchurl {
    url = "https://github.com/esengine/DeepSeek-Reasonix/releases/download/desktop-v${version}/Reasonix-linux-amd64.tar.gz";
    hash = "sha256-1s4khafbpgdqwnxp91pqh3py53n839wxq8712cl6hxbx8k0ivzbl";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems ];

  buildInputs = [
    gtk3 webkitgtk_4_1 glib gdk-pixbuf pango cairo atk
    libsoup_3 harfbuzz libxml2
    libGL libX11 libxcb libXcursor libXrandr libXinerama libXi libXext
    mesa fontconfig freetype
    glib-networking gsettings-desktop-schemas dconf
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "reasonix-desktop";
      exec = "reasonix-desktop";
      icon = "reasonix-desktop";
      desktopName = "Reasonix Desktop";
      comment = "DeepSeek-Reasonix desktop client";
      categories = [ "Utility" "AI" "Chat" ];
      type = "Application";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp reasonix-desktop "$out/bin/reasonix-desktop"
    chmod +x "$out/bin/reasonix-desktop"

    # Install desktop icon
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ${icon} $out/share/icons/hicolor/scalable/apps/reasonix-desktop.svg

    runHook postInstall
  '';

  meta = with lib; {
    description = "DeepSeek-Reasonix desktop client";
    longDescription = ''
      Desktop client for DeepSeek reasoning models, built with Go and
      GTK3/WebKit2GTK. Features native window management, file dialogs,
      clipboard integration, drag-and-drop, and JavaScriptCore bridge.
    '';
    homepage = "https://reasonix.io";
    changelog = "https://github.com/esengine/DeepSeek-Reasonix/releases/tag/desktop-v${version}";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = [];
  };
}
