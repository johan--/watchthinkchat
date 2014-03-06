ActiveAdmin.register LogEntry do
  member_action :blacklist, :method => :put do
    log_entry = LogEntry.find(params[:id])
    Blacklist.where(:ip => log_entry.ip).first_or_create
    redirect_to admin_log_entries_path
  end

  index do
    selectable_column
    column :id
    column :ip
    column :host
    column :controller
    column :action
    column :path
    column :blocked
    column :created_at
    actions defaults: false do |log_entry|
      #link_to "Blacklist", blacklist_admin_log_entry(log_entry)
      link_to "Blacklist", "/admin/log_entries/#{log_entry.id}/blacklist", :method => :put, data: { confirm: "Are you sure?" }
    end
  end
end
