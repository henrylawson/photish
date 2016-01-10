Feature: Photish
  In order to generate a basic image gallery
  As a CLI
  I want to run a single command to create a static site

  @smoke
  Scenario: Generates the basic site and runs it
    Given the default aruba exit timeout is 90 seconds

    When I run `photish --version`
    Then the output should contain "Photish v"

    When I run `photish credits`
    Then the output should contain "Henry"

    When I run `photish init`
    Then the output should contain "Photish site initiated successfully"
    And the exit status should be 0
    And the config file should be created
    And a photos directory should be created
    And a site directory should be created

    When I change the config to use workers, threads and a plugin Gem
    And I run `photish generate`
    Then the output should contain "Generating with 2 workers and 1 threads"
    Then the output should contain "Photish::Plugin::Sshdeploy::Deploy"
    Then the output should contain "Site generation completed"
    And the exit status should be 0

    When I run `photish host --force` interactively
    Then the site should be available via HTTP
    And the welcome page should appear

    When I send the signal "INT" to the command started last
    Then the output should contain "Photish host has shutdown"
    And the exit status should be 0

  Scenario: Generates an example site and runs it
    Given the default aruba exit timeout is 60 seconds

    When I run `photish init --example`
    Then the output should contain "Photish site initiated successfully"
    And the exit status should be 0
    And the config file should be created
    And a photos directory should be created
    And a site directory should be created

    When I run `photish generate --force`
    Then the output should contain "Site generation completed"
    And the exit status should be 0

    When I run `photish host` interactively
    Then the site should be available via HTTP
    And all 27 pages and images should be available

    When I add an album of photos
    Then the album should appear

    When I remove an album of photos
    Then the album should be gone
    And the album generated files should be gone

    When I edit a template
    Then the change should appear in the template
    And all 27 pages and images should be available

    When I change the config and a file in the site dir
    Then the config changes should reflect
    And all 33 pages and images should be available

    When I send the signal "INT" to the command started last
    Then the output should contain "Photish host has shutdown"
    And the exit status should be 0

    When I run `photish deploy --engine tmpdir`
    Then the output should contain "Deployment to tmpdir successful"
    And the exit status should be 0
