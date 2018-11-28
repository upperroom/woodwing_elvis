module WoodWing
  class Elvis
    module Rest

      # TODO: Extend session management to support multiple sessions.

      class AlreadyLoggedIn < StandardError; end


      # A successful log in will result in a cookie
      def logged_in?
        not @auth_token.empty?
      end



=begin
      # https://elvis.tenderapp.com/kb/api/rest-login

http://yourserver.com/services/login
    ?cred=<base64 credentials>
    &username=<username>
    &password=<password>
    &nextUrl=<URL for next page>
    &failUrl=<URL for fail page>
    &locale=<language_COUNTRY_variant>
    &timezoneOffset=<timecode>
    &clientType=api_...
    &returnProfile=true

What does it do?

Authenticates your browser session.

All other REST calls require an authenticated session, otherwise they will respond with a "401 Unauthorized" status.

The login service can be used in two flavors:

    Handle an AJAX login request

    Use this if you want maximum control on the client side over what happens. It returns a JSON response with details about the result of your authenticate request. This mechanism is also used by the auto login function of the Elvis JavaScript library.

    Handle form based login

    Forwards to a 'success' or 'failure' URL after the authentication attempt. Use this to build a simple login page, see the following sample at GitHub. You can also tell the JavaScript library to use your login page whenever authentication is required.

Parameters

cred  Base 64 encoded credentials.
        cred=<base64Encode( username + ":" + password )>
      Base64 encoding is not secure. Use https to make login secure.
      Optional. Either cred or username and password must be specified.

username    The username to be used to login. This should match a valid
            username from the LDAP or ActiveDirectory server or from the
            internal Elvis users. Sometimes an LDAP configuration supports
            various usernames for one user.
            Optional. Either cred or username and password must be specified.

password    The password for the user. Since this is passed to the server as
            plain text, use https to make login secure.
            Optional. Either cred or username and password must be specified.

nextUrl     When specified, the service will send a 301 redirect to this URL
            after a successful login.
            Optional. When not specified, a JSON response with login details
            will be returned.

failUrl     When specified, the service will send a 301 redirect to this URL
            if login fails.
            Optional. When not specified, a JSON response with login failure
            details will be returned.

locale      The locale to be used for this user to format locale sensitive
            information like dates and numbers.
            A locale has one of the following formats:
              <language code>
              <language code>_<country code>
            The language argument is a valid ISO Language Code. These codes are
            the lower-case, two-letter codes as defined by ISO-639.  The country
            argument is a valid ISO Country Code. These codes are the upper-case,
            two-letter codes as defined by ISO-3166.
            Examples:
              locale=de
              locale=fr
              locale=nl_BE
            Optional. When not specified, the locale configured on the server
            will be used.

timezoneOffset    The timezone for this user, used to format dates. Must be
                  specified as base timezone offset in milliseconds to GMT. For example:
                    America/Los_Angeles
                    Base GMT offset: -8:00
                    = -28800000 milliseconds
                    timezoneOffset=-28800000
                    Europe/Paris,
                    Base GMT offset: +1:00
                    = 3600000 milliseconds
                    timezoneOffset=3600000
                  Optional. When not specified, the timezone configured on the
                  server will be used. If specified, the locale MUST also be
                  specified, otherwise the timezoneOffset is ignored.

clientType    Custom client type that will be displayed in the usage history of
              the asset. Used to track which interface was used to perform the
              operation. The client type must be prefixed with "api_", for example:
                "api_MyPublicWebsite".
              Optional. When not specified, operations will be tracked without a
              client type.
              Available since Elvis 3.0

returnProfile   Specify 'true' to return profile with login response.
                Optional. When not specified, profile details are not returned.
                Available since Elvis 2.6. In older versions, profile information
                was always returned.


Return value
------------

When nextUrl and failUrl are set, the service will respond with a 302 redirect.
This will change the URL of the browser and navigate to the 'next' URL.

When nextUrl and failUrl are not set, the service returns a JSON response with
the following information:

loginSuccess    true | false
                Indicates if login was successful.

sessionId       The session ID.
                Useful if you are doing cross-domain calls to an Elvis Server,
                since session cookies are not accepted when received through a
                cross-domain AJAX call. You will have to store the sessionId
                yourself and add ;jsessionid=<received id> to the URL of each
                subsequent call made to the Elvis Server. When you use the
                JavaScript library to perform the login, this will be done for
                you automatically.
                Available since Elvis 2.6

serverVersion   The version of the server. This can be used to check if the Elvis
                Server you are connecting to meets your minimum server version
                requirements.
                Available since Elvis 2.6

loginFaultMessage   A message indicating why login failed.
                    Only returned when loginSuccess is false.

userProfile   An object with details about the user.
              Only returned when loginSuccess is true and the returnProfile
              parameter is set to true.

=end

      # FIXME: Need to change Elvis to https otherwise anyone who snoops
      #        the wire will find cred and be able to have complete access once
      #        the white listed IP scheme has been dropped.

      def login(options={})

        raise AlreadyLoggedIn unless @auth_token.empty?

        options = {
          username:   ENV['ELVIS_USER'],
          password:   ENV['ELVIS_PASS']
        }.merge(options)

        options[:clientType]    = 'api_Ruby'

        url       = base_url + "apilogin"
        response  = get_response_using_post(url, options)

        @auth_token = response[:authToken]

        return response

      end # login

      alias :logon  :login
      alias :signin :login

=begin
      # https://elvis.tenderapp.com/kb/api/rest-logout

http://yourserver.com/services/logout

Terminates your browser session. Use this to end a session using an AJAX call.

Available since Elvis 2.6.

Parameters

This service has no parameters

Return value
------------

logoutSuccess   == 'true'   Indicates that logout was successful.

Note: Logging out through AJAX won't work if you are doing cross-domain calls, since session cookies are not accepted when received through a cross-domain AJAX call. Use "logout and redirect" instead, see below.

Logout and redirect

http://yourserver.com/logout
    ?logoutSuccessUrl=<url>

Redirects to a 'success' URL after terminating the session. The URL can be a relative or absolute URL and can even redirect to a different server.

When no logoutSuccessUrl is specified, the user will be redirected to the configured landing page (by default this is the client install page).

Examples

AJAX logout with success

The following shows the response of a successful logout.

http://demo.elvisdam.com/services/logout

    {
      "logoutSuccess" : true
    }

Redirect logout

Ends the session and redirects to www.elvisdam.com.
logout

http://demo.elvisdam.com/logout
    ?logoutSuccessUrl=http%3A%2F%2Fwww.elvisdam.com


=end


      def logout(options={})

        url       = base_url + "logout"
        response  = get_response_using_post(url, options)

        @auth_token  = '' if response[:logoutSuccess]

        return response

      end # logout

      alias :signout :logout
      alias :signoff :logout
      alias :logoff  :logout


    end # module Rest
  end # class Elvis
end # module WoodWing
