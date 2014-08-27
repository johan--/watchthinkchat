class AddCodeToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :code, :string
  end
end
