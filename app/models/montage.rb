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

    #path_output_file = Rails.root.join('public', 'photos', "montage_" + id.to_s + '.jpg')
    #assemble = montage_service.assemble(path_output_file)

    assemble = montage_service.assemble
    assemble.format = "jpg"

    self.status = "done"

    # push the controller that display the img by the base
    self.path = HOST + "/montages/" + id.to_s + ".jpg"

    # push the local path
    #self.path = HOST + "/photos/montage_" + id.to_s + '.jpg'

    # trick to avoid S3 for heroku, we save the base64 in database
    self.base64 = Base64.encode64(assemble.to_blob)

    # self.base64 = Base64.encode64(open(path_output_file).read)
    self.save

    self.batch_montage.check_status
  end
end
