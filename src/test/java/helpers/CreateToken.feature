Feature: Create Token

Background: 
    * configure ssl = true

Scenario: Create Token
    Given url apiURL
    Given path 'users/login'
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method Post
    Then status 200
    * def authToken = response.user.token