@echo off
echo "----------------------"
echo "--- Tests in testOnlyA"
echo "----------------------"
set TT=%cd%\testOnlyA
docker run --volume %TT%:/tests --rm --ipc=host tankh1/pw4:v2

echo "----------------------"
echo "--- Tests in testOnlyB
echo "----------------------"
set TT=%cd%\testOnlyB
docker run --volume %TT%:/tests --rm --ipc=host tankh1/pw4:v2
