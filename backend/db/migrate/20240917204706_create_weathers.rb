class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    # not sure if weathers is a good name for this table.
    # but for sake of simplicity, let's keep it like this
    create_table :weathers do |t|
      t.string :city, null: false
      t.string :state, null: false
      t.float :temperature, null: false
      t.string :description
      t.datetime :fetched_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :weathers, [:city, :state], unique: true
  end
end
