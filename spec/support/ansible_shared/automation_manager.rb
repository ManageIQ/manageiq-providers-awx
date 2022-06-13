shared_examples_for "awx automation_manager" do
  let(:provider) { FactoryBot.build(:provider_awx) }
  let(:awx_automation_manager) { FactoryBot.build(:automation_manager_awx, :provider => provider) }

  describe "#connect" do
    it "delegates to the provider" do
      expect(provider).to receive(:connect)
      awx_automation_manager.connect
    end
  end

  context "#pause!, #resume!" do
    before do
      MiqRegion.seed
      Zone.seed
    end

    it "moves provider to maintenance_zone when paused" do
      provider = FactoryBot.create(:provider_awx, :zone => Zone.default_zone)
      ems = FactoryBot.create(:automation_manager_awx,
                              :provider => provider,
                              :zone     => Zone.default_zone)

      ems.pause!
      provider.reload

      expect(ems.enabled).to eq(false)
      expect(ems.zone).to eq(Zone.maintenance_zone)
      expect(provider.zone).to eq(Zone.maintenance_zone)
    end

    it "moves provider from maintenance_zone when resumed" do
      provider = FactoryBot.create(:provider_awx, :zone => Zone.maintenance_zone)
      ems = FactoryBot.create(:automation_manager_awx,
                              :enabled           => false,
                              :provider          => provider,
                              :zone              => Zone.maintenance_zone,
                              :zone_before_pause => Zone.default_zone)

      ems.resume!
      provider.reload

      expect(ems.enabled).to eq(true)
      expect(ems.zone).to eq(Zone.default_zone)
      expect(provider.zone).to eq(Zone.default_zone)
    end
  end
end
