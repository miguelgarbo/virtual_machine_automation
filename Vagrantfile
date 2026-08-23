Vagrant.configure("2") do |config|

  config.vm.define "haproxy" do |haproxy|
    haproxy.vm.box = "ubuntu/jammy64"
    haproxy.vm.hostname = "general-haproxy"

    haproxy.vm.network "private_network", ip: "192.168.56.10"

    haproxy.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
      vb.name = "general-haproxy"
    end
  end

  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/jammy64"
    app.vm.hostname = "general-apps"

    app.vm.network "private_network", ip: "192.168.56.20"

    app.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "general-apps"
    end
  end

end