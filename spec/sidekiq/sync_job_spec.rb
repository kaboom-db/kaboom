require "rails_helper"

RSpec.describe SyncJob, type: :job do
  it "syncs trending comics" do
    comic = instance_double(Comic)
    expect(Comic).to receive_message_chain(:trending, :limit).and_return([comic])
    expect(comic).to receive(:sync)
    expect(comic).to receive(:import_issues)
    SyncJob.new.perform
  end
end
