# == Schema Information
#
# Table name: montages
#
#  id               :integer          not null, primary key
#  photo_url_1      :string           not null
#  photo_url_2      :string           not null
#  batch_montage_id :integer          not null
#  status           :string           not null
#  created_at       :datetime
#  updated_at       :datetime
#  path             :string
#

class Montage <  ActiveRecord::Base
  belongs_to :batch_montage

  validates :photo_url_1, presence: true
  validates :photo_url_2, presence: true

  enum status: [ :done, :todo, :with_error ]

  def perform
    require "open-uri"

    images = Magick::ImageList.new

    # read image from http
    urlimage_1 = open(photo_url_1)
    urlimage_2 = open(photo_url_2)
    images.from_blob(urlimage_1.read)
    images.from_blob(urlimage_2.read)

    # read logo
    logo = Magick::ImageList.new(Rails.root.join('app', 'assets', 'images', 'generic_logo.png'))

    # launch service
    montage_service = MontageService.new(image_1: images[0], image_2: images[1], logo: logo[0], margin: 20)
    montage_service.assemble(Rails.root.join('public', 'photos', "montage_" + id.to_s + '.jpg'))

    self.status = "done"
    self.path = HOST + "/photos/montage_" + id.to_s + '.jpg'
    self.save

    self.batch_montage.check_status
  end
end
