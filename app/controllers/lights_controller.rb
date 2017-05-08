class LightsController < ApplicationController
   include AdminHelper
   include PartyHelper

   before_action :set_lights, except: [:turn_on, :turn_off, :party_on_off]
   before_action :set_bulb_from_id, only: [:turn_off, :turn_on, :switch_on_off]
   before_action :check_lock_state, except: [:index]
   before_action :ruin_party, except: [:index, :party_on_off, :party_off, :party_on]

   def change_logger
      @@change_logger ||= Logger.new("#{Rails.root}/log/change.log")
   end


   #Creates sites
   def index
      @is_locked = check_lock_state
   end

   def lights
   end

   #Changes lights
   def multi_update
      if params[:lights]
         lights = params[:lights].keys.map(&:to_i).map { |id| get_lights.find(id) }.select(&:on)

         sat = params[:sat_range].to_i
         hue = params[:hue_range].to_i
         bri = params[:bri_range].to_i

         group = Huey::Group.new lights
         group.update(sat: sat, hue: hue, bri: bri)
         changedLights = lights.join(" ")

         log "Lamps ##{changedLights}color changed to hue: #{hue} sat: #{sat} bri: #{bri}"
         sse_update
      end
      render :lights
   end

   #Set standard light
   def reset_lights
      @lights.update on: true, rgb: '#cff974', bri: 254

      log "All lamps reset"
      sse_update
      render :lights
   end

   def turn_off
      @light.update(on: false)
      head :ok, content_type: "text/html"
   end

   def turn_on
      @light.update(on: true)
      head :ok, content_type: "text/html"
   end

   def turn_all_off
      @lights.update(on: false)

      log "All lights OFF"
      sse_update
      render :lights
   end

   def turn_all_on
      @lights.update(on: true)

      log "All lights ON"
      sse_update
      render :lights
   end
   #Toggles light state
   def switch_on_off
      @light.on = !@light.on
      @light.save
      log "Lamp ##{params[:id]} toggled"
      render :lights
   end

   def party_on_off
      if $is_party_on
         party_off
      else
         party_on
      end
      head :ok, content_type: "text/html"
   end

   private
   def log change
      entry = LogEntry.new
      @user = current_user
      entry.cid = @user.cid + ": " + @user.to_s
      entry.change = change
      entry.save
      entry
   end

   def party_on
      entry = log "PARTY MODE ENGAGED :DDDDD"
      $is_party_on = true

      Thread.new do
         lights = get_lights

         hue_array = Array.new
         sat_array = Array.new
         bri_array = Array.new

         lights.each_with_index do |light, i|
            hue_array[i] = light.hue
            sat_array[i] = light.sat
            bri_array[i] = light.bri
         end

         sse_update

         colors = [0, 5000, 15000, 20000, 42000, 55000, 62000]
         delay = 1
         while $is_party_on
            party_patterns = [method(:random_bulb_and_color),
                              method(:one_at_a_time_in_order),
                              method(:one_color_down_both_lanes),
                              method(:all_bulbs_same_color),
                              method(:random_color_in_order)]

            pattern = party_patterns.sample
            pattern.call lights, colors, delay
         end
         sse_update
         lights.each_with_index do |light, i|
            light.update(sat: sat_array[i], hue: hue_array[i], bri: bri_array[i])
            sleep(delay)
         end

      end
   end

   def party_off
      log "no more party :("
      $is_party_on = false
   end

   def ruin_party
      # other actions should disable party mode
      if $is_party_on
         party_off
      end
   end

   def sse_update
      # Change the value so sse_update_controller knows to send an event
      Rails.application.config.sse_int += 1
   end

   def set_bulb_from_id
      @light = get_lights.find(params[:id].to_i)
   end

   def set_lights
      @lights = get_lights
   end

   def get_lights
      begin
         $hue_not_found ||= false
         unless $hue_not_found
            Huey::Bulb.all
         else
            mock_lights
         end
      rescue Huey::Errors::CouldNotFindHue
         $hue_not_found = true
         mock_lights
      end
   end

   def mock_lights
      Huey::Group.new(
         mock_bulb(7),
         mock_bulb(2),
         mock_bulb(3),
         mock_bulb(4),
         mock_bulb(5),
         mock_bulb(6)
      )
   end

   def light_response(id = "1", name = "Living Room")
     {id => {"state"=>{"on"=>true, "bri"=>127, "hue"=>54418, "sat"=>158, "xy"=>[0.509, 0.4149], "ct"=>459, "alert"=>"none", "effect"=>"none", "colormode"=>"hue", "reachable"=>true}, "type"=>"Extended color light", "name"=>name, "modelid"=>"LCT001", "swversion"=>"65003148", "pointsymbol"=>{"1"=>"none", "2"=>"none", "3"=>"none", "4"=>"none", "5"=>"none", "6"=>"none", "7"=>"none", "8"=>"none"}}}
   end

   def mock_bulb(id = "1", name = "Living Room")
     light = light_response(id, name)
     Huey::Bulb.new(light.keys.first, light.values.first)
   end
end
