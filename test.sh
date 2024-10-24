

./yxpkgmgr download openssh-server --force --path '/home/emanon/Desktop/tmp' --pass test

echo '===================================================================================================='
./yxpkgmgr verify --path '/home/emanon/Desktop/tmp/openssh-server' --pass test

echo '===================================================================================================='
./yxpkgmgr info --path '/home/emanon/Desktop/tmp/openssh-server' --pass test

echo '===================================================================================================='
./yxpkgmgr install --path '/home/emanon/Desktop/tmp/openssh-server' --pass test