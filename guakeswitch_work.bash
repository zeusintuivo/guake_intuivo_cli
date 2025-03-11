#!/usr/bin/env bash
#
# @author Zeus Intuivo <zeus@intuivo.com>
#
#
function get_file_chmod() {
  #!/bin/bash
#
# @author Zeus Intuivo <zeus@intuivo.com>
#


# Bash: Detect pipe/file input in a shell script
# REF: https://gist.github.com/davejamesmiller/1966557

# How to detect whether input is from keyboard, a file, or another process.
# Useful for writing a script that can read from standard input, or prompt the
# user for input if there is none.

# Source: http://www.linuxquestions.org/questions/linux-software-2/bash-scripting-pipe-input-to-script-vs.-1-570945/
PIPED="";
COLORED="";
COUNTER=0;
# ag -i filefoo /bar/
# ag [FILE-TYPE] [OPTIONS] PATTERN [PATH]
# ack [OPTION]... PATTERN [FILES OR DIRECTORIES]
# sift [OPTIONS] PATTERN [FILE|PATH|tcp://HOST:PORT]...
#  sift [OPTIONS] [-e PATTERN | -f FILE] [FILE|PATH|tcp://HOST:PORT]...
#  sift [OPTIONS] --targets [FILE|PATH]...
#      grep [-abcdDEFGHhIiJLlmnOopqRSsUVvwxZ] [-A num] [-B num] [-C[num]] [-e pattern] [-f file]
#          [--binary-files=value] [--color[=when]] [--colour[=when]] [--context[=num]]
#          [--label] [--line-buffered] [--null] [pattern] [file ...]
# In Bash you can also use test -t to check for a terminal:

if [ -t 0 ]; then
    # Terminal input (keyboard) - interactive
    PIPED=""
else
    # File or pipe input - non-interactive
    PIPED="YES"
    # REF: http://stackoverflow.com/questions/2746553/bash-script-read-values-from-stdin-pipe
    # read PIPED #TOOD Works on mac osx, pending to test in linux and windows
    PIPED=''
    # REF: https://stackoverflow.com/questions/7314044/use-bash-to-read-line-by-line-and-keep-space
    # REF: http://www.unix.com/shell-programming-and-scripting/58611-resetting-ifs-variable.html
    OLDIFS=$IFS            # resetting IFS variable
    IFS=''                 # to read line by line and keep space
    IFS= read -r ONEPIPE   # to avoid interpretation of backslashes.
    PIPED="${ONEPIPE}"
        [ -n "$PIPED" ] && COUNTER=$((COUNTER+1))

    while read ONEPIPE
    do

         PIPED="${PIPED}
${ONEPIPE}"
         COUNTER=$((COUNTER+1))
    done
        if [ $COUNTER -eq 0 ]; then
          IFS=$OLDIFS
          exit
        fi

    #action="${ONEPIPE/ /⃝}"  # replace value inside string substitution expresion bash
    # TEST: echo "COUNTER: ${COUNTER}";echo "PIDED: ${PIPED}"; exit 0;
    IFS=$OLDIFS
fi
# Piped Input
#if [ -n "$PIPED" ]
# then
# echo "this is pipe..die "
# exit 0;
#fi
# NOT Piped Input
#if [ -z "$PIPED" ]
# then
# echo "this NOT pipe..die "
# exit 0;
#fi
#echo "PIPED:$PIPED";
#exit;

# ALTERNATIVE:
#if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
    # Pipe input (echo abc | myscript)
#    PIPED="YES"
#elif file $( readlink /proc/$$/fd/0 ) | grep -q "character special"; then
    # Terminal input (keyboard)
#    PIPED=""
#else
    # File input (myscript < file.txt)
#    PIPED=""

#fi


# CURRENT SCRIPT EXECUTING
THISSCRIPTNAME=`basename "$0"`


# PIPED ? - END

# ARGUMENTS ? - Start

# check to see if I used a message, then it will behave as a put
# bash shell script check input argument
FILENAME=""
VERBOSE=""
# Yes argument, not piped
if [ -n "$1" ] && [ -z "$PIPED" ]
  then
  {
    if [[ "$1" == "-v" ]] ;
      then
        VERBOSE="ON"
      else
        FILENAME="$1";
     fi
  }
fi
# Yes argument, yes piped
if [ -n "$1" ] && [ -n "$PIPED" ]
  then
  {
    if [[ "$1" == "-v" ]] ;
      then
        VERBOSE="ON"
    fi
    FILENAME="${PIPED}";
  }
fi

# Not argument, yes piped
if [ -z "$1" ] && [ -n "$PIPED" ]
  then
  {
    FILENAME="${PIPED}";
  }
fi
# Not argument, not Piped
if [ -z "$1" ] && [ -z "$PIPED" ]
  then
  {
    echo " "
    echo " 'Get the chmod numerical value for a file' REF: http://unix.stackexchange.com/questions/46915/get-the-chmod-numerical-value-for-a-file"
    echo "Missing 1st argument "
    echo " "
    echo "Sample Usage:    - expects one argument  *required"
    echo " "
    echo "    ${THISSCRIPTNAME}    filename [-v] for verbose"
    echo "    "
    echo "Pick one: "
    echo "    "
    ls
    exit 1;
  }
fi

# Yes argument, not piped
if [ -n "$2" ]
  then
  {
    if [[ "$2" == "-v" ]] ;
      then
        VERBOSE="ON"
     fi
  }
fi
# ARGUMENTS ? - END

# WHICH SYSTEM AND TAKE ACTION ? - Start
# check operation systems
(
  if [[ "$(uname)" == "Darwin" ]] ; then
    # Do something under Mac OS X platform
    while read -r ONE_FILENAME; do
      # if not empty
      PERMISIONS=""
      if [ -n "${ONE_FILENAME}" ] ; then
        PERMISIONS=$(stat -f "%OLp" "${ONE_FILENAME}")
      fi
      if [[ "${VERBOSE}" == "ON" ]] ;
        then
          {
            echo "${PERMISIONS} ${ONE_FILENAME}"
          }
        else
          {
            echo "${PERMISIONS}"
          }
      fi
    done <<< "${FILENAME}"

  elif [[ "$(cut -c1-5 <<< "$(uname -s)")" == "Linux" ]] ; then
    # Do something under GNU/Linux platform
    while read -r ONE_FILENAME; do
      # if not empty
      PERMISIONS=""
      if [ -n "${ONE_FILENAME}" ] ; then
        PERMISIONS=$(stat --format '%a' "${ONE_FILENAME}")
      fi
      if [[ "${VERBOSE}" == "ON" ]] ;
        then
          {
            echo "${PERMISIONS} ${ONE_FILENAME}"
          }
        else
          {
            echo "${PERMISIONS}"
          }
      fi
    done <<< "${FILENAME}"

  elif [[ "$(cut -c1-10 <<< "$(uname -s)")" == "MINGW32_NT" ]] ; then
    # Do something under Windows NT platform
     echo "Not learned yet. nothing"
    # nothing here
  fi
)
# WHICH SYSTEM AND TAKE ACTION ? - END

} # end get_file_chmod


