Feature:Manage Log Books

Scenario: A user can access LogBooks that they own
  Given a LogBook exists called "Test log book" for game "Skyrim" and owned by "fooman"
  Then "fooman" should own "1" LogBooks
  
  Given a WorldObject exists called "Nowhere" in section "Locations" of "Test log book"
  And I am signed in with "facebook"
  
  Then debug
  
  Then I should see "Test log book"
  And I should see "Skyrim"
  And I should see "No. of Items"
  And I should see "0"
  When I follow "Test log book"
  Then I should see "Nowhere"