# Template operations
```bash
# installing the template
dotnet new install <path to template root>

# uninstalling the template
dotnet new uninstall <path to template root>

# using the template to create a service (add a -force to overwrite existing)
dotnet new myobentsvc -o <name of your service>
```
# Service (template output operations)
## Step 1 Source Control in Git

```bash

# create a local repo (defaulting name to the same as service)

git init
git add * .*
git commit -m "initial commit of MyService"

# Create a remote repo (e.g. using gh the GitHub CLI)
# in this case my github user is preetmyob
remoteRepo=
gh repo create  MYOBTechnology/MyService --public

# set the remote using HTTPS. N.B. SSH details tbd
git remote add origin https://github.com/MYOBTechnology/MyService
git push --set-upstream origin main

 ```

## Step 2 Build Pipeline

*Follow the instructions on [Github | myob-auth](https://github.com/MYOB-Technology/myob-auth) to set up myobauth*


These instructions were adapted from [Buildkite System Catalog | Make a Pipeline](https://system-catalogue.myob.com/docs/default/system/buildkite/create-pipeline/#make-a-pipeline), and you are encouraged to confirm that these are the latest steps

```bash

# Auth to target AWS account:
myob-auth login --username preet.sangha@myob.com --profile default --role $adfs-enterprise-scaling-test-admin                              

# To find out your queue and team slugs run:
pipe ls -teams
pipe ls -queues


# Make a pipeline - with your exisitng buildkite.yml file:
pipe mk -t advanced-platform MyService queue=enterprise-platform-dev

# check your queue
pipe ls -queues
```

