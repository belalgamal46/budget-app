class CreateGroupTrades < ActiveRecord::Migration[7.0]
  def change
    create_table :group_trades do |t|
      t.references :group, null: false, foreign_key: true
      t.references :trade, null: false, foreign_key: true

      t.timestamps
    end
  end
end
