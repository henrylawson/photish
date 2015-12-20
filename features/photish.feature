Feature: Photish
  In order to generate a basic image gallery
  As a CLI
  I want to run a single command to create a static site

  Scenario: Generates the basic site and runs it
    When I run `photish init`
    Then the output should contain "Photish site initiated successfully"
    And the exit status should be 0
    And the config file should be created
    And a photos directory should be created
    And a site directory should be created

    When I run `photish host` interactively
    Then the site should be available via HTTP
    And all 1 pages and images should be available
    And the exit status should be 0

  Scenario: Generates an example site and runs it
    Given the default aruba exit timeout is 60 seconds

    When I run `photish init --example`
    Then the output should contain "Photish site initiated successfully"
    And the exit status should be 0
    And the config file should be created
    And a photos directory should be created
    And a site directory should be created

    When I run `photish generate`
    Then the output should contain "Site generation completed successfully"
    And the exit status should be 0

    When I run `photish host` interactively
    Then the site should be available via HTTP
    And all 26 pages and images should be available

    When I add an album of photos
    Then the album should appear

    When I remove an album of photos
    Then the album should be gone
    And the album generated files should be gone

    When I edit a template
    Then I should see the change appear in the template

    And all 26 pages and images should be available

    When I send the signal "INT" to the command started last
    Then the output should contain "Photish host has shutdown"
    And the exit status should be 0

    When I run `photish deploy --engine tmpdir`
    Then the output should contain "Deployment to tmpdir successful"
    And the exit status should be 0
