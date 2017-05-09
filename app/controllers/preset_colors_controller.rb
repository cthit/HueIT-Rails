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

    respond_to do |format|
      if @preset_color.save
        format.html { redirect_to @preset_color, notice: 'Preset color was successfully created.' }
        format.json { render :show, status: :created, location: @preset_color }
      else
        format.html { render :new }
        format.json { render json: @preset_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preset_colors/1
  # DELETE /preset_colors/1.json
  def destroy
    @preset_color.destroy
    respond_to do |format|
      format.html { redirect_to preset_colors_url, notice: 'Preset color was successfully destroyed.' }
      format.json { head :no_content }
    end
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
