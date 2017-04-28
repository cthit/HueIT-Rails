class LightsController < ApplicationController
   include AdminHelper
   include PartyHelper

   before_action :set_lights, except: [:turn_on, :turn_off, :party_on_off]
   before_action :set_bulb_from_id, only: [:turn_off, :turn_on, :switch_on_off]
   before_action :check_lock_state, except: [:index]
   before_action :check_party, except: [:index, :party_on_off, :party_off, :party_on]

   def change_logger
      @@change_logger ||= Logger.new("#{Rails.root}/log/change.log")
   end


   #Creates sites
   def index
      begin
         @is_locked = check_lock_state

      rescue Huey::Errors::CouldNotFindHue

      end
   end

   def lights
   end

   #Changes lights
   def multi_update
      if params[:lights]
         lights = params[:lights].keys.map(&:to_i).map { |id| Huey::Bulb.find(id) }.select(&:on)

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
      @lights.update on: true, rgb: '#cff974', bri: 200

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
      @user = User.find_by_token cookies[:chalmersItAuth]
      entry.cid = @user.cid + ": " + @user.to_s
      entry.change = change
      entry.save
      entry
   end

   def party_on
      entry = log "PARTY MODE ENGAGED :DDDDD"
      $is_party_on = true

      Thread.new do
         lights = Huey::Bulb.all

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
         delay = 0.2
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
            light.update(sat: sat_array[1], hue: hue_array[i], bri: bri_array[i])
            light.save
            sleep(delay)
         end

      end
   end

   def party_off
      log "no more party :("
      $is_party_on = false
   end

   def check_party
      if $is_party_on
         party_off
      end
   end

   def sse_update
      # Change the value so sse_update_controller knows to send an event
      Rails.application.config.sse_int += 1
   end

   def set_bulb_from_id
      @light = Huey::Bulb.find(params[:id].to_i)
   end

   def set_lights
      @lights = Huey::Bulb.all
   end
end
