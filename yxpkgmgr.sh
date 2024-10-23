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

YX_DATE_DEFAULT_TIMEFMT="%Y-%m-%d %H:%M:%S"

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

function echo_err()
{
  local str=
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' str
#		num=`cat < /dev/stdin`
	else
		str="$*"
	fi

  local magenta=$(tput setaf 5);
  local reset=$(tput sgr0);

  (>&2 echo "${magenta}${str}${reset}")
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

function yx_str_length()
{
	local str=
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' str
		#		num=`cat < /dev/stdin`
	else
		str=$1
	fi
	
	echo ${#str}
}

##################################################################################################################################################
##################################################################################################################################################

function os_type()
{
	
	local release=''
	
	if [ -n "${OSTYPE}" ]; then
		if [[ "${OSTYPE}" == "linux-gnu"* ]]; then
			release="linux"
		elif [[ "${OSTYPE}" == "bsd"* ]]; then 
			release="bsd"
		elif [[ "${OSTYPE}" == "freebsd"* ]]; then 
			release="freebsd"
		elif [[ "${OSTYPE}" == "darwin"* ]]; then 
			release="osx"
		elif [[ "${OSTYPE}" == "solaris"* ]]; then 
			release="solaris"
		elif [[ "${OSTYPE}" == "cygwin" ]]; then 
			# POSIX compatibility layer and Linux environment emulation for Windows 
			release="cygwin"
		elif [[ "${OSTYPE}" == "msys" ]]; then 
			# Lightweight shell and GNU utilities compiled for Windows (part of MinGW) 
			release="msys"
		elif [[ "${OSTYPE}" == "win32" ]]; then 
			# I'm not sure this can happen. 
			release="windows"
		else 
			release="unknown"
		fi
	else
		
		# $OSTAYPE not recognized by the older shells (such as Bourne shell).
		# Use `uname` instead
		
		case $(uname | tr '[:upper:]' '[:lower:]') in
			linux*)
				release='linux'
			;;
			freebsd*)
				release='freebsd'
			;;
			darwin*)
				release="osx"
			;;
			SunOS*)
				release="solaris"
			;;
			msys*)
				release="msys"
			;;
			windows*)
				release="windows"
			;;
			*)
				release="unknown"
			;;
		esac
	fi
	
	
	echo "${release}"
}

##################################################################################################################################################
##################################################################################################################################################

YX_DATE_DEFAULT_TIMEFMT="%Y-%m-%d %H:%M:%S"
YX_DATE_STD_TIMEFMT="%a %b %d %T %Z %Y"

function yx_date_timestamp()
{
	# date +%s
	if [[ $(os_type) == 'osx' ]]; then
	  date -j -f "${YX_DATE_STD_TIMEFMT}" "`date`" "+%s"
	else
	  date '+%s'
	fi
}

function yx_date_fmtconvert()
{
	# arguments
	local timestr=
	local oldfmt=${YX_DATE_STD_TIMEFMT}
	local newfmt=${YX_DATE_STD_TIMEFMT}
	
	
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' timestr
	else
		while [ $# -gt 0 ]; do
			case $1 in
				
				--time | -t )
					shift
					timestr=$1
				;;
				
				--oldfmt | -o )
					shift
					oldfmt=$1
				;;
				
				--newfmt | -n )
					shift
					newfmt=$1
				;;
				
				*)
					#usage
					exit
				;;
			esac
			shift
		done
	fi
	
	if [[ $(os_type) == 'osx' ]]; then
		date -j -f "${oldfmt}" "${timestr}" "${newfmt}"	
	else
		date -d "@${timestr}" "${newfmt}"
	fi
	
}

