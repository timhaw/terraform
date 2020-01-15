# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # config.vm.synced_folder "/Users/timhaw/Dropbox/Source/Repos", "/Repos"
  config.vm.synced_folder "/Users/timhaw/Dropbox/Knowledge\ Nuggets/Kubernetes\ Tutorial/kubernetes-course/skaffold-demo", "/home/vagrant/skaffold-demo"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
 
    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
    config.vm.provision "shell", inline: <<-SHELL
    apt-get update &> /dev/null
    # apt-get install -y apache2
    #
    # Install Terraform
    #
    apt-get install unzip &> /dev/null
    wget -q https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip
    unzip terraform_0.12.19_linux_amd64.zip
    mv terraform /usr/local/bin/
    #
    # Install Kops
    #
    cd /home/vagrant
    rm -f kops-linux-amd64
    wget -q https://github.com/kubernetes/kops/releases/download/1.14.0/kops-linux-amd64
    chown vagrant:vagrant kops-linux-amd64
    mv kops-linux-amd64 /usr/local/bin/kops
    chmod +x /usr/local/bin/kops
    apt-get install -y python3-pip &> /dev/null
    pip3 install --upgrade pip
    sudo -u vagrant bash -c "ssh-keygen -f /home/vagrant/.ssh/id_rsa -q -N ''" 
    # 
    # Install AWS CLI
    #
    sudo pip3 install awscli
    sudo su - vagrant -c "aws configure set aws_access_key_id AKIATRX33OH62K2YQEOB"
    sudo su - vagrant -c "aws configure set aws_secret_access_key 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"
    sudo su - vagrant -c "aws configure set default.region eu-west-2"
    #
    # Install Kubectl
    #
    wget -q https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl
    chown vagrant:vagrant kubectl
    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl
    #
    # Install Docker
    #
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common &> /dev/null
    wget -q https://download.docker.com/linux/ubuntu/gpg
    apt-key add gpg
    rm -f gpg
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &> /dev/null
    apt-get update &> /dev/null
    apt-get install -y docker-ce docker-ce-cli containerd.io &> /dev/null
    usermod -aG docker vagrant
    #
    # Install Skaffold
    #
    wget -q https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    chown vagrant:vagrant skaffold-linux-amd64
    chmod +x skaffold-linux-amd64
    mv skaffold-linux-amd64 /usr/local/bin/skaffold
    #
  SHELL
end
