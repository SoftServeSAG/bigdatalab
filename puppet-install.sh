OLD_DIR=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/puppet
bundle install
cd $OLD_DIR
echo "Done!"
