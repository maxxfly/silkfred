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
  enum status: [ :done, :todo ]

  after_create :process_batch

  def process_batch
    montages.todo.each do |montage|
      montage.delay.perform
    end
  end

  def check_status
    if montages.todo.count == 0
      self.status = "done"
      self.save
    end
  end
end
