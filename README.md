# terransible

# Steps to install terraform on Ubuntu / Ubuntu cloud server :

- Download latest version of the terraform

    wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip

- Extract the downloaded file archive

    unzip terraform_0.11.10_linux_amd64.zip
- Move the executable into a directory searched for executables

    sudo mv terraform /usr/local/bin/
- Run it

    terraform --version 
