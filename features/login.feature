Feature:Login

Scenario: A user can login via facebook
  Given I am signed in with "facebook"
  Then I should see "fooman / Logout"