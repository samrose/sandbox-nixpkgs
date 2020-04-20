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
    rev = "d1c59317c745f8a8bde3b562c8ecf955468d757f";
    sha256 = "02fkf4z2gh8hhj6c8sdr6ipyv8w2lrh81hxihwk1amql2mayay0j";
  };

  buildInputs = [ python3 ];

  postFixup = ''
    cp $src/db.sqlite3 $out/var/
    wrapPythonProgramsIn "$out/bin/manage.py"
    #HACK wrapper breaks django manage.py
    sed -i "$out/bin/.manage.py-wrapped" -e '
      0,/sys.argv\[0\].*;/s/sys.argv\[0\][^;]*;//
    '
    ${python3}/bin/python $out/bin/.manage.py-wrapped collectstatic --noinput
  '';

  propagatedBuildInputs = [ django_2_2 ];


}
