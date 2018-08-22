class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end
  
  def show
    @campaign = Campaign.find(params[:id])
    @candidates = @campaign.candidates.uniq
    @candidates_and_scores = {}
    
    @candidates.each do |candidate|
      @candidates_and_scores[candidate.name] = candidate.votes.where(campaign_id: @campaign.id, candidate_id: candidate.id).during.count
    end
    
    @candidates_and_scores = Hash[@candidates_and_scores.sort_by{|k,v| v}.reverse]
    @uncounted_votes = @campaign.votes.pre + @campaign.votes.post
  end
end
