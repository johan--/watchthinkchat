class CampaignObserver < ActiveRecord::Observer
  def before_validation(campaign)
    validate_domain(campaign)
    add_domain(campaign) if campaign.errors.empty?
  end

  def after_validation(campaign)
    remove_domain(campaign) unless campaign.errors.empty?
  end

  def before_destroy(campaign)
    remove_domain(campaign)
  end

  protected

  def heroku
    @heroku ||= PlatformAPI.connect(ENV['heroku_token'])
  end

  def validate_domain(campaign)
    return unless campaign.url && !campaign.subdomain? && campaign.url_changed?
    return unless domain_exists?(campaign.url)
    campaign.errors.add(:url, 'already exists')
  end

  def add_domain(campaign)
    return unless campaign.url && !campaign.subdomain? && campaign.url_changed?
    remove_domain(campaign)
    begin
      heroku.domain.create(ENV['heroku_name'], hostname: campaign.url)
    rescue Excon::Errors::UnprocessableEntity
      campaign.errors.add(:url, 'already exists')
    end
  end

  def remove_domain(campaign)
    remove_domain_by_url(campaign.url)
  end

  def remove_domain_by_url(url)
    return if url.blank?
    return unless domain_exists?(url)
    heroku.domain.delete(ENV['heroku_name'], url)
  end

  def domain_exists?(url)
    begin
      heroku.domain.info(ENV['heroku_name'], url)
    rescue Excon::Errors::NotFound
      return false
    end
    true
  end
end
