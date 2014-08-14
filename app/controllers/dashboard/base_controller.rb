module Dashboard
  class BaseController < InheritedResources::Base
    layout 'dashboard'
    before_filter :authenticate_by_facebook!

    protected

    def begin_of_association_chain
      current_user
    end
  end
end
