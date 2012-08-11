require 'test/unit'
require 'deliver_sms'

class ConfigurationTest < Test::Unit::TestCase
  def test_default_values
    c = DeliverSms::Configuration.new
    assert_equal 'smsserver.pixie.se', c.pixie_host
    assert_nil c.pixie_account
    assert_nil c.pixie_password
  end
  
  def test_loading_configuration_from_yml
    c = DeliverSms::Configuration.new
    c.load_yml 'test/files/pixie-1.yml', 'env1'
    assert_equal 'dore.mi', c.pixie_host
    assert_equal 'foo', c.pixie_account
    assert_equal 'secret123', c.pixie_password
  end

  def test_validation
    c = DeliverSms::Configuration.new
    assert_raise RuntimeError do c.validate end
    c.pixie_account = 'foo'
    assert_raise RuntimeError do c.validate end
    c.pixie_password = 'secret'
    assert_nothing_raised do c.validate end
  end
end
