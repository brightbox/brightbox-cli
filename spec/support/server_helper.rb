# Server parameter helper

module ServerHelpers
  def server_params(name, type = nil)
    {
      :image_id      => "img-12345",
      :name          => name,
      :zone_id       => nil.to_s,
      :flavor_id     => "typ-12345",
      :user_data     => nil
    }
  end
end