function yx_time_timestamp2fmt()
{
	# arguments
	local timestamp=
	local fmt=
	local default_fmt=${YX_DATE_DEFAULT_TIMEFMT}
	local std_fmt=${YX_DATE_STD_TIMEFMT}
	local usdstd=false # 使用当前系统默认时间格式
	
	
	if (( $# == 0 )) ; then
		read -r -t 5 -d $'\0' timestamp
	else
		while [ $# -gt 0 ]; do
			case $1 in
				
				--timestamp | -t )
					shift
					timestamp=$1
				;;
				
				--fmt | -f )
					shift
					fmt=$1
				;;
				
				--std | -s )
					usdstd=true
				;;
				
				*)
					#usage
					exit
				;;
			esac
			shift
		done
	fi
	
	
	# 暂时只支持10位时间戳
	if [[ `yx_str_length ${timestamp}` > '10' ]]; then
		timestamp=`yx_str_limit 10 ${timestamp}`
	fi
	
	# 是否使用系统默认format, 默认不使用
	if [[ -z ${fmt} ]]; then
		if ${usdstd}; then
			fmt=${std_fmt}
		else
			fmt=${default_fmt}
		fi
	fi
	
	#	date -r ${timestamp} # 不用这个,是因为时间格式习惯问题
	yx_date_fmtconvert --time "${timestamp}" --oldfmt "%s" --newfmt "+${fmt}"
}

##################################################################################################################################################
##################################################################################################################################################

function _sed_escape() {
	sed -e 's/[]\/$*.^[]/\\&/g'
}


function read_cfg_key()
{

	local file=
	local key=

	while [ $# -gt 0 ]; do
		case $1 in
		--file )
			shift
			file=$1
		;;

		--key )
			shift
			key=$1
		;;

		*)
			echo_fatal "Invalid optional ${1}"
		;;
		esac
		shift
	done

	if [ -z "${key}" ]; then
		echo_fatal 'key is empty'
	fi

	if [ -z "${file}" ]; then
		echo_fatal 'file is empty'
	fi


	local fixkey=$(echo "${key}" | _sed_escape)
	test -f "${file}" && grep -E "^\s*${fixkey}\s*=\s*" "${file}" | sed -e  "s/[[:space:]]*${fixkey}[[:space:]]*=[[:space:]]*//g" | grep -o "[^ ]\+\( \+[^ ]\+\)*"
}

function write_cfg_key()
{

	local file=
	local key=
	local val=

	while [ $# -gt 0 ]; do
		case $1 in
		--file )
			shift
			file=$1
    ;;

		--key )
			shift
			key=$1
    ;;

		--val )
			shift
			val=$1
    ;;

    *)
			echo_fatal "Invalid optional ${1}"
    ;;
		esac
		shift
	done


  if [ -z "${key}" ]; then
    echo_fatal 'key is empty'
	fi

	if [ -z "${val}" ]; then
    echo_fatal 'val is empty'
	fi

	if [ -z "${file}" ]; then
		echo_fatal 'file is empty'
	fi


	local fixkey=$(echo "${key}" | _sed_escape)
	if test -f "${file}" &&  grep -Eq "^\s*${fixkey}\s*=\s*${val}\s*$" "${file}"; then # Testfile exist and text 'key = val' exist, do nothing ...
		:
	elif test -f "${file}" && grep -Eq "^\s*#\s*${fixkey}\s*=.*$" "${file}"; then #Test file exist and text '# key = xxx' exist
		if 	grep -Eq "^\s*#\s*${fixkey}\s*=\s*${val}\s*$" "${file}"; then #Test exist '# key = val', remove '#' and format line.
			if [[ $(os_type) == 'osx' ]]; then
				sed -i "" "s/^[[:space:]]*#*[[:space:]]*${fixkey}[[:space:]]*=.*/${fixkey} = ${val}/g" "${file}"
			else
				sed -i "s/^[[:space:]]*#*[[:space:]]*${fixkey}[[:space:]]*=.*/${fixkey} = ${val}/g" "${file}"
			fi
		else # Text '# key=???' exist, append 'key = val' below.
			if [[ $(os_type) == 'osx' ]]; then
			    # 因为sed在OSX上的问题，这里不得不换行!!!
				sed -i "" "/^[[:space:]]*#*[[:space:]]*${fixkey}[[:space:]]*=.*/ a\\
				${fixkey} = ${val}\\
				" "${file}"
			else
				sed -i "/^[[:space:]]*#*[[:space:]]*${fixkey}[[:space:]]*=.*/ a ${fixkey} = ${val}" "${file}"
			fi
		fi
	else
		echo "${key} = ${val}" >> "${file}"
	fi	
}

##################################################################################################################################################
##################################################################################################################################################

