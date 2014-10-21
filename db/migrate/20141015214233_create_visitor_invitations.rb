class CreateVisitorInvitations < ActiveRecord::Migration
  def change
    create_table :visitor_invitations do |t|
      t.integer :campaign_id
      t.integer :invitee_id
      t.integer :inviter_id
      t.string :token

      t.timestamps
    end
  end
end
