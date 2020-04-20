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
    rev = "5dc7b4b41787d28fd00445be0f49451adb4206d0";
    sha256 = "09ql7928yjdrk0aaaz6nchmafid1k0bfri1qranib3kac8inigxi";
  };

  buildInputs = [ python3 ];

  postFixup = ''
    cp $src/db.sqlite3 /etc
    wrapPythonProgramsIn "$out/bin/manage.py"
    #HACK wrapper breaks django manage.py
    sed -i "$out/bin/.manage.py-wrapped" -e '
      0,/sys.argv\[0\].*;/s/sys.argv\[0\][^;]*;//
    '
    ${python3}/bin/python $out/bin/.manage.py-wrapped collectstatic --noinput
  '';

  propagatedBuildInputs = [ django_2_2 ];


}
