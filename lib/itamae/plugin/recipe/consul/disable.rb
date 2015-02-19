include_recipe './attribute.rb'

service "consul" do
  action [:disable, :stop]
end
