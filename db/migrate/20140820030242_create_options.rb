class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :title
      t.integer :conditional, default: 0
      t.string :code, unique: true
      t.integer :question_id
      t.integer :conditional_question_id
      t.timestamps
    end
  end
end
