Interface for controlling Philliphs Hue Lights in Hubben 2.1.

Currently using Ruby `2.4.1`
# Setup
```
# Clone the project.
git clone git@github.com:cthit/HueIT-Rails.git

# Install dependencies 
#(using ubuntu, for anything else google)
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmysqlclient-dev mysql-server redis-server

bundle install

# Create the secrets.yml file (fetch from wiki).
touch config/secrets.yml

#Install a MySQL server and modify config/database.yml accordingly (default options should be fine for a fresh install).

# Prepare the db
rails db:setup
rbenv rehash

# Start the server:
rails server

# The instance is now accessible at localhost:3000
```
# In case there are new lights:
You will need to update the lists indicating the id's of the lights in `app/views/lights/_lights_list.html.erb` and `app/assets/javascripts/lights.coffee`.
