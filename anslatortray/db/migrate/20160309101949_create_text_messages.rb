class CreateTextMessages < ActiveRecord::Migration
  def change
    create_table :text_messages do |t|
      t.string :to,    limit:13
      t.string :from,  limit:13
      t.string :body,  null:false

      t.timestamps null: false
    end
  end
end
