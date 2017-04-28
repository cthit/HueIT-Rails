module LightsHelper
  def find_light id_to_find
    find_light = nil
    @lights.each do |light|
      if light.id == id_to_find
        find_light = light
      end
    end
    find_light
  end
end
