#
# Copy dot files to the right place
#

# Sync files to home folder
declare -a files=`ls -a -d .[a-z]*`
for file in "${files[@]}"
do
    cp -R $file ~/
done