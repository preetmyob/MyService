export ENT_API_MYSQL_TEST_VERSION=5.7
echo "--- Building and Testing with mysql:${ENT_API_MYSQL_TEST_VERSION}"
dotnet test -v quiet -l:"console;verbosity=normal" --nologo
echo "Ran dotnet test"

RESULTCODE=$?
if [[ $? -ne 0 ]]; then 
    echo "+++"
    echo ":bk-status-failed: Failed with code ($RESULTCODE), oh no!!"
fi
exit $RESULTCODE