function cmd_info()
{
  local pkg_path=
  local tmp_path=

  while [ $# -gt 0 ]; do
		case $1 in

      --path )
        shift
        pkg_path=$1
      ;;

      --tmp-path )
        shift
        tmp_path=$1
      ;;

      --help )
        show_help=true
      ;;

      *)
        additional="${additional} $1"
      ;;
		esac
		shift
	done

  if [ -z ${pkg_path} ]; then
    echo_fatal "Unknown package path. Use --help to show more information"
  fi


  if [ -n "${tmp_path}" ]; then
    # Test temp directory
    if [ ! -d "${tmp_path}" ]; then
      echo_fatal "${tmp_path} not exist."
    fi
  else
    # Create a temp directory
    tmp_path=$(mktemp --directory)
    if [ ! -d "${tmp_path}" ]; then
      echo_fatal "Failed to create a temp directory"
    fi
  fi



  # Extract all files to temp directory
  tar --extract --file="${pkg_path}" --directory="${tmp_path}"



  # Check package name
  local pkg_name=$(read_cfg_key --key 'name' --file "${tmp_path}/info.conf")
  echo "package: ${pkg_name}"


  # Check timestamp
  local timestamp=$(read_cfg_key --key 'timestamp' --file "${tmp_path}/info.conf")
  local datestr=
  if [ -n "${timestamp}" ]; then
    # datestr=$(date -j -f "%s" "${timestamp}" "+${YX_DATE_DEFAULT_TIMEFMT}")
    datestr=$(yx_time_timestamp2fmt --timestamp ${timestamp})
    echo "Created: ${datestr}(${timestamp})"
  else
    echo "Created: <unknown>"
  fi
  # timestamp
  # timestamp=$(date '+%s')
  # date -d @${timestamp}
  # date -d @${timestamp} "+%Y-%m-%d %H:%M:%S"


  # check hash value
  if [[ -f "${tmp_path}/list" ]] && [[ -f "${tmp_path}/hash" ]] ; then
    while read file_name; do
      local hash_val=$(read_cfg_key --key ${file_name} --file "${tmp_path}/hash")
      if [ -z "${hash_val}" ]; then
        hash_val='<empty>'
      fi
      echo "${file_name}.deb    ${hash_val}"
    done < "${tmp_path}/list"
  fi

}

