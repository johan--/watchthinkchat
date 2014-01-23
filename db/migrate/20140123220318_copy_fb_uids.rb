class CopyFbUids < ActiveRecord::Migration
  def change
    User.all.each do |u|
      u.fb_uid = u.fb_uid || u.operator_uid
    end
  end
end
