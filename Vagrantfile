Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.ssh.insert_key = false

  # --- net1 ---
  config.vm.define "net1", primary: true do |net1|
    net1.vm.hostname = "net1"
    net1.vm.network "private_network",
      ip: "192.168.100.14",
      libvirt__network_name: "lecture"
    net1.vm.provider :libvirt do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

  # --- net2 ---
  config.vm.define "net2" do |net2|
    net2.vm.hostname = "net2"
    net2.vm.network "private_network",
      ip: "192.168.100.15",
      libvirt__network_name: "lecture"
    net2.vm.provider :libvirt do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y vim curl
    echo "======================================"
    echo "✅ ВМ готова: #{ENV['HOSTNAME']}"
    echo "IP-адреса:"
    ip -br addr show | grep -E "eth[0-9]|ens[0-9]" | awk '{print "  " $1 ": " $3}'
    echo "======================================"
  SHELL

  config.vm.synced_folder ".", "/vagrant", disabled: true
end