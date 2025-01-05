{ stdenv
, fetchFromGitHub
,
}: {
  # astronaut = stdenv.mkDerivation rec {
  #   pname = "sddm-astronaut-theme";
  #   version = "468a100460d5feaa701c2215c737b55789cba0fc";
  #   dontBuild = true;
  #   installPhase = ''
  #     mkdir -p $out/share/sddm/themes
  #     cp -aR $src $out/share/sddm/themes/astronaut
  #   '';
  #   src = fetchFromGitHub {
  #     owner = "Keyitdev";
  #     repo = "sddm-astronaut-theme";
  #     rev = "${version}";
  #     sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
  #   };
  astronaut = stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "468a100460d5feaa701c2215c737b55789cba0fc";

    src = fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "${version}";
      sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/astronaut
      cp -r $src/* $out/share/sddm/themes/astronaut/
      chmod -R +w $out/share/sddm/themes/astronaut
      cp ${./background.png} $out/share/sddm/themes/astronaut/Backgrounds/background.png
    '';
  };
}
