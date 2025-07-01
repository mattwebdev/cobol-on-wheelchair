       identification division.
       program-id. login.

       environment division.

       data division.

       working-storage section.
       01 the-vars.
           03 COW-vars occurs 99 times.
               05 COW-varname    pic x(99).
               05 COW-varvalue   pic x(99).
               05 COW-var-type   pic x(1).

       01 auth-data.
           03 auth-request.
               05 action         pic x(20).
               05 username       pic x(50).
               05 password       pic x(50).
               05 email          pic x(100).
               05 role           pic x(20).
           03 auth-response.
               05 success        pic x(1).
               05 message        pic x(200).
               05 user-data.
                   10 user-id    pic 9(10).
                   10 username   pic x(50).
                   10 email      pic x(100).
                   10 role       pic x(20).

       01 counter pic 99 usage comp-5.

       linkage section.
       01 path-values.
           03 path-query-value occurs 10 times pic x(99).
       01 http-request-data.
           05 method pic x(10).
           05 query-params.
               10 param-count pic 9(4).
               10 params occurs 50 times.
                   15 param-name pic x(100).
                   15 param-value pic x(1024).
           05 body-params.
               10 body-param-count pic 9(4).
               10 body-params occurs 50 times.
                   15 body-param-name pic x(100).
                   15 body-param-value pic x(1024).

       procedure division using path-values http-request-data.

       *> Handle different login actions
       evaluate method
           when "GET"
               perform show-login-form
           when "POST"
               perform handle-login-submit
           when other
               perform show-login-form
       end-evaluate.

       goback.

       show-login-form section.
           *> Set up login form variables
           move 1 to counter.
           move "page_title" to COW-varname(counter).
           move "Login - NodeBOL CMS" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           add 1 to counter.
           move "form_action" to COW-varname(counter).
           move "/login" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           add 1 to counter.
           move "error_message" to COW-varname(counter).
           move "" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           *> Render login form
           call 'enhanced-template' using the-vars "login.cow".

       handle-login-submit section.
           *> Extract login credentials from POST data
           perform extract-login-credentials.

           *> Attempt authentication
           move "login" to action of auth-request.
           move username of auth-request to username of auth-request.
           move password of auth-request to password of auth-request.

           call 'auth' using auth-request auth-response.

           *> Handle authentication result
           if success of auth-response = "Y"
               perform handle-login-success
           else
               perform handle-login-failure
           end-if.

       extract-login-credentials section.
           *> Extract username and password from POST data
           move spaces to username of auth-request.
           move spaces to password of auth-request.

           perform varying counter from 1 by 1 until counter > body-param-count of http-request-data
               if body-param-name(counter) of http-request-data = "username"
                   move body-param-value(counter) of http-request-data to username of auth-request
               end-if
               if body-param-name(counter) of http-request-data = "password"
                   move body-param-value(counter) of http-request-data to password of auth-request
               end-if
           end-perform.

       handle-login-success section.
           *> Set up success variables
           move 1 to counter.
           move "page_title" to COW-varname(counter).
           move "Login Successful" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           add 1 to counter.
           move "username" to COW-varname(counter).
           move username of user-data to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           add 1 to counter.
           move "redirect_url" to COW-varname(counter).
           move "/admin" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           *> Render success page
           call 'enhanced-template' using the-vars "login-success.cow".

       handle-login-failure section.
           *> Set up failure variables
           move 1 to counter.
           move "page_title" to COW-varname(counter).
           move "Login Failed" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           add 1 to counter.
           move "error_message" to COW-varname(counter).
           move message of auth-response to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           add 1 to counter.
           move "form_action" to COW-varname(counter).
           move "/login" to COW-varvalue(counter).
           move "S" to COW-var-type(counter).

           *> Render login form with error
           call 'enhanced-template' using the-vars "login.cow".

       end program login. 