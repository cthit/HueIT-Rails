module PartyHelper
  #Choses a random lamp and sets that light to a random color.
  def random_bulb_and_color(lights, colors, delay)
    light = lights.sample
    if light.on then
       light.update(hue: colors.sample, sat: 255)
       light.save
       sleep(delay)
    end
  end

  #Cycles through each light in order and change the color to a random one and then change it back to the original color.
  def one_at_a_time_in_order(lights, colors, delay)
    prev_color = 0
    lights.each_with_index do |light, i|
      if (i-1) >= 0 && lights[i-1].on then
        lights[i-1].update(hue: prev_color)
        lights[i-1].save
      end
      if light.on then
        prev_color = light.hue
        light.update(hue: colors.sample, sat: 255)
        light.save
        sleep(delay)
      end
      if lights[5].on then
        lights[5].update(hue: prev_color)
        lights[5].save
        sleep(delay)
      end
    end
  end

   # Pattern that shifts one color down both lanes.
  def one_color_down_both_lanes(lights, colors, delay)
    prev_color_1 = 0
    prev_color_2 = 0
    for i in 0..2
      if (i-1) >= 0 then
        lights_group_prev = Huey::Group.new(lights[i-1], lights[i+2])
        if lights[i-1].on then
          lights[i-1].update(hue: prev_color_1)
        end
        if lights[i+2] then
          lights[i+2].update(hue: prev_color_2)
        end
        lights_group_prev.save
      end

      lights_group_now = Huey::Group.new(lights[i], lights[i+3])
      if lights[1].on then
        prev_color_1 = lights[i].hue
      end
      if lights[i+3] then
        prev_color_2 = lights[i+3].hue
      end
      lights_group_now.update(hue: colors.sample, sat: 255)
      sleep(delay)
    end
    if lights[2].on && lights[5].on then
      lights_group = Huey::Group.new(lights[2], lights[5])
      lights[2].update(hue: prev_color_1)
      lights[5].update(hue: prev_color_2)
      lights_group.save
      sleep(delay)
    end
  end

  #Set all bulbs to a random color.
  def all_bulbs_same_color(lights, colors, delay)
    lights_group = Huey::Bulb.all
    lights_group.update(hue: colors.sample, sat: 255)
    lights_group.save
    sleep(delay)
  end

  def random_color_in_order(lights, colors, delay)
    lights.each do |light|
      if light.on then
        light.update(hue: colors.sample, sat: 255)
        light.save
        sleep(delay)
      end
    end
  end
end
