@159851285
Feature: Campaigns

Scenario: A visitor views a list of campaigns
  Given there are some campaigns
  When they visit the campaigns page
  Then they should see the campaigns
  