# 18:  SIMPLE helloworld echo -e "\033[38;5;18m FOREGROUND   "; echo -e "\033[48;5;18m BACKGROUND   "
# 19:  SIMPLE helloworld echo -e "\033[38;5;19m FOREGROUND   "; echo -e "\033[48;5;19m BACKGROUND   "
# 20:  SIMPLE helloworld echo -e "\033[38;5;20m FOREGROUND   "; echo -e "\033[48;5;20m BACKGROUND   "
# 21:  SIMPLE helloworld echo -e "\033[38;5;21m FOREGROUND   "; echo -e "\033[48;5;21m BACKGROUND   "
# 25:  SIMPLE helloworld echo -e "\033[38;5;25m FOREGROUND   "; echo -e "\033[48;5;25m BACKGROUND   "
# 26:  SIMPLE helloworld echo -e "\033[38;5;26m FOREGROUND   "; echo -e "\033[48;5;26m BACKGROUND   "
# 27:  SIMPLE helloworld echo -e "\033[38;5;27m FOREGROUND   "; echo -e "\033[48;5;27m BACKGROUND   "
# 32:  SIMPLE helloworld echo -e "\033[38;5;32m FOREGROUND   "; echo -e "\033[48;5;32m BACKGROUND   "
# 33:  SIMPLE helloworld echo -e "\033[38;5;33m FOREGROUND   "; echo -e "\033[48;5;33m BACKGROUND   "
# 38:  SIMPLE helloworld echo -e "\033[38;5;38m FOREGROUND   "; echo -e "\033[48;5;38m BACKGROUND   "
# 39:  SIMPLE helloworld echo -e "\033[38;5;39m FOREGROUND   "; echo -e "\033[48;5;39m BACKGROUND   "
# 45:  SIMPLE helloworld echo -e "\033[38;5;45m FOREGROUND   "; echo -e "\033[48;5;45m BACKGROUND   "

  load_struct_testing_wget() {
      local provider="$HOME/_/clis/execute_command_intuivo_cli/struct_testing"
      [[   -e "${provider}"  ]] && source "${provider}" && (( DEBUG )) && echo  "struct_testing Loaded locally"
      [[ ! -e "${provider}"  ]] && eval """$(wget --quiet --no-check-certificate  https://raw.githubusercontent.com/zeusintuivo/execute_command_intuivo_cli/master/struct_testing -O -  2>/dev/null )"""   # suppress only wget download messages, but keep wget output for variable
      ( ( ! command -v passed >/dev/null 2>&1; ) && echo -e "\n \n  ERROR! Loading struct_testing \n \n " && exit 69; )
      return 0
  } # end load_struct_testing_wget

