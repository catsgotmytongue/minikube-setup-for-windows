# a script to bootstrap a dev environment for windows based on hyperv, VSCode(with extensions), Scaffold, kubectl, and minikube

# install chocolatey if not present
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install skaffold - https://skaffold.dev
choco install skaffold --yes

# install vs code extensions

# adds debugging dev-loop features, uses skaffold
code --install-extension googlecloudtools.cloudcode --force

# kubernetes tools to view/manage kubernetes resources in code
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools --force

# install minikube
choco install minikube --yes

# Install kubectl client
choco install kubernetes-cli --yes

# MANUAL STEP - Create Hyper-V virtual switch called minikube-virtual-switch
New-VMSwitch -name minikube-virtual-switch -NetAdapterName Ethernet -AllowManagementOS $true

# Delete existing minikube configuration
minikube delete

# Setup VM configs
minikube config set hyperv-virtual-switch minikube-virtual-switch
minikube config set vm-driver hyperv
minikube config set memory 4096 # use 4096 for 4GB or 8192 for 8GB
minikube config set disk-size 80g # size in GB of virtual hard disk created for minikube, must be created on C drive unfortunately

# optional - the ingress resource is created for minikube.dev but could be anything
#            - set /etc/hosts file to point minikube.dev to minikube's ip
#            - requires certificates setup for our application to work with word directly
minikube addons enable ingress 

# use openssl to generate a self-signed certificate with certificate authority and alternate names, uses 



# optional - just a way to check if config is right
# minikube kubectl config view

# start minikube
minikube start

# import minikube docker environment vars to current shell once minikube is started
minikube docker-env | Invoke-Expression

# set user environment variables based on current shell, depends on command above being executed
[System.Environment]::SetEnvironmentVariable('DOCKER_TLS_VERIFY', $Env:DOCKER_TLS_VERIFY, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('DOCKER_HOST', $Env:DOCKER_HOST, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('DOCKER_CERT_PATH', $Env:DOCKER_CERT_PATH, [System.EnvironmentVariableTarget]::User)

# optional - add azure cli tools
#Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# point kubectl client to proper configuration with the following order of precedence:
# --kubeconfig flag [myconfigfile] - load only the config in this file
# use $Env:KUBECONFIG is a semi-colon delmited list of paths to merge
# Otherwise, $HOME/.kube/config will be used to configure kubectl


# use skaffold from the directory where skaffold.yaml lives for the project tested
# use 'skaffold build' to build dockerfiles into images 
# skaffold build

# use 'skaffold dev' to build dockerfiles and then go into a CI loop with minikube as resources or code is updated
# skaffold deploy