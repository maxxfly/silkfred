class CreateBatchMontages < ActiveRecord::Migration
  def change
    create_table :batch_montages do |t|
      t.string :status
      t.timestamps
    end
  end
end
