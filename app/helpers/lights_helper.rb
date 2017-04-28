module LightsHelper
  def find_light id_to_find
    @lights.find { |light| light.id == id_to_find }
  end
end
