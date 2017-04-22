class MontageService
  def initialize(params)
    @image_1 = params[:image_1]
    @image_2 = params[:image_2]
    @logo = params[:logo]
    @margin = params[:margin] || 0
  end

  def assemble(path=nil)
    canvas = Magick::ImageList.new
    canvas.new_image(dimension_montage[0], dimension_montage[1]) { self.background_color = "white" }

    @image_1.scale!(dimensions_images[0][0], dimensions_images[0][1])
    @image_2.scale!(dimensions_images[1][0], dimensions_images[1][1])

    @logo.scale!(dimensions_logo[0], dimensions_logo[1])

    canvas.composite!(@image_1, Magick::NorthWestGravity, @margin, @margin, Magick::AtopCompositeOp)
    canvas.composite!(@image_2, Magick::NorthEastGravity, @margin, @margin, Magick::AtopCompositeOp)
    canvas.composite!(@logo,    Magick::SouthEastGravity, @margin, @margin, Magick::AtopCompositeOp)

    if path
      canvas.write(path)
    else
      canvas
    end
  end

  def dimensions_images
    unless @dimensions_image
      image_1_dimensions = [ @image_1.columns, @image_1.rows ]
      image_2_dimensions = [ @image_2.columns, @image_2.rows ]

      if image_1_dimensions[1] != image_2_dimensions[1]
        dest_height = [image_1_dimensions[1], image_2_dimensions[1]].min

        image_1_dimensions = [ (image_1_dimensions[0].to_f / image_1_dimensions[1] * dest_height).floor, dest_height ]
        image_2_dimensions = [ (image_2_dimensions[0].to_f / image_2_dimensions[1] * dest_height).floor, dest_height ]
      end

      @dimensions_images = [image_1_dimensions, image_2_dimensions]
    end

    @dimensions_images
  end

  def dimensions_logo
    dimensions_logo = [ @logo.columns, @logo.rows ]

    max_width = dimensions_images[1][0] / 2

    if dimensions_logo[0] > max_width
      dimensions_logo = [ max_width, (dimensions_logo[1].to_f / dimensions_logo[0].to_f * max_width).floor ]
    end

    dimensions_logo
  end

  def dimension_montage
    [ (dimensions_images[0][0] + dimensions_images[1][0]) + @margin * 3,
       dimensions_images[0][1] + @margin * 2 ]
  end

end
