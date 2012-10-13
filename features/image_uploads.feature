Feature: Support for image uploads

Background:
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Logbook with images" for game "City image game" and owned by "facebook_user"
  And a Section exists called "All city images" in "Logbook with images"
  When I create a new SectionProperty called "Image" of data type "image" on section "All city images"

Scenario: A user should be able to create an attribute type of "image"
  Then I should see all of the texts:
    | Section updated     |
    | Section Attributes  |
  And I should see an "input" with "value" of "Image"
  
Scenario: A user can upload an image to a WorldObject
  Then the total number of active SectionProperties should be 1
  When I go to the new WorldObject page of section "All city images"
  And I fill in "world_object[name]" with "My beautiful city"
  And I attach the file "features/sample_uploads/city-cinemascope.jpg" to form field "world_object[world_object_properties_attributes][0][image_value]"
  And I press "Save"
  Then I should see the text "Created"
  And I should see an "img" with "alt" of "Thumb_city-cinemascope"
  
Scenario: File uploads that do not end with .jpg, .jpeg, .gif OR .png are disallowed
  Given pending
  
