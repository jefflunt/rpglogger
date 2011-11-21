Feature:Login

Scenario: A user can login via facebook and sees the welcome
  Given I am signed in with "facebook"
  Then I should see "Logout"
  And I should see "Signed in."
  
Scenario: When a user logs out they see a goobye message
  Given I am signed in with "facebook"
  Then I should see "Logout"

  When I sign out
  Then I should see "Signed out."