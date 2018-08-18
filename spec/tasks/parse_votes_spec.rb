require "rails_helper"
require "rake"
VoteCounter::Application.load_tasks

describe "parsing votes task" do
  it "should save well-formed lines to the database" do
    Rake::Task['parse_votes'].invoke('spec/votes_test.txt')
    expect(Campaign.all.count).to eq(2)
    expect(Candidate.all.count).to eq(4)
    expect(Vote.all.count).to eq(7)
  end
end

