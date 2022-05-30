@echo off
echo "----------------------"
echo "--- Tests in testOnlyA"
echo "----------------------"
set TT=C:\cprojects\github\khtan\globalPlaywrightContainer\testOnlyA
docker run --volume %TT%:/tests --rm --ipc=host pw4:v2

echo "----------------------"
echo "--- Tests in testOnlyB
echo "----------------------"
set TT=C:\cprojects\github\khtan\globalPlaywrightContainer\testOnlyB
docker run --volume %TT%:/tests --rm --ipc=host pw4:v2
