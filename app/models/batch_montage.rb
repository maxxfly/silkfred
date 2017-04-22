# == Schema Information
#
# Table name: batch_montages
#
#  id         :integer          not null, primary key
#  status     :string
#  created_at :datetime
#  updated_at :datetime
#

class BatchMontage <  ActiveRecord::Base

  has_many :montages

  after_create :process_batch

  enum status: [ :done, :todo ]

  def process_batch
    montages.todo.each do |montage|
      montage.delay.perform
    end
  end
end
