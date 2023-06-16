# Template operations
```bash
# installing the template
dotnet new install <path to template root>

# updating the template
dotnet new update <path to template root>

# uninstalling the template
dotnet new uninstall <path to template root>

# using the template to create a service (add a -force to overwrite existing)
dotnet new myobentsvc -o <name of your service>
```
# Service (template output operations)
## Source Control in Git

```bash

# create a local repo (defaulting name to the same as service)

git init
git add * .*
git commit -m "initial commit of enterprise platform MyService"
git branch -M main

# Create a remote repo e.g. MYOB-Technology/enterprise-platform-MyService
# set git remote and push
# e.g 
#        git remote add origin https://github.com:MYOB-Technology/enterprise-platform-MyService.git
#        git push -u origin main
 ```

## Setting up a Buildkite pipeline


See https://github.com/MYOB-Technology/myob-auth to set up myob-auth
```bash

# Auth to target AWS account (e.g. adfs-enterprise-scaling-test-admin)
myob-auth login --username firstname.lastname@myob.com --profile default --role <aws account name>                              
```

See https://github.com/myob-ops/pipe/releases to install the pipe command
```bash
# To find out your queue and team names you can run:
pipe ls -teams
pipe ls -queues
```
See https://system-catalogue.myob.com/docs/default/system/buildkite/create-pipeline/#make-a-pipeline for more info
```bash
# Make a pipeline - with your exisitng buildkite.yml file:
pipe mk -t advanced-platform enterprise-platform-MyService queue=enterprise-platform-dev
```

