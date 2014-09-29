class User
  class DashboardUser < ActiveType::Record[User]
    self.abstract_class = true

    has_many :campaigns,
             through: :permissions,
             source: :resource,
             source_type: 'Campaign'
  end
end
