
Feature: Sign Up New User

Background: 
    * configure ssl = true
    Given url apiURL
    * def dataGenerator = Java.type('helpers.DataGenerator');
    * def randomEmail = dataGenerator.getRandomEmail();
    * def randomUsername = dataGenerator.getRandomUsername();

Scenario: New User Sign Up    
    Given path 'users'
    And request
    """
        {
            "user": {
                "email": #(randomEmail),
                "password":"Password123",
                "username": #(randomUsername)
            }
        }
    """
    When method Post
    Then status 200
    And match response ==
    """
        {
	        "user": {
		        "email": #(randomEmail),
		        "username": #(randomUsername),
		        "bio": null,
		        "image": "#string",
		        "token": "#string"
	        }
        }
    """


Scenario Outline: Validate SignUp error messages - Data Driven
    Given path 'users'
    And request
    """
        {
            "user": {
                "email": <email>,
                "password":<password>,
                "username": <username>
            }
        }
    """
    When method Post
    Then status 422
    And match response == <errorResponse>

    Examples:
    |email              |password   |username           |errorResponse                                      |
    |#(randomEmail)     |Password123|schudoji           |{"errors":{"username":["has already been taken"]}} |
    |schudoji@test.com  |Password123|#(randomUsername)  |{"errors":{"email":["has already been taken"]}}    |
    |                   |Password123|#(randomUsername)  |{"errors":{"email":["can't be blank"]}}            |
    |schudoji@test.com  |           |#(randomUsername)  |{"errors":{"password":["can't be blank"]}}         |
    |schudoji@test.com  |Password123|   ""              |{"errors":{"username":["can't be blank"]}}         |