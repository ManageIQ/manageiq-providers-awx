describe ManageIQ::Providers::Awx::AutomationManager do
  it_behaves_like 'awx automation_manager'

  describe '#catalog_types' do
    let(:ems) { FactoryBot.create(:automation_manager_awx) }

    it "#catalog_types" do
      expect(ems.catalog_types).to eq({"awx" => "AWX", "generic_awx" => "AWX (deprecated)"})
    end
  end

  context "#pause!" do
    let(:zone) { FactoryBot.create(:zone) }
    let(:ems)  { FactoryBot.create(:automation_manager_awx, :zone => zone) }

    include_examples "ExtManagementSystem#pause!"
  end

  context "#resume!" do
    let(:zone) { FactoryBot.create(:zone) }
    let(:ems)  { FactoryBot.create(:automation_manager_awx, :zone => zone) }

    include_examples "ExtManagementSystem#resume!"
  end

  describe ".create_from_params" do
    it "delegates endpoints, zone, name to provider" do
      params = {:zone => FactoryBot.create(:zone), :name => "AWX"}
      endpoints = [{"role" => "default", "url" => "https://awx", "verify_ssl" => 0}]
      authentications = [{"authtype" => "default", "userid" => "admin", "password" => "smartvm"}]

      automation_manager = described_class.create_from_params(params, endpoints, authentications)

      expect(automation_manager.provider.name).to eq("AWX")
      expect(automation_manager.provider.endpoints.count).to eq(1)
    end

    it "validates url includes scheme" do
      params = {:zone => FactoryBot.create(:zone), :name => "AWX"}
      endpoints = [{"role" => "default", "url" => "awx_missing_scheme:443", "verify_ssl" => 0}]
      authentications = [{"authtype" => "default", "userid" => "admin", "password" => "smartvm"}]

      expect { described_class.create_from_params(params, endpoints, authentications) }
        .to raise_error(ActiveRecord::RecordInvalid, /Validation failed: ManageIQ::Providers::Awx::Provider: Url has to be a valid URL/)
    end
  end

  describe "#edit_with_params" do
    let(:automation_manager) do
      FactoryBot.build(:automation_manager_awx, :name => "AWX", :url => "https://localhost")
    end

    it "updates the provider" do
      params = {:zone => FactoryBot.create(:zone), :name => "AWX 2"}
      endpoints = [{"role" => "default", "url" => "https://awx", "verify_ssl" => 0}]
      authentications = [{"authtype" => "default", "userid" => "admin", "password" => "smartvm"}]

      provider = automation_manager.provider
      expect(provider.name).to eq("AWX")
      expect(provider.url).to  eq("https://localhost")

      automation_manager.edit_with_params(params, endpoints, authentications)

      provider.reload
      expect(provider.name).to eq("AWX 2")
      expect(provider.url).to eq("https://awx")
    end

    it "validates the url on update" do
      params = {:zone => FactoryBot.create(:zone), :name => "AWX 2"}
      endpoints = [{"role" => "default", "url" => "awx", "verify_ssl" => 0}]
      authentications = [{"authtype" => "default", "userid" => "admin", "password" => "smartvm"}]

      expect { automation_manager.edit_with_params(params, endpoints, authentications) }
        .to raise_error(ActiveRecord::RecordInvalid, /Validation failed: ManageIQ::Providers::Awx::Provider: Url has to be a valid URL/)
    end
  end
end
