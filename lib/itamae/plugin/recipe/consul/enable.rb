include_recipe './attribute.rb'

service "consul" do
  action [:enable, :restart]
end
