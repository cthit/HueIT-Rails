class PresetColorsController < ApplicationController
  before_action :set_preset_color, only: [:show, :edit, :update, :destroy]

  # POST /preset_colors
  # POST /preset_colors.json
  def create
    @preset_color = PresetColor.create(hue: params[:hue], saturation: params[:saturation], brightness: params[:brightness])
    @preset_colors = PresetColor.all
    render :preset_colors
  end

  # DELETE /preset_colors/1
  # DELETE /preset_colors/1.json
  def destroy
    #If two people remove the same colour without updating the site, we have a race condition.
    if !@preset_color.blank?
      @preset_color.destroy
    end

    @preset_colors = PresetColor.all
    render :preset_colors
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preset_color
      @preset_color = PresetColor.find(params[:id])
    end
end
