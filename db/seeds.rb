# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  PresetColor.create(hue: 0,  saturation: 255, brightness: 255)
  PresetColor.create(hue: 5000,  saturation: 255, brightness: 255)
  PresetColor.create(hue: 20000,  saturation: 255, brightness: 255)
  PresetColor.create(hue: 42000,  saturation: 255, brightness: 255)
  PresetColor.create(hue: 55000,  saturation: 255, brightness: 255)
  PresetColor.create(hue: 62000,  saturation: 255, brightness: 255)
end
