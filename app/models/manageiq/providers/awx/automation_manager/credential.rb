class ManageIQ::Providers::Awx::AutomationManager::Credential < ManageIQ::Providers::ExternalAutomationManager::Authentication
  # Authentication is associated with EMS through resource_id/resource_type
  # Alias is to make the AutomationManager code more uniformly as those
  # CUD operations in the TowerApi concern

  alias_attribute :manager_id, :resource_id
  alias_method :manager,  :resource
  alias_method :manager=, :resource=

  include ManageIQ::Providers::Awx::AutomationManager::TowerApi
  include ProviderObjectMixin

  supports :create
  supports :update
  supports :delete

  def self.provider_collection(manager)
    manager.with_provider_connection do |connection|
      AwxClient::CredentialsApi(connection).credentials_list
    end
  end

  def self.provider_params(params)
    params[:username] = params.delete(:userid) if params.include?(:userid)
    params[:kind] = self::TOWER_KIND
    params
  end

  def self.process_secrets(params, decrypt = false)
    if decrypt
      Vmdb::Settings.decrypt_passwords!(params)
    else
      Vmdb::Settings.encrypt_passwords!(params)
    end
  end

  def self.notify_on_provider_interaction?
    true
  end

  def provider_object(connection = nil)
    (connection || connection_source.connect).api.credentials.find(native_ref)
  end

  def native_ref
    Integer(manager_ref)
  end

  COMMON_ATTRIBUTES = {}.freeze
  EXTRA_ATTRIBUTES = {}.freeze
  API_ATTRIBUTES = COMMON_ATTRIBUTES.merge(EXTRA_ATTRIBUTES).freeze

  FRIENDLY_NAME = 'AWX Credential'.freeze
end
