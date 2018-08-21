class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end
  
  def show
    @campaign = Campaign.find(params[:id])
    @candidates = @campaign.candidates.uniq
    @votes = {}
    
    @candidates.each do |candidate|
      @votes[candidate.name] = Vote.where(campaign_id: @campaign.id, candidate_id: candidate.id).during.count
    end
    
    @votes = Hash[@votes.sort_by{|k,v| v}.reverse]
    @uncounted_votes = @campaign.votes.pre + @campaign.votes.post
  end
end