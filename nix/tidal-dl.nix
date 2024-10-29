
{ pkgs, lib, python3,python3Packages }:

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
    pname = "tidal-dl-ng";
    version = "0.15.6";

    # src = python3.pkgs.fetchPypi {
    #   inherit pname version;
    #   sha256 = "sha256-b2AAsiI3n2/s6HC37fMI/d8UcxZxsWM+fnWvdajHrOg=";
    # };
    format = "wheel";
    src = pkgs.fetchurl {
      sha256 = "sha256-ZCe3QmojCfr7juNd7kCDU/SO0aPRILkfChkeUU1JDyc";
      url = "https://files.pythonhosted.org/packages/f6/2f/0bd16441106385dde62251864630de3f3ee84d86f4c2c312d41d05a6b4be/tidal_dl_ng-0.15.6-py3-none-any.whl";
    };

    dependencies = with python3Packages; [
      toml typer rich altgraph astroid babel bandit black cachetools certifi cfgv chardet charset-normalizer click colorama tidalapi pathvalidate pbr pefile pillow pluggy dataclasses-json ffmpeg-python m3u8 pyside6 pyqtdarktheme coloredlogs pyqt6
    ];

    doCheck = true;

    propagatedBuildInputs = with python3.pkgs; [ aigpy prettytable pycrypto pydub pkgs.ffmpeg_7-headless ];

    meta = with lib; {
      homepage = "https://github.com/yaronzz/Tidal-Media-Downloader";
      description = "Tidal-Media-Downloader";
    };
  }
