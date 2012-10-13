Feature: Uploading images and images as a LogBook column type

Background:
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Logbook with images" for game "City image game" and owned by "facebook_user"
  And a Section exists called "All city images" in "Logbook with images"

Scenario: When editing a Section, the image column type should be an option, and you can create a new column of type image
  When I go to the edit Section page for Section "All city images"
  And I fill in "section_properties[new_section_property_names]" with "Image"
  And I select "image" from "[data_type]"
  And I press "Update attributes"
  Then I should see all of the texts:
    | Section updated     |
    | Section Attributes  |
  And I should see an "input" with "value" of "Image"
  
Scenario: A user can upload an image to a WorldObject that they own which contains an image property
  When I go to the new WorldObjects page of Section "All city images"
  Then I should see the text "Image"

  Given I add the file "features/sample_uploads/city-cinemascope.jpg"
  When I fill in the name field with "Picture of my dog"
  And I fill in the file field "some file field"
  And I press "Save"
  Then I should see the text "Updated"
  And there should be an image uploaded to WorldObject "Picture of my dog"
  
