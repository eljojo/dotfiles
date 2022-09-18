
{ pkgs, lib, python3 }:

let
  aigpy = python3.pkgs.buildPythonPackage rec {
    pname = "aigpy";
    version = "2022.7.8.1";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-1kQced6YdC/wvegqFVhZfej4+4aemGXvKysKjejP13w=";
    };

    propagatedBuildInputs = with pkgs.python3.pkgs; [ requests mutagen colorama ];

    doCheck = true;

    meta = with lib; {
      description = "python common lib - lol";
    };
  };
in
  python3.pkgs.buildPythonApplication rec {
    pname = "tidal-dl";
    version = "2022.8.29.1";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Dvhz/fxj75z3Y9mv19gt300Ue1UYR01mn9E1F3Hm13o=";
    };

    doCheck = true;

    propagatedBuildInputs = with python3.pkgs; [ aigpy prettytable pycrypto pydub ];

    meta = with lib; {
      homepage = "https://github.com/yaronzz/Tidal-Media-Downloader";
      description = "Tidal-Media-Downloader";
    };
  }
