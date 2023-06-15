# Step 1 Source Control in Git

```bash

# create a local repo (defaulting name to the same as service)
svcName=MyService

git init
git add * .*
git commit -m "initial commit of $svcName"

# Create a remote repo (e.g. using gh the GitHub CLI)
# in this case my github user is preetmyob
remoteRepo=preetmyob/$svcName
gh repo create  $remoteRepo --public

# set the remote
git remote add origin https://github.com/$remoteRepo
git push --set-upstream origin main

 ```