function cmd_download()
{
  local tmp_path=
  local pkg_path=
  local pkg_name=$1
  local force=false
  if ! [[ "${pkg_name}" =~ ^-.*$ ]]; then
    shift
  else
    pkg_name=
  fi

  while [ $# -gt 0 ]; do
		case $1 in

      --path )
        shift
        pkg_path=$1
      ;;

      --force )
        force=true
      ;;

      --help )
        show_help=true
      ;;

      *)
        additional="${additional} $1"
      ;;
		esac
		shift
	done


  if [ -z "${pkg_name}" ]; then
    echo_fatal "Unknown package name. Use --help to show more information"
  fi

  if [ -z "${pkg_path}" ]; then
    echo_fatal "Unknown download path. Use --help to show more information"
  fi


  echo_info "Download package ${pkg_name}..."

  # Create a temp directory
  tmp_path=$(mktemp --directory)
  if [ ! -d "${tmp_path}" ]; then
    echo_fatal "Failed to create a temp directory"
  fi

  # # Use apt-get download all deb files
  sudo apt-get install -y --download-only --option=Dir::Cache::Archives="${tmp_path}" "${pkg_name}"
  #echo "sudo apt-get install -y --download-only --option=Dir::Cache::Archives=${tmp_path} ${pkg_name}"
  if [ ! $? -eq 0 ]; then
    echo_fatal "Failed to download package: ${pkg_name}"
  fi

  # apt-cache policy --option=Dir::Cache::Archives="${tmp_path}" ${pkg_name}


  echo_info "Create package ${pkg_name}..."

  # Create info.conf
  # package name
  write_cfg_key --key 'name' --val "${pkg_name}" --file "${tmp_path}/info.conf"
  # timestamp
  # local timestamp=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
  local timestamp=$(yx_date_timestamp)
  write_cfg_key --key 'timestamp' --val "${timestamp}" --file "${tmp_path}/info.conf"

  tar --create --absolute-names --file="${tmp_path}/${pkg_name}.tar" -C "${tmp_path}" "info.conf"
  if [ ! $? -eq 0 ]; then
    echo_fatal "Failed to create compresse package"
  fi

  # Append all deb files to tar
  touch ${tmp_path}/list 
  for package in $(find ${tmp_path} -name "*.deb" 2>/dev/null); do
    local file_name=$(basename "${package}")
    local hash_val=$(shasum -a 256 "${package}" | awk '{print $1}')

    if [[ -n "${file_name%.*}" ]] && [[ -n "${hash_val}" ]]; then
      # Append deb files
      tar --append --absolute-names --file="${tmp_path}/${pkg_name}.tar" -C "${tmp_path}" "${file_name}"
      if [ $? -eq 0 ]; then
        # Append filename to list
        echo ${file_name%.*} >> ${tmp_path}/list
        # Write file list and hash vallue to config
        write_cfg_key --key ${file_name%.*} --val ${hash_val} --file ${tmp_path}/hash
        echo "${file_name%.*} ${hash_val}: OK"
      else
        echo_fatal "Failed to compress package: ${file_name}"
      fi
    fi
  done

  # Append list file to tar
  tar --append --absolute-names --file="${tmp_path}/${pkg_name}.tar" -C "${tmp_path}" "list"
  # Append config file to tar
  tar --append --absolute-names --file="${tmp_path}/${pkg_name}.tar" -C "${tmp_path}" "hash"
  if [ ! $? -eq 0 ]; then
    echo_fatal "Failed to create compresse info.conf"
  fi


  # Copy tar file to pkg_path
  if [ ! -d  "${pkg_path}" ]; then
      echo_err "${pkg_path} not exist, try create one"
      mkdir -p ${pkg_path} > /dev/null
      if [ ! -d  "${pkg_path}" ]; then
        echo_fatal "Failed to mkdir ${pkg_path}"
      fi
  fi

  if [ -f "${pkg_path}/${pkg_name}" ]; then
    if ${force}; then
      echo "${pkg_path}/${pkg_name} already exist. try remove it"
      rm -f "${pkg_path}/${pkg_name}"
      if [ -f "${pkg_path}/${pkg_name}" ]; then
        echo_fatal "Failed to remove the old file in ${pkg_path}/${pkg_name}"
      fi
    else
      echo_fatal "${pkg_path}/${pkg_name} already exist."
    fi
  fi

  cp "${tmp_path}/${pkg_name}.tar" "${pkg_path}/${pkg_name}"
    if [ ! $? -eq 0 ]; then
    echo_fatal "Failed to copy compressed package ${pkg_path}/${pkg_name}"
  fi

  # Verify compressed package
  echo_info "Verify package..."
  cmd_verify --path "${pkg_path}/${pkg_name}"
  if [ $? -eq 0 ]; then
    echo 'Done'
  else
    rm -r -f "${pkg_path}/${pkg_name}"
    echo_fatal "Verify failed. there is something wrong with new package. delete it"
  fi

}


function cmd_verify()
{
  local pkg_path=
  local tmp_path=
  local check_failed=false

  while [ $# -gt 0 ]; do
		case $1 in

      --path )
        shift
        pkg_path=$1
      ;;

      --tmp-path )
        shift
        tmp_path=$1
      ;;

      --help )
        show_help=true
      ;;

      *)
        additional="${additional} $1"
      ;;
		esac
		shift
	done

  if [ -z ${pkg_path} ]; then
    echo_fatal "Unknown package path. Use --help to show more information"
  fi


  if [ -n "${tmp_path}" ]; then
    # Test temp directory
    if [ ! -d "${tmp_path}" ]; then
      echo_fatal "${tmp_path} not exist."
    fi
  else
    # Create a temp directory
    tmp_path=$(mktemp --directory)
    if [ ! -d "${tmp_path}" ]; then
      echo_fatal "Failed to create a temp directory"
    fi
  fi



  # Extract all files to temp directory
  tar --extract --file="${pkg_path}" --directory="${tmp_path}"



  # Check package name
  local pkg_name=$(read_cfg_key --key 'name' --file "${tmp_path}/info.conf")
  if [ -n "${pkg_name}" ]; then
    echo "name -> ${pkg_name}: OK"
  else
    check_failed=true
    echo "name -> ???: NO"
  fi


  # check hash value
  if [ -f "${tmp_path}/list" ]; then
    local num_of_lines_in_list=$(wc -l "${tmp_path}/list" | awk '{print $1}')
    echo "package list -> ${num_of_lines_in_list} items: OK"

    if [ -f "${tmp_path}/hash" ]; then
      local num_of_lines_in_hash=$(wc -l "${tmp_path}/hash" | awk '{print $1}')

      if [[ ${num_of_lines_in_list} == ${num_of_lines_in_hash} ]]; then
        echo "Hash file -> ${num_of_lines_in_hash} items: OK"
      else
        echo "Hash file -> ${num_of_lines_in_hash} items: NO"
      fi

      echo "Hash value:"
      while read file_name; do
        local hash_val=$(read_cfg_key --key ${file_name} --file "${tmp_path}/hash")
        echo "${hash_val} *${file_name}.deb" | shasum -a 256 --check
        if [ ! $? -eq 0 ]; then
          check_failed=true
        fi
      done < "${tmp_path}/list"
    else
      check_failed=true
      echo "Hash file: Error"
    fi
  else
   check_failed=true
   echo "File list: Error"
  fi


  if ${check_failed}; then
    return 1
  else
    return 0
  fi
}

