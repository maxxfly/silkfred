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

  def percentage
    ((montages.done.count / montages.count.to_f) * 100).round
  end

  def to_json
    {id: id, percentage: percentage, status: status}
  end

  def to_csv
    require 'csv'
    
    CSV.generate do |csv|
      montages.all.each do |montage|
        csv << [montage.path]
      end
    end
  end
end
