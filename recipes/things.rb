unless File.exists?("#{node["things"]["destination"]}/Things.app")

  remote_file "#{Chef::Config[:file_cache_path]}/Things.zip" do
    source node["things"]["source"]
    owner WS_USER
  end

  execute "unzip Things" do
    command "unzip #{Chef::Config[:file_cache_path]}/Things.zip -d #{Regexp.escape(node["things"]["destination"])}"
    user WS_USER
  end

  ruby_block "test to see if Things.app was installed" do
    block do
      raise "Things.app was not installed" unless File.exists?("#{node["things"]["destination"]}/Things.app")
    end
  end

end



