
Vagrant.require_version ">= 1.9.7"

# Avoid problems with SSH due to the host locale
ENV["LC_ALL"] = "en_US.UTF-8"

# Name prefix given to VMs in VirtualBox GUI
PROJECT = "salt_banana"

# The salt root directory, containing states, pillars and etc/salt.
SALT_ROOT= "./salt_root"

MASTER_IPV4 = "192.168.50.10"

MINIONS = [
    {
        :name => "ubu1",
        :box => "bento/ubuntu-16.04",
        :ipv4 => "192.168.50.11"
    },
    {
        :name => "ubu2",
        :box => "bento/ubuntu-16.04",
        :ipv4 => "192.168.50.12"
    },
    # {
    #     :name => "fbsd",
    #     :box => "freebsd/FreeBSD-11.0-STABLE",
    #     :ipv4 => "192.168.50.13"
    # },
    {
        :name => "arch",
        :box => "archlinux/archlinux",
        :ipv4 => "192.168.50.14"
    },
    # {
    #     # https://app.vagrantup.com/Microsoft/boxes/EdgeOnWindows10
    #     :name => "win",
    #     :box => "Microsoft/EdgeOnWindows10",
    #     :ipv4 => "192.168.50.15"
    # },
]

Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        # Optimize file storage usage and super fast cloning
        vb.linked_clone = true
        # DNS: adapt to the host changing DHCP address (eg laptop).
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Disable the default `/vagrant` share
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.provision "add salt master hostname", type: "shell" do |s|
        s.inline = "echo #{MASTER_IPV4} salt >> /etc/hosts"
    end

    config.vm.define :salt do |master_config|
        master_config.vm.box = "bento/ubuntu-16.04"
        master_config.vm.hostname = "salt"
        master_config.vm.provider "virtualbox" do |vb|
            vb.name = PROJECT + "_salt"
        end
        master_config.vm.network "private_network", ip: "#{MASTER_IPV4}"
        master_config.vm.synced_folder "#{SALT_ROOT}/srv",      "/srv"
        master_config.vm.synced_folder "#{SALT_ROOT}/etc/salt", "/etc/salt"

        master_config.vm.provision :salt do |salt|
            salt.install_master = true
            #salt.install_type = "stable"
            salt.install_type = "git"
            salt.install_args = "v2017.7.0"
            salt.verbose = true
            salt.colorize = true
            # -L    install also salt-cloud
            # -P    use pip
            # -c    temporary configuration directory
            salt.bootstrap_options = "-L -P -c /tmp"
        end
    end

    MINIONS.each do |minion|
        config.vm.define minion[:name] do |minion_config|
            minion_config.vm.box = minion[:box]
            minion_config.vm.hostname = minion[:name]
            minion_config.vm.provider "virtualbox" do |vb|
                vb.name = "#{PROJECT}_#{minion[:name]}"
            end
            # minion_config.vm.network "private_network", type: "dhcp"
            minion_config.vm.network "private_network", ip: "#{minion[:ipv4]}"
            minion_config.vm.provision :salt do |salt|
                salt.install_master = false
                #salt.install_type = "stable"
                salt.install_type = "git"
                salt.install_args = "v2017.7.0"
                salt.verbose = true
                salt.colorize = true
                salt.bootstrap_options = "-P -c /tmp"
            end
        end
    end
end
