Feature:Manage Log Book Elements

Scenario: A user can see and edit LogBooks that they own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test log book" for game "Skyrim" and owned by "fooman"
  And a WorldObject exists called "Nowhere" in section "Locations" of "Test log book"
  When I go to "the log_books index"
  
  Then I should see "Test log book"
  And I should see "Skyrim"
  And I should see "No. of Items"
  And I should see "1"
  
Scenario: A user can see WorldObjects listed in Sections on LogBooks that they owen
  Given I am signed in with "facebook"
  And a LogBook exists called "Test log book" for game "Skyrim" and owned by "fooman"
  And a WorldObject exists called "Nowhere" in section "Locations" of "Test log book"
  When I go to "the log_books index"
  And I follow "Test log book"
  
  Then I should see "Name/Title"
  And I should see "Locations"
  And I should see "Nowhere"
  
Scenario: A user cannot see or edit LogBooks that they do not own
  Given pending
  
Scenario: A user cannot see or edit Sections in LogBooks they do not own
  Given pending
  
Scenario: A user cannot see or edit SectionProperties in Sections they do not own
  Given pending

Scenario: A user cannot see or edit WorldObjects in Sections they do not own
  Given pending

Scenario: A user cannot see or edit WorldObjectsProperties on WorldObjects they do not own
  Given pending
