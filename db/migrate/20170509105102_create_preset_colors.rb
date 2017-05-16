class CreatePresetColors < ActiveRecord::Migration[5.1]
  def change
    create_table :preset_colors do |t|
      t.integer :hue
      t.integer :brightness
      t.integer :saturation

      t.timestamps
    end
  end
end
