Feature: Photish
  In order to generate a basic image gallery
  As a CLI
  I want to run a single command to create a static site

  Scenario: Outputs the provided directories using full arg names
    Given a config file
    And a photo directory
    And a site directory with templates
    When I run `photish generate`
    Then the output should contain "Site generation completed successfully"
