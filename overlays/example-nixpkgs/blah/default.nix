{ stdenv
, buildPythonApplication
, pkgs
, fetchFromGitHub
, python3
, django_2_2
}:
buildPythonApplication rec {
  pname = "blah";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "blah";
    rev = "ccf4281f347fbed25d7b18f1591716a2bac120a8";
    sha256 = "00d6ip35fzybzppff84gfcz74hbma83b3zi9xwwib12y0yvxpwzs";
  };

  buildInputs = [ python3 ];

  postFixup = ''
    wrapPythonProgramsIn "$out/bin/manage.py"
    #HACK wrapper breaks django manage.py
    sed -i "$out/bin/.manage.py-wrapped" -e '
      0,/sys.argv\[0\].*;/s/sys.argv\[0\][^;]*;//
    '
    ${python3}/bin/python $out/bin/.manage.py-wrapped collectstatic --noinput
  '';

  propagatedBuildInputs = [ django_2_2 ];


}
