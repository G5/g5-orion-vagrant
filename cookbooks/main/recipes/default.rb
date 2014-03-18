execute "Update Package List" do
  command "apt-get update"
end

include_recipe "sane_postgresql"

include_recipe "vagrant_rbenv"

rbenv_ruby "1.9.3-p385"
rbenv_gem "bundler" do
  ruby_version "1.9.3-p385"
end

[ "git", "nodejs" ].each do |package_name|
  package package_name
end
