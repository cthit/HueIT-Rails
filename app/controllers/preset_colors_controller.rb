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

    render :preset_color
  end

  # DELETE /preset_colors/1
  # DELETE /preset_colors/1.json
  def destroy
    @preset_color.destroy

    render :preset_color
  end

  def preset_color
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
