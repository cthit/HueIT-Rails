class PresetColorsController < ApplicationController
  before_action :set_preset_color, only: [:show, :edit, :update, :destroy]

  # GET /preset_colors/new
  def new
    @preset_color = PresetColor.new
  end

  # POST /preset_colors
  # POST /preset_colors.json
  def create
    @preset_color = PresetColor.new(preset_color_params)

    render :preset_colors
  end

  # DELETE /preset_colors/1
  # DELETE /preset_colors/1.json
  def destroy
    #If two people remove the same colour without updating the site, we have a race condition.
    if !@preset_color.blank?
      @preset_color.destroy
    end

    render :preset_colors
  end

  def preset_colors
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preset_color
      @preset_color = PresetColor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def preset_color_params
      params.require(:preset_color).permit(:hue, :brightness, :saturation)
    end
end
