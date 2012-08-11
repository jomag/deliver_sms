
require 'yaml'

module DeliverSms
  class Configuration
    attr_accessor :pixie_host
    attr_accessor :pixie_account
    attr_accessor :pixie_password

    def pixie_host
      @pixie_host || 'smsserver.pixie.se'
    end
    
    def load_yml(path = nil, env = nil)
      path = default_yml_path if path.nil?
      env = default_env if env.nil?
        
      cfg = YAML.load_file path

      self.pixie_host = cfg[env]['pixie_host']
      self.pixie_account = cfg[env]['pixie_account']
      self.pixie_password = cfg[env]['pixie_password']
    end

    def validate
      raise RuntimeError.new "Missing pixie host name" if self.pixie_host.nil?
      raise RuntimeError.new "Missing pixie account name" if self.pixie_account.nil? or self.pixie_account.empty?
      raise RuntimeError.new "Missing pixie password" if self.pixie_password.nil? or self.pixie_password.empty?
    end

    private

    def default_env
      Rails.env
    end

    def default_yml_path
      if Rails.nil? or Rails.root.nil? or Rails.root.empty?
        raise "Missing path"
      else
        "#{Rails.root}/config/deliver_sms.yml"
      end
    end
  end

  class Pixie
    @host = 'smsserver.pixie.se'
    @account = nil
    @password = nil

    def new(cfg)
      @host = cfg.pixie_hostname
      @account = cfg.pixie_account
      @password = cfg.pixie_password
    end

    def path(sms)
      path = "/sendsms?account=#{CGI.escape @account.to_s}&pwd=#{CGI.escape @password.to_s}"
      path << "&receivers=#{CGI.escape fix_phone(sms.recipient)}"
      path << "&sender=#{CGI.escape sms.sender}"
      path << "&message=#{CGI.escape sms.body}"
    end
  end

  def self.deliver()
    config = Configuration.new
    config.load_yml
    config.validate

    load_config unless has_valid_config?
    validate_config
  end

  private

  def validate_config
    raise "Missing hostname" if @PIXIE_HOST.nil? or @PIXIE_HOST.empty?
    raise "Missing account" if @PIXIE_HOST.empty? or @PIXIE_ACCOUNT.empty?
    raise "Missing password" if @PIXIE_PASSWORD.nil? or @PIXIE_PASSWORD.empty?
  end

  def load_config
  end
end
