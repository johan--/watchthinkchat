ActiveAdmin.register Chat do
  filter :uid

  show do
    panel "Details" do
      attributes_table_for chat do
        [ :operator, :visitor, :created_at, :updated_at, :campaign, :status, :uid ].each do |column|
          row column
        end
      end
    end
    panel "Transcript" do
      table_for chat.messages do
        column :created_at
        column :name
        column :body
      end
    end
  end
end