if [ -z "$PIPED" ] ; then
{
  echo -en "${RESET}\033[38;5;246m" 2>&1


  # -- SUDO START
  if [[ "${USER}" == 'root' || "${LOGNAME}" == 'root' ]] ; then
  {
    if [[ -n "${SUDO_USER}" && "${SUDO_USER}" != 'root' ]] ; then
    {
      echo -e "\033[38;5;20m Suddoed-in from ${SUDO_USER} ! "
    }
    else
    {
      echo -e "\033[38;5;18m Error"
      echo " "
      echo -e "\033[38;5;19m  Must run this as a 'USER' not from root "
      echo " "
      echo -e "\033[38;5;20m  expected be run by a user with SUDO rights "
      exit 1
    }
    fi
  }
  fi
  if  ( env | grep "SUDO_USER"  &>/dev/null  ) || [[ -z "${SUDO_USER}" ]] ; then
  {
    echo "Give password for ${USER} to get sudo access."
    sudo echo -n "Hey! sudo "
    echo -e "\033[38;0m "
    # USER=root
    # SHELL=/bin/sh
    # SUDO_COMMAND=/usr/bin/env
    # SUDO_USER=zeus
    # SUDO_UID=501
    # SUDO_GID=20
    # echo UID=$(sudo id -u $(logname))
    SUDO_USER="${USER}"
    SUDO_UID="${UID}"
    LOGNAME="root"
    USER="root"
    # sudo env | grep SUDO
    # sudo env | grep LOGNAME
    # sudo env | grep USER
    # sudo env | grep UID
    echo -e "Suddoed in from ${SUDO_USER} "
  }
  else
  {
    echo -e "\033[38;5;18m Error"
    echo " "
    echo -e "\033[38;5;19m  SUDO_USER exists! from some weird reason but is not root"
    echo " "
    echo -e "\033[38;5;20m  this is strange. I cannot proceed like this. "
    exit 1
  }
  fi
  SUDOS="$(sudo env | grep SUDO_USER)"
  load_struct_testing_wget
  USER_HOME="${HOME}"
}
else
{
  load_struct_testing_wget
}
fi

enforce_variable_with_value USER_HOME "${USER_HOME}"

