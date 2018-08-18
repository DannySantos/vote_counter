Given("there are some campaigns") do
  @campaign_names = []
  
  Random.rand(1..5).times do
    @campaign_names << Faker::LordOfTheRings.location
  end
  
  @campaign_names.each do |campaign_name|
    Campaign.create!(name: campaign_name)
  end
end

Given("there are some candidates") do
  @candidate_names = []
  
  Random.rand(1..5).times do
    @candidate_names << Faker::LordOfTheRings.character
  end
  
  @candidate_names.each do |candidate_name|
    Candidate.create!(name: candidate_name)
  end
end

Given("there are some votes") do
  @campaigns = Campaign.all
  @candidates = Candidate.all
  
  Random.rand(10..30).times do
    Vote.create!(
      campaign: @campaigns.sample,
      candidate: @candidates.sample,
      validity: "during"
    )
  end
end

Given("there are some votes that were not counted") do
  validity_options = ["pre", "post"]
  @number_of_uncounted_votes = Random.rand(3..8)
  
  @campaigns.each do |campaign|
    @number_of_uncounted_votes.times do
      Vote.create!(
        campaign: campaign,
        candidate: @candidates.sample,
        validity: validity_options.sample
      )
    end
  end
end

When("they visit the campaigns page") do
  visit campaigns_path
end

When("click on a campaign link") do
  @chosen_campaign = Campaign.find_by(name: @campaign_names.sample)
  click_link @chosen_campaign.name
end

Then("they should see the campaign details") do
  @chosen_campaign.candidates.each do |candidate|
    expect(page).to have_content(candidate.name)
  end
  
  expect(page).to have_content("Uncounted votes: #{@number_of_uncounted_votes.to_s}")
end

Then("they should see the campaigns") do
  @campaign_names.each do |campaign_name|
    expect(page).to have_content(campaign_name)
  end
end