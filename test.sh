set -eu

#
# Can the other repo get changes of the force push to a remote repo? Yes
#

echo
echo "[Create bare]"
mkdir -p bare
cd bare
git init --bare
cd ..

echo
echo "[Populate bare]"
git clone bare populate
cd populate
touch 1
git add .
git commit -m 'Add 1'
touch 2
git add .
git commit -m 'Add 2'
git push origin master -u
cd ..
rm -rf populate

echo
echo "[Clone repos]"
git clone bare repo1
git clone bare repo2

echo
echo "[Force push repo1 to bare]"
cd repo1
git log
git reset --hard HEAD~1
touch 3
git add .
git commit -m 'Add 3'
git push origin master -f
git log
cd ..

echo
echo "[repo2 should see 'Add 3']"
# Can the other repo get changes of the force push?
cd repo2
git log
git fetch origin master
git clean -xdf
git reset --hard origin/master
git status
git log
cd ..

# Cleanup
rm -rf bare repo1 repo2