# USER=root
# SHELL=/bin/sh
# SUDO_COMMAND=/usr/bin/env
# SUDO_USER=zeus
# SUDO_UID=501
# SUDO_GID=20
enforce_variable_with_value USER "${USER}"
enforce_variable_with_value SHELL "${SHELL}"
enforce_variable_with_value LOGNAME "${LOGNAME}"
enforce_variable_with_value SUDO_USER "${SUDO_USER}"
enforce_variable_with_value SUDO_UID "${SUDO_UID}"
# enforce_variable_with_value SUDO_GID "${SUDO_GID}"
# -- SUDO END

# echo -e "\033[38;5;45m FOREGROUND   "; echo -e "\033[48;5;45m BACKGROUND   "
# cd ${USER_HOME}/
EXECUTEOWD=$(pwd)
(( DEBUG )) && echo "${EXECUTEOWD}"
[[ -f "${EXECUTEOWD}/.temp_keys" ]] && (( DEBUG )) &&  echo "I found it "
[[ -f "${EXECUTEOWD}/.temp_keys" ]] &&  . "${EXECUTEOWD}/.temp_keys"


if [[ -n "${VPNREQUIRED}" ]] ;  then
{
  if (enforce_vpn_is_on "${VPNREQUIRED}") ; then  {
    echo Connected to VPN
  }
  else
  {
    echo ERROR VPN IS NOT ON and is REQUIRED to authenticate
    # [ $? -gt 0 ] && failed To connect before push  && exit 1
  }
  fi
}
fi

FLAGGITPROVIDER=1
if [[ -n "${GITPROVIDER}" ]] ;  then
{
  if (enforce_web_is_reachable  "${GITPROVIDER}") ; then {
    # set -x
    # set +x
    echo Reached "${GITPROVIDER}"
  }
  else
  {
    FLAGGITPROVIDER=0
    echo ERROR COULD reach GIT provider and required to authenticate ssh
    # [ $? -gt 0 ] && failed To connect git provider push  && exit 1
  }
  fi
}
fi


(( DEBUG )) && echo -e "\033[38;5;20m"  2>&1
cd "${USER_HOME}/.config/guake/"
#mkdir -p ${USER_HOME}/.config/guake/
sudo chmod 700 "${USER_HOME}/.config/guake/"
[[ -e "${USER_HOME}/.config/guake/" ]] && sudo chown -R "${SUDO_USER}" "${USER_HOME}/.config/guake/"

[[ ! -d "${USER_HOME}/.config/guake/" ]] && echo -e "\033[38;5;19m\n  Error ${USER_HOME}/.config/guake/ does not exist \n "
WORKLIST=$(ls *.json)
enforce_variable_with_value WORKLIST $WORKLIST


DESIRED_WORK_FILE=""
if [[  -n "${1}" ]] ;  then
{
  DESIRED_WORK_FILE="${1}"
}
else
{
	echo -e "\033[38;5;18m Error"
	echo " "
	echo -e "\033[38;5;19m  ${THISSCRIPTNAME} username    "
	echo " "
	echo -e "\033[38;5;20m  expected"
	echo -e "\033[38;5;21m \n Pick from work_file on the list: \n ${WORKLIST} \n"
	echo " "
	enforce_variable_with_value DESIRED_WORK_FILE "${DESIRED_WORK_FILE}"
	exit 1
}
fi






OUTPUT_FOLDER="$(pwd)"
(( DEBUG )) && echo -e "\033[38;5;25m" 2>&1
[[ ! -f "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa" ]] && echo -e "\n  Error this work_file does not exist. Pick from work_file on the list: \n ${WORKLIST} \n" && exit 1

# DEBUG=1
[[ -e "${OUTPUT_FOLDER}/session.json" ]] && sudo chmod 700 "${OUTPUT_FOLDER}/session.json"
[[ -e "${OUTPUT_FOLDER}/session.json" ]] && sudo chown -R "${SUDO_USER}" "${OUTPUT_FOLDER}/session.json"
[[ -e "${OUTPUT_FOLDER}/session.json" ]] && sudo chmod -w "${OUTPUT_FOLDER}/session.json"

