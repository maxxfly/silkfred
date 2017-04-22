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
#

class Montage <  ActiveRecord::Base
  belongs_to :batch_montage

  validates :photo_url_1, presence: true
  validates :photo_url_2, presence: true

  enum status: [ :done, :todo, :with_error ]

  def perform
    require "open-uri"

    images = Magick::ImageList.new

    urlimage_1 = open(photo_url_1)
    urlimage_2 = open(photo_url_2)

    images.from_blob(urlimage_1.read)
    images.from_blob(urlimage_2.read)

    Rails.logger.debug images.inspect
  end
end
