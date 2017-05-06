class BulbMock
  attr_accessor :id, :hue, :sat, :bri, :on

  def initialize id, hue, sat, bri, on
    @id = id
    @hue = hue
    @sat = sat
    @bri = bri
    @on = on
  end
end
