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
    rev = "3418c5a232995a57c143c3420bc9be829be2803f";
    sha256 = "0v3i3chvr7bibs0zm3v3y5w38dq556jawjbgr3zkaxzxdfgrqp97";
  };

  buildInputs = [ python3 ];

  postFixup = ''
    cp $src/db.sqlite3 /etc
    wrapPythonProgramsIn "$out/bin/manage.py"
    #HACK wrapper breaks django manage.py
    sed -i "$out/bin/.manage.py-wrapped" -e '
      0,/sys.argv\[0\].*;/s/sys.argv\[0\][^;]*;//
    '
  '';

  propagatedBuildInputs = [ django_2_2 ];


}
