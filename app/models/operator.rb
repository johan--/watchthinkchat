class Operator < User
  def as_json(options = {})
    { uid: self.operator_uid, name: self.fullname, profile_pic: self.profile_pic }
  end
end
