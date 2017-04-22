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

    it { expect(montage.dimensions_images).to eql [[100,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [200, 200]}

  end

  context "images have different height" do
    let(:montage) { MontageService.new(image_1: green_300, image_2: red_200, logo: logo_50) }

    it { expect(montage.dimensions_images).to eql [[66,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [166, 200]}
  end

  context "logo is too big for the picture" do
    let(:montage) { MontageService.new(image_1: green_200, image_2: red_200, logo: logo_50) }

    it { expect(montage.dimensions_images).to eql [[100,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [200, 200]}
  end

  context "margin is defined" do
    let(:montage) { MontageService.new(image_1: green_200, image_2: red_200, logo: logo_50, margin: 20) }

    it { expect(montage.dimensions_images).to eql [[100,200], [100,200]] }
    it { expect(montage.dimensions_logo).to eql [50, 20] }
    it { expect(montage.dimension_montage).to eql [260, 240]}
  end


end
