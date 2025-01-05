{ lib
, stdenv
, fetchFromGitHub
, nodejs
, nodePackages
}:

stdenv.mkDerivation {
  pname = "betterdiscord";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "BetterDiscord";
    repo = "BetterDiscord";
    rev = "main";
    sha256 = "nGrbxbz5/FGOJahLsfb+2bk0gT8wSSlKvLlGXciChzE=";
  };

  nativeBuildInputs = [
    nodejs
    nodePackages.npm
    nodePackages.pnpm
  ];

  buildPhase = ''
    # set home directory to something writable
    export HOME=$TMPDIR
    
    # install dependencies
    pnpm install

    # build BetterDiscord according to documentation
    pnpm build
  '';

  installPhase = ''
    mkdir -p $out/lib/betterdiscord
    cp -r dist/* $out/lib/betterdiscord/
    
    # create a wrapper script to run the injector
    mkdir -p $out/bin
    cat > $out/bin/betterdiscord-inject <<EOF
    #!/bin/sh
    cd $out/lib/betterdiscord
    pnpm inject "\$@"
    EOF
    chmod +x $out/bin/betterdiscord-inject
  '';

  meta = with lib; {
    description = "A client modification for Discord";
    homepage = "https://betterdiscord.app/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ]; # Add yourself if you want
  };
}
