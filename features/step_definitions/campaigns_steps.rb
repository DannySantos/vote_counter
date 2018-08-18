Given("there are some campaigns") do
  @campaign_names = []
  
  Random.rand(1..5).times do
    @campaign_names << Faker::LordOfTheRings.location
  end
  
  @campaign_names.each do |campaign_name|
    Campaign.create!(name: campaign_name)
  end
end

When("they visit the campaigns page") do
  visit campaigns_path
end

Then("they should see the campaigns") do
  @campaign_names.each do |campaign_name|
    expect(page).to have_content(campaign_name)
  end
end