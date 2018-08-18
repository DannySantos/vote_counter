@159851285
@159851290
Feature: Campaigns

Scenario: A visitor views a list of campaigns
  Given there are some campaigns
  When they visit the campaigns page
  Then they should see the campaigns
  
@wip
Scenario: A visitor views a campaign
  Given there are some campaigns
    And there are some candidates
    And there are some votes
    And there are some votes that were not counted
  When they visit the campaigns page
    And click on a campaign link
  Then they should see the campaign details