(( DEBUG )) && echo chmod 1 get_file_chmod "${OUTPUT_FOLDER}"
get_file_chmod "${OUTPUT_FOLDER}"  &>/dev/null
(( DEBUG )) && get_file_chmod "${OUTPUT_FOLDER}"
(( DEBUG )) && echo chmod 2 get_file_chmod "${OUTPUT_FOLDER}/session.json"
get_file_chmod "${OUTPUT_FOLDER}/session.json"  &>/dev/null
(( DEBUG )) && get_file_chmod "${OUTPUT_FOLDER}/session.json"
(( DEBUG )) && echo chmod 3  get_file_chmod "${OUTPUT_FOLDER}/session.json"
get_file_chmod "${OUTPUT_FOLDER}/session.json"  &>/dev/null
(( DEBUG )) && get_file_chmod "${OUTPUT_FOLDER}/session.json"
(( DEBUG )) && echo sudo cat "${OUTPUT_FOLDER}/session.json"
(( DEBUG )) && sudo cat "${OUTPUT_FOLDER}/session.json"

[[ -e "${OUTPUT_FOLDER}/session.json" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/session.json"
[[ -e "${OUTPUT_FOLDER}" ]] && sudo chmod 600 "${OUTPUT_FOLDER}"
[[ -e "${OUTPUT_FOLDER}/session.json" ]] && sudo chown -R "${SUDO_USER}" "${OUTPUT_FOLDER}/session.json"



            function cpy {
            # REF: https://superuser.com/questions/472598/pbcopy-for-windows
            # I'm using the Git Bash command shell for Windows, and as someone noted above,
            # using clip is very annoying, because it also copies the carriage return at the
            # end of the output of any command. So I wrote this function to address it:
            #
            # So for example:
            #
            # $ pwd | cpy  # copies directory path
            #
            # $ git branch | cpy # copies current branch of git repo to clipboard
            #
            while read data; do     # reads data piped in to cpy
                echo "$data" | cat > /dev/clipboard     # echos the data and writes that to /dev/clipboard
            done
            tr -d '\n' < /dev/clipboard > /dev/clipboard     # removes new lines from the clipboard
            } # end cpy


	# check operation systems
	if [[ "$(uname)" == "Darwin" ]] ; then
  {
	  # Do something under Mac OS X platform
	  (( DEBUG )) && echo -e "\033[38;5;26m Stopping All SSH. It is expected to restart."
	  (( DEBUG )) && echo -e "\033[38;5;27m"
	  sudo launchctl stop com.openssh.config/guaked
	  wait
	  (( DEBUG )) && echo -e "\033[38;5;32m"
	  sudo killall sshd 2>/dev/null
	  wait
	  (( DEBUG )) && echo "Removing all Keys added to the agent."
	  sudo ssh-add -D
	  wait
	  (( DEBUG )) && echo -e "\033[38;5;33m"
	  (( DEBUG )) && echo "Adding just the only key we want to use."
	  (( DEBUG )) && echo "${OUTPUT_FOLDER}/id_rsa2048 needs pin"
	  [[ -e "${OUTPUT_FOLDER}/id_rsa2048" ]] && sudo ssh-add "${OUTPUT_FOLDER}/id_rsa2048"
	  #[[ -e "${OUTPUT_FOLDER}/id_rsa2048" ]] && sudo ssh-add -K "${OUTPUT_FOLDER}/id_rsa2048"
	  (( DEBUG )) && echo "${OUTPUT_FOLDER}/id_rsa needs pin"
    [[ -e "${OUTPUT_FOLDER}/id_rsa" ]] && sudo ssh-add "${OUTPUT_FOLDER}/id_rsa"
    #[[ -e "${OUTPUT_FOLDER}/id_rsa" ]] && sudo ssh-add -K "${OUTPUT_FOLDER}/id_rsa"
	  (( DEBUG )) && echo "${OUTPUT_FOLDER}/_ed25519"
    [[ -e "${OUTPUT_FOLDER}/_ed25519" ]] && sudo ssh-add -K "${OUTPUT_FOLDER}/_ed25519"
	  (( DEBUG )) && echo "${OUTPUT_FOLDER}/_ed25519_sk"
    [[ -e "${OUTPUT_FOLDER}/_ed25519_sk" ]] && sudo ssh-add -K "${OUTPUT_FOLDER}/_ed25519_sk"
	  (( DEBUG )) && echo "${OUTPUT_FOLDER}/_ed25519_fido2"
    [[ -e "${OUTPUT_FOLDER}/_ed25519_fido2" ]] && sudo ssh-add -K "${OUTPUT_FOLDER}/_ed25519_fido2"
	  (( DEBUG )) && echo "${OUTPUT_FOLDER}/_ecdsa_sk"
    [[ -e "${OUTPUT_FOLDER}/_ecdsa_sk" ]] && sudo ssh-add -K "${OUTPUT_FOLDER}/_ecdsa_sk"

     (( FLAGGITPROVIDER )) &&  [[ "${TEST_GIT}" ==  *"Permission denied"* ]] && $(pbcopy < ${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub)  && echo "------ Key Needs to be added in WebPAGE. Copied to CLipboard"
  }
	elif [[ "$(cut -c1-5 <<< "$(uname -s)")" == "Linux" ]] ; then
  {
	  # Do something under GNU/Linux platform
	  # ubuntu lsb_release -i | sed 's/Distributor\ ID://g' = \tUbuntu\n
    echo "xclip -sel clip < ${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub"
    xclip -sel clip < "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub"
     (( FLAGGITPROVIDER )) &&  [[ "${TEST_GIT}" ==  *"Permission denied"* ]] && $(xclip -sel clip < ${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub)  && echo "------ Key Needs to be added in WebPAGE. Copied to CLipboard"
    # (( FLAGGITPROVIDER )) &&  echo "no xclip"
  }
	elif [[ "$(cut -c1-10 <<< "$(uname -s)")" == "MINGW32_NT" ]] ; then
  {
	  # Do something under Windows NT platform
     (( FLAGGITPROVIDER )) &&  [[ "${TEST_GIT}" ==  *"Permission denied"* ]] && $(cat ${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub | cpy)  && echo "------ Key Needs to be added in WebPAGE. Copied to CLipboard"
	  # cat ${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub | cpy
	  # cat ${USER_HOME}/.config/guake/id_rsa.pub | clip
	  # nothing here
  }
	fi

# Assuming USER is root with sudo
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa2048.pub" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa2048.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa2048" ]] && sudo chmod 400 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa2048"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa" ]] && sudo chmod 400 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519.pub" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519" ]] && sudo chmod 400 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk.pub" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk" ]] && sudo chmod 400 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2.pub" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2" ]] && sudo chmod 400 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk.pub" ]] && sudo chmod 644 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk" ]] && sudo chmod 400 "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk"

