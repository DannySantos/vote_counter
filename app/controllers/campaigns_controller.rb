class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end
  
  def show
    @campaign = Campaign.find(params[:id])
    @uncounted_votes = @campaign.votes.pre + @campaign.votes.post
  end
end