function cmd_install()
{
  local pkg_path=
  local tmp_path=
  local check_failed=false

  while [ $# -gt 0 ]; do
		case $1 in

      --path )
        shift
        pkg_path=$1
      ;;

      --tmp-path )
        shift
        tmp_path=$1
      ;;

      --help )
        show_help=true
      ;;

      *)
        additional="${additional} $1"
      ;;
		esac
		shift
	done 


  if [ -z ${pkg_path} ]; then
    echo_fatal "Unknown package path. Use --help to show more information"
  fi


  if [ -n "${tmp_path}" ]; then
    # Test temp directory
    if [ ! -d "${tmp_path}" ]; then
      echo_fatal "${tmp_path} not exist."
    fi
  else
    # Create a temp directory
    tmp_path=$(mktemp --directory)
    if [ ! -d "${tmp_path}" ]; then
      echo_fatal "Failed to create a temp directory"
    fi
  fi

  echo_info "Verify package..."
  cmd_verify --path ${pkg_path} --tmp-path ${tmp_path}
  if [ ! $? -eq 0 ]; then
    echo_fatal "Verify failed. target is invalid"
  fi


  echo_info "Get package info..."
  local pkg_name=$(read_cfg_key --key 'name' --file "${tmp_path}/info.conf")
  if [ -z "${pkg_name}" ]; then
    echo_fatal "Failed to get package info"
  fi
  echo "package: ${pkg_name}"

  local timestamp=$(read_cfg_key --key 'timestamp' --file "${tmp_path}/info.conf")
  if [ -n "${timestamp}" ]; then
    datestr=$(yx_time_timestamp2fmt --timestamp ${timestamp})
    echo "Created: ${datestr}(${timestamp})"
  else
    echo "Created: <unknown>"
  fi


  echo_info 'Install package ...'
  # 避免安装包中有非法deb文件
  local install_path=$(mktemp --directory)
  if [ ! -d "${install_path}" ]; then
    echo_fatal "Failed to create a temp directory"
  fi

  if [ -f "${tmp_path}/list" ]; then
    while read file_name; do
      cp "${tmp_path}/${file_name}.deb" "${install_path}/${file_name}.deb"
      if [ ! $? -eq 0 ]; then
        echo_fatal "Failed to copy deb file: ${file_name}"
      fi
    done < "${tmp_path}/list"
  fi

  sudo dpkg -i ${install_path}/*.deb
  if [ ! $? -eq 0 ]; then
      echo_fatal 'Failed to install package'
  fi


  echo_info "Install ${pkg_name} ..."
  sudo apt-get install --option=Dir::Cache::Archives="${install_path}" "${pkg_name}"
  if [ ! $? -eq 0 ]; then
    echo_fatal "Failed to install ${pkg_nmae}"
  fi

}

##################################################################################################################################################
##################################################################################################################################################

sub_cmd=$1
shift
if [[ -z ${sub_cmd} ]]; then
  echo_fatal "param error. use '${CMD} --help' to show document"
fi

if [[ ${sub_cmd} == "download" ]]; then
  cmd_download $@
elif [[ ${sub_cmd} == "install" ]]; then
  cmd_install $@
elif [[ ${sub_cmd} == "verify" ]]; then
  cmd_verify $@
elif [[ ${sub_cmd} == "info" ]]; then
  cmd_info $@
else
  echo_fatal "Unknown sub command:'${sub_cmd}'. Use '${CMD} --help' to show document"
fi


exit 0

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


