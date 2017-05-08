Interface for controlling Philliphs Hue Lights in Hubben 2.1

Is used together with https://github.com/cthit/hubbIT-sniffer

Currently using Ruby `2.1.2p95`
# Setup not using vagrant
```
# Clone the project
git clone git@github.com:cthit/HueIT-Rails.git

# Install dependencies 
(using ubuntu, for anything else google)
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmysqlclient-dev mysql-server redis-server

bundle install

# Create the secrets.yml file (fetch from wiki)
touch config/secrets.yml

# Change the config/database.yml default to: 
default: &default
  adapter: mysql2
  database: hueIT
  username: root 
  password:  
  #host: naboo.chalmers.it
  #socket: /tmp/mysql.sock

# Prepare the db
bundle exec rake db:setup 
bundle exec rake db:create db:migrate
bundle exec rake rails:update:bin
rbenv rehash

# Then serve: 
rails server

# The instance is now accessible at localhost:3000
```

# Using vagrant 
One of the plugins to vagrant are deprecated so this method is not recomended.
It is of course always possible to use a clean vagrant machine  
```
# Install vagrant plugins
vagrant plugin install vagrant-vbguest vagrant-librarian-chef vagrant-omnibus

# Start the VM and ssh into it
vagrant up
vagrant ssh

# Install dependencies
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmysqlclient-dev mysql-server redis-server

cd /vagrant
bundle install

# Create the secrets.yml file (fetch from wiki)
touch config/secrets.yml

# Change the config/database.yml default to: 
default: &default
  adapter: mysql2
  database: hueIT
  username: root
  password: 
  #host: naboo.chalmers.it
  #socket: /tmp/mysql.sock

# Prepare the db
rake db:create db:migrate
rake rails:update:bin
rbenv rehash

# Then serve:
rails server -b 0.0.0.0

# The instance is now accessible at localhost:3000
```
# In case there are new lights:
You will need to update the lists indicating the id's of the lights in `app/views/lights/_lights_list.html.erb` and `app/assets/javascripts/lights.coffee`.
