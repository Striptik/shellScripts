#! /bin/sh

# Color variables for print   
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CIAN='\033[0;36m'
LGREY='\033[0;37m'
LBLACK='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LORANGE='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCIAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

updateAll() {
    echo ${CIAN} -- Update all PACKAGE.JSON files  with the latest version of dependencies and run npm install  LATEST VERSION OF DEPENDENCIES AND RUN NPM INSTALL ${NC}
    for d in ./*/ ; do (echo "$GREEN Entering in $d $NC" && cd "$d" && ncu -a && npm install); done
}

installAll() {
    echo ${BLUE} -- Run npm install on every folders ${NC}
    echo
    for d in ./*/ ; do (echo "$GREEN Entering in $d $NC" && cd "$d" &&  npm install); done
}

pullDirectories() {
    echo ${PURPLE} -- Pull every directories ${NC}
    echo
    for d in ./*/ ; do (echo "$GREEN Entering in $d $NC" && cd "$d" && git pull); done
}

pushDependenciesDirectories() {
    echo ${LGREY} -- Push all the dependencies modification \in every directories ${NC}
    echo
    for d in ./*/ ; do (echo "$GREEN Entering in $d $NC" && cd "$d" && git add package.json && git add package-lock.json && git commit -m "[AUTOMATIC DEPENDENCIES UPDATE (package*.json)]" && git push); done
}

isThereChanges() {
    echo ${LORANGE} -- See all updated modules on every directories ${NC}
    echo
    for d in ./*/ ; do (echo "$GREEN Entering in $d $NC" && cd "$d" && ncu); done
}

airbnbInstall() {
    echo ${ORANGE} -- Install Eslint Airbnb config dependencies ${NC}
    echo
    for d in ./*/ ; do (echo "$GREEN Entering in $d $NC" && cd "$d" && npm install eslint eslint-plugin-jsx-a11y eslint-plugin-react eslint-plugin-import babel-eslint eslint-config-airbnb --save); done
}


help() {
    echo
    echo
    echo Handle Dependencies Help :
    echo '-pl | --pull            Pull all the git repositories under the present directory'
    echo '-ps | --push            Push all the git repositories update dependencies under the present directory'
    echo '-i | --installAll       Npm install \in every directories available under the present directory'
    echo '-c | --changes          See all the directories changes under the present directory without updating the package.json files'
    echo '-u | --updateAll        Update all directories under the present directories running ncu -a && npm install'
    echo '--airbnb                Install ESLINT AIRBNB CONFIG dependencies for every directories under the present directory' 
    echo
    echo
}


# Check if argument is supplied
if [ -z "$1" ] ; then
    echo "$LRED Missing arguments ! $NC"
    help;
    exit;
fi

# Arguement provided, handle it 
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -u|--updateAll)
	updateAll
	shift # past argument
	;;
    -i|--installAll)
	installAll
	shift # past argument
        #shift # past value
	;;
    -pl|--pull)
	pullDirectories
	shift # past argument
        #shift # past value
	;;
   -ps|--push)
	installAll
        pushDependenciesDirectories
	shift # past argument
        #shift # past value
        ;;
    -h|--help)
	help
	shift # past argument
	;;
    -c|--changes)
	isThereChanges
	shift
	;;
    --airbnb)
	airbnbInstall
	shift
	;;
    *)    # unknown option
	echo "$RED Arguments not found ! $NC"
	help
	shift
	;;
    
esac
done