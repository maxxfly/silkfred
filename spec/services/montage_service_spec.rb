require 'rails_helper'

RSpec.describe MontageService do
  let(:path_fixture) {  Rails.root.join("spec", "fixtures", "files") }

  let(:green_200) { Magick::ImageList.new(path_fixture.join('green_200.png') ) }
  let(:green_300) { Magick::ImageList.new(path_fixture.join('green_300.png') ) }
  let(:red_200)   { Magick::ImageList.new(path_fixture.join('red_200.png') ) }
  let(:logo_50)   { Magick::ImageList.new(path_fixture.join('logo_50.png') ) }
  let(:logo_500)  { Magick::ImageList.new(path_fixture.join('logo_500.png') ) }

  context "images have the same height" do
    let(:montage) { MontageService.new(image_1: green_200, image_2: red_200, logo: logo_50) }
    let(:assemble) { montage.assemble }

    # check dimensions
    it { expect(montage.dimensions_images).to eql [[100,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [200, 200]}

    # check composition
    it { expect(assemble.pixel_color(0,0).to_color).to eql "green"}
    it { expect(assemble.pixel_color(99,100).to_color).to eql "green"}
    it { expect(assemble.pixel_color(100,0).to_color).to eql "red"}
    it { expect(assemble.pixel_color(200,100).to_color).to eql "red"}
    it { expect(assemble.pixel_color(200,200).to_color).to eql "blue"}
  end

  context "images have different height" do
    let(:montage) { MontageService.new(image_1: green_300, image_2: red_200, logo: logo_50) }
    let(:assemble) { montage.assemble }

    # check dimensions
    it { expect(montage.dimensions_images).to eql [[66,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [166, 200]}

    # check composition
    it { expect(assemble.pixel_color(0,0).to_color).to eql "green"}
    it { expect(assemble.pixel_color(65,100).to_color).to eql "green"}
    it { expect(assemble.pixel_color(66,0).to_color).to eql "red"}
    it { expect(assemble.pixel_color(166,100).to_color).to eql "red"}
    it { expect(assemble.pixel_color(166,200).to_color).to eql "blue"}
  end

  context "logo is too big for the picture" do
    let(:montage) { MontageService.new(image_1: green_200, image_2: red_200, logo: logo_50) }
    let(:assemble) { montage.assemble }

    # check dimensions
    it { expect(montage.dimensions_images).to eql [[100,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [200, 200]}

    # check composition
    it { expect(assemble.pixel_color(0,0).to_color).to eql "green"}
    it { expect(assemble.pixel_color(99,100).to_color).to eql "green"}
    it { expect(assemble.pixel_color(100,0).to_color).to eql "red"}
    it { expect(assemble.pixel_color(200,100).to_color).to eql "red"}
    it { expect(assemble.pixel_color(200,200).to_color).to eql "blue"}
  end

  context "margin is defined" do
    let(:montage) { MontageService.new(image_1: green_200, image_2: red_200, logo: logo_50, margin: 20) }
    let(:assemble) { montage.assemble }

    # check dimensions
    it { expect(montage.dimensions_images).to eql [[100,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [260, 240]}

    # check composition
    # => left border
    it { expect(assemble.pixel_color(0,0).to_color).to eql "white"}
    it { expect(assemble.pixel_color(19,19).to_color).to eql "white"}

    # => edge photo 1
    it { expect(assemble.pixel_color(20,20).to_color).to eql "green"}
    it { expect(assemble.pixel_color(119,100).to_color).to eql "green"}

    # => central border
    it { expect(assemble.pixel_color(119,221).to_color).to eql "white"}
    it { expect(assemble.pixel_color(120,100).to_color).to eql "white"}

    # => around photo 2 margin
    it { expect(assemble.pixel_color(139,0).to_color).to eql "white"}
    it { expect(assemble.pixel_color(139,121).to_color).to eql "white"}

    # => edge photo 2
    it { expect(assemble.pixel_color(140,20).to_color).to eql "red"}
    it { expect(assemble.pixel_color(239,100).to_color).to eql "red"}

    # => right border
    it { expect(assemble.pixel_color(240,100).to_color).to eql "white"}

    # => logo
    it { expect(assemble.pixel_color(239,219).to_color).to eql "blue"}
  end


end
