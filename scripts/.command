#
# System configuration management tools
#
# For more details, see https://docs.qcr.ai/reference/resources/config_tracking_tool/

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

cmds=$(find $DIR/* -executable -type f | sort)

printf '%s\n' \
    'Please make a call that matches one of the following available commands:'

for c in ${cmds[@]}; do
	echo "    $(echo $c | xargs basename --)"
done

echo ''
echo 'For more details, see https://docs.qcr.ai/reference/resources/config_tracking_tool/'

exit 0