[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa2048.pub" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa2048.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_rsa"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519.pub" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk.pub" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_sk"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2.pub" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ed25519_fido2"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk.pub" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk.pub"
[[ -e "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk" ]] && sudo chown -R "${USER}" "${OUTPUT_FOLDER}/${DESIRED_WORK_FILE}_ecdsa_sk"
if  (( FLAGGITPROVIDER )) &&  [[ "${TEST_GIT}" ==  *"successfully authenticated"* ]] ; then
{
  GET_USERNAME_FROM_GREETING=$(echo "${TEST_GIT%\!*}" | sed -e 's/Hi //')
  enforce_variable_with_value GET_USERNAME_FROM_GREETING $GET_USERNAME_FROM_GREETING
  USERNAME="${GET_USERNAME_FROM_GREETING}"
  enforce_variable_with_value USERNAME "${USERNAME}"
}
fi

echo -en "\033[38;5;39m" 2>&1
git config --global user.email "${GET_EMAIL_FROM_PUB_KEY}"
echo -en "\033[38;5;45m" 2>&1
git config --global user.name "${USERNAME}"
echo -en "\033[38;5;51m" 2>&1
OUTPUT_GITCONFIG="$(git config --global -l )"
echo -n "$OUTPUT_GITCONFIG" | grep "user."
(( DEBUG )) && sudo ssh-add -l
echo -en "\033[0m" 2>&1
# git config -l
#
# echo " "
# echo "ls -la ${OUTPUT_FOLDER}"
# echo " "
# ls -la ${OUTPUT_FOLDER}
