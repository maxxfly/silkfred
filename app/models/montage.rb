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
end
