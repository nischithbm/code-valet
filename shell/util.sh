#!/bin/sh

###########################################
# Utility functions for Shell Scripting
###########################################


# Function to check if Root user is executing the script
function f_rootUserCheck(){
	# https://github.com/nischithbm/sailfish-logger4sh
	log_info "Checking whether root user is executing the script"
	
	local name_l=`$c_id -un`
	local uname_l=`f_uppercase ${name_l}`

	if [ "${uname_l}" != "ROOT" ]; then
		f_die "Only user 'root' should execute this script."
	fi
}

function f_getFullPath() {
	local fileName_l="$1"; shift
	echo $(cd $(dirname "${fileName_l}") && pwd -P)/$(basename "${fileName_l}")
}


function f_fileCheck(){
	local fileName_l="$1"
    
	log_debug "Checking file $fileName_l"
    
	if [ ! -f "${fileName_l}" ]; then
		  f_die "${fileName_l} : File does not exist"
	elif [ ! -r "${fileName_l}" ]; then
		  f_die "${fileName_l} : File does not have read permission"
	fi
}

function f_dirCheck(){
	local dirName_l="$1"
    
	log_debug "Checking Directory ${dirName_l}"
  
	if [ ! -d "${dirName_l}" ]; then
		  f_die "${dirName_l} : Directory does not exist"
	elif [ ! -w "${dirName_l}" ]; then
	  	f_die "${dirName_l} : Directory does not have write permission"
	fi
}

function f_removeFile(){
	local fileName_l="$1"
    
	if [ -f "${fileName_l}" ]; then
  		rm -f "${fileName_l}"
  		local status_l=$?
  		if [ $status_l -ne 0 ]; then
  	 		log_warn "Failed to delete file: ${fileName_l}"
  		else
  			log_debug OK "Deleted file ${fileName_l}"
  		fi
	fi
}

function f_removeDir(){
	local directoryName_l="$1"
    
	if [ -d "${directoryName_l}" ] &&  [ "${directoryName_l}" != "/" ] ; then
  		rm -rf "${directoryName_l}"
  		local status_l=$?
  		if [ $status_l -ne 0 ]; then
  	 		log_warn "Failed to delete directory: ${directoryName_l}"
  		else
  			log_debug OK "Deleted directory ${directoryName_l}"
  		fi
	fi
}

function f_mkdir(){
	local directoryName_l="$1"
    
	if [ ! -d "${directoryName_l}" ] ; then
  		mkdir "${directoryName_l}"
  		local status_l=$?
  		if [ $status_l -ne 0 ]; then
  	 		log_warn "Failed to create directory: ${directoryName_l}"
  		else
  			log_debug OK "Created directory ${directoryName_l}"
  		fi
	else
		  log_debug "Direcory ${directoryName_l} already exists"
	fi
}

function f_mkdirP(){
	local directoryName_l="$1"; shift
    
	if [ ! -d "${directoryName_l}" ] ; then
		log_debug "Creating directory ${directoryName_l}"
		mkdir -p "${directoryName_l}"
	else
		log_debug "Direcory ${directoryName_l} already exists"
	fi
}

function f_cpFile(){
	local src_l="$1"; shift
	local dst_l="$1"; shift
    
	local dst_dirName_l=$(dirname "${dst_l}")
	if [ ! -d "${dst_dirName_l}" ] ; then
		log_error "${dst_dirName_l} doesn't exist cannot copy file"
	else
		cp -f "${src_l}" "${dst_l}"
		local status_l=$?
  		if [ $status_l -ne 0 ]; then
  	 		log_warn "Failed to copy: ${src_l}"
  		else
  			log_debug OK "Copied file ${src_l} to ${dst_l}"
  		fi
	fi
}

function f_cpFilesR(){
	local src_l="$1"; shift
	local dst_l="$1"; shift
    
	if [ ! -d "${dst_l}" ] ; then
		log_error "${dst_l} doesn't exist cannot copy files"
	else
		log_debug "Copying files from ${src_l} to ${dst_l}"
		cp -rf "${src_l}"/* "${dst_l}"
	fi
}

function f_chown(){
	local userName_l="$1"; shift
	local fileName_l="$1"; shift
   
	if [ "${fileName_l}" != "/" ] ; then
		chown $userName_l.$userName_l $fileName_l
	else
		log_error "Oopss ! You are trying to change the permission of root directory !!!"
	fi
}

function f_chownR(){
	local userName_l="$1"; shift
	local directoryName_l="$1"; shift
	
	if [ "$directoryName_l" != "/" ] ; then
		chown -R $userName_l.$userName_l $directoryName_l
	else
		log_error "Oopss ! You are trying to change the permission of root directory !!!"
	fi
}

function f_chmod(){
	local mod_l="$1"; shift
	local fileName_l="$1"; shift
	
	if [ "$fileName_l" != "/" ] ; then
		chmod $mod_l $fileName_l
	else
		log_error "Oopss ! You are trying to change the permission of root directory !!!"
	fi
}

function f_chmodR(){
	local mod_l="$1"; shift
	local directoryName_l="$1"; shift
	
	if [ "$directoryName_l" != "/" ] ; then
		chmod -R $mod_l $directoryName_l
	else
		log_error "Oopss ! You are trying to change the permission of root directory !!!"
	fi
}

function f_unZip() {
	local src_l="$1"; shift
	local dest_l="$1"; shift
        
	unzip -o -q "${src_l}" -d "${dest_l}"
	local status_l=$?
	if [ $status_l -ne 0 ]; then
		log_warn "Failed to extract: ${src_l}"
	else
		log_debug OK "Extracted ${src_l} to ${dest_l}"
	fi
}

# Function to convert to uppercase
function f_uppercase(){
	echo $1 | tr '[a-z]' '[A-Z]'
}

# Function to convert to lowercase
function f_lowercase(){
	echo $1 | tr '[A-Z]' '[a-z]'
}

# Function to exit with error message
function f_die(){
	log_error "$1"
	exit 1
}

function f_escapeForwardSlash(){
	local l_var="$1"; shift;
	echo ${l_var//\//\\/}
}

function f_undoEscapeForwardSlash(){
	local l_var="$1"; shift;
	echo ${l_var//\\/}
}
