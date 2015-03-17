Interface for controlling Philliphs Hue Lights in Hubben 2.1

Currently using Ruby `2.1.2p95`

```
# Install vagrant plugins
vagrant plugin install vagrant-vbguest vagrant-librarian-chef vagrant-omnibus

# Start the VM and ssh into it
vagrant up
vagrant ssh

# Install dependencies
cd /vagrant
bundle install

# Create the secrets.yml file (fetch from wiki)
touch config/secrets.yml


# Prepare the db
rake db:create db:migrate
rake rails:update:bin
rbenv rehash

# Then serve:
rails server

# The instance is now accessible at localhost:3000
```
