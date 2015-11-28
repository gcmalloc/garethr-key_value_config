Puppet::Type.type(:key_value_config).provide(:consul) do
  confine feature: :consul

  mk_resource_methods

  CONSUL_HOST = 'localhost'
  CONSUL_PORT = 8086

  def exists?
    Puppet.info("Checking if key #{name} exists")
    begin
      http = Net::HTTP.new(CONSUL_HOST, CONSUL_PORT)
      http.get('/v2/key/' + name)
      parsed_resp = JSON::parse(resp.body)
      parsed_resp[:value] == resource[:value]
      return 
    rescue 
      false
    end
  end

  def create
    Puppet.info("Setting #{name} to #{resource[:value]}")
      http = Net::HTTP.new(CONSUL_HOST, CONSUL_PORT)
      http.post('key' + name)
  end

  def destroy
    Puppet.info("Deleting #{name}")
      http = Net::HTTP.new(CONSUL_HOST, CONSUL_PORT)
      http.delete('key' + name)
  end
end
