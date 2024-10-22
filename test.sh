#!/bin/bash

# /var/cache/apt/archives
#
# sudo apt-get -o Dir::State::Lists="http://path.to/your/sources.list" install some-package
# shasum -a 256 FILE
# #################################################################################################################################################
# echo "e67643b4f7af2e3f908da9140dcd3d3cdcd64dc6b2529bc63a907bf9c881ea8c *ncurses-term_6.3-2ubuntu0.1_all.deb" | shasum -a 256 --check
# echo "5d78dcd3f21d0caf86a35347beb2f963cc0f38160c995cda4552dafca598db5f *openssh-client_1%3a8.9p1-3ubuntu0.10_amd64.deb" | shasum -a 256 --check
# echo "daa8f05c0ab78d421ead44f476f68fa1318ed245e53edabff53caa99af05df69 *openssh-server_1%3a8.9p1-3ubuntu0.10_amd64.deb" | shasum -a 256 --check
# echo "32e8deeeab960a08cf7dbdabf88b9c8b73afbe2a2831d1aa776d2c7dcdff4eed *openssh-sftp-server_1%3a8.9p1-3ubuntu0.10_amd64.deb" | shasum -a 256 --check
# echo "245ebcce7417b587f06c38dbdc103e445334b93766aaa05594dd5ba09be142f7 *ssh-import-id_5.11-0ubuntu1_all.deb" | shasum -a 256 --check


declare -A PACKAGE_LIST
PACKAGE_LIST=(
    [ncurses-term_6.3-2ubuntu0.1_all]='e67643b4f7af2e3f908da9140dcd3d3cdcd64dc6b2529bc63a907bf9c881ea8c'
    [openssh-client_1%3a8.9p1-3ubuntu0.10_amd64]='5d78dcd3f21d0caf86a35347beb2f963cc0f38160c995cda4552dafca598db5f'
    [openssh-server_1%3a8.9p1-3ubuntu0.10_amd64]='daa8f05c0ab78d421ead44f476f68fa1318ed245e53edabff53caa99af05df69'
    [openssh-sftp-server_1%3a8.9p1-3ubuntu0.10_amd64]='32e8deeeab960a08cf7dbdabf88b9c8b73afbe2a2831d1aa776d2c7dcdff4eed'
    [ssh-import-id_5.11-0ubuntu1_all]='245ebcce7417b587f06c38dbdc103e445334b93766aaa05594dd5ba09be142f7'
)


PACKAGE_PATH=$(pwd)

##################################################################################################################################################
##################################################################################################################################################

function echo_info()
{
  local str=
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' str
#		num=`cat < /dev/stdin`
	else
		str="$*"
	fi

  local green=$(tput setaf 2);
  local reset=$(tput sgr0);
  (>&1 echo "${green}${str}${reset}")
}


function echo_noti()
{

  local str=
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' str
#		num=`cat < /dev/stdin`
	else
		str="$*"
	fi

  local blue=$(tput setaf 4);
  local reset=$(tput sgr0);
  
  (>&1 echo "${blue}${str}${reset}")
}

function echo_fatal()
{

  local str=
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' str
#		num=`cat < /dev/stdin`
	else
		str="$*"
	fi

  local red=$(tput setaf 1);
  local reset=$(tput sgr0);
  
  (>&2 echo "${red}Fatal:${str}${reset}");
  exit 1;
}


##################################################################################################################################################
##################################################################################################################################################

echo_info 'Check package ...'

package_sha_failed=false
for package in ${!PACKAGE_LIST[@]};
do
    echo "${PACKAGE_LIST[${package}]} *${package}.deb" | shasum -a 256 --check
    if [ ! $? -eq 0 ]; then
        package_sha_failed=true
    fi
done

if ${package_sha_failed}; then
    echo_fatal 'Package sha check failed.'
fi



echo_info 'Copy package file ...'
TMP_PATH=$(mktemp --directory)
echo "${TMP_PATH}"
for package in ${!PACKAGE_LIST[@]}; 
do
    cp "${PACKAGE_PATH}/${package}.deb" "${TMP_PATH}/${package}.deb"
    if [ $? -eq 0 ]; then
        echo "cp ${package}.deb: OK"
    else
        echo_fatal "Failed to copy ${package}.deb"
    fi
done  



echo_info 'Install package ...'
sudo dpkg -i ${TMP_PATH}/*.deb
if [ ! $? -eq 0 ]; then
    echo_fatal 'Failed to install package'
fi



echo_info 'Install openssh-server ...'
sudo apt-get install --option=Dir::Cache::Archives="${TMP_PATH}" openssh-server



