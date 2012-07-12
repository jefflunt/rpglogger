Feature: Login

Scenario: A user can login via facebook and sees the welcome message
  Given I am signed in with provider "facebook"
  Then I should see the text "Logout"
  And I should see the text "Signed in."
  
Scenario: When a user logs out they see a goodbye message
  Given I am signed in with provider "facebook"
  Then I should see the text "Logout"

  When I sign out
  Then I should see the text "Signed out."