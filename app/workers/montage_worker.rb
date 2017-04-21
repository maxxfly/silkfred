class MontageWorker
  include Sidekiq::Worker
  require "open-uri"

  def perform(montage_id)
    montage = Montage.find_by_id(montage_id)

    images = Magick::ImageList.new

    urlimage_1 = open(montage.photo_url_1)
    urlimage_2 = open(montage.photo_url_2)

    images.from_blob(urlimage_1.read)
    images.from_blob(urlimage_2.read)

    Rails.logger.debug images.inspect
  end
end
