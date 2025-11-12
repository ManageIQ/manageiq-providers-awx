class ManageIQ::Providers::Awx::Inventory::Collector::AutomationManager < ManageIQ::Providers::Inventory::Collector
  def connection
    @connection ||= manager.connect
  end

  def config
    config, _status_code, _headers = AwxClient::ConfigApi.new(connection).config_retrieve_with_http_info(:debug_return_type => "String")
    JSON.parse(config)
  end

  def inventories
    # TODO paging
    AwxClient::InventoriesApi.new(connection).inventories_list.results
  end

  def hosts
    # TODO paging
    AwxClient::HostsApi.new(connection).hosts_list.results
  end

  def job_templates
    AwxClient::JobTemplatesApi.new(connection).job_templates_list.results
  end

  def configuration_workflows
    AwxClient::WorkflowJobTemplatesApi.new(connection).workflow_job_templates_list.results
  end

  def projects
    AwxClient::ProjectsApi.new(connection).projects_list.results
  end

  def project_playbooks(project)
    playbook_names, _status_code, _headers = AwxClient::ProjectsApi.new(connection).projects_playbooks_retrieve_with_http_info(project.id, :debug_return_type => "String")
    JSON.parse(playbook_names)
  end

  def credentials
    AwxClient::CredentialsApi.new(connection).credentials_list.results
  end
end
