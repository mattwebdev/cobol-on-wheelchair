       identification division.
       program-id. auth.

       environment division.

       data division.

       working-storage section.
       01 user-session.
           03 session-id        pic x(32).
           03 user-id           pic 9(10).
           03 username          pic x(50).
           03 user-role         pic x(20).
           03 session-valid     pic x(1) value "N".
           03 session-expires   pic x(20).

       01 user-database.
           03 user-count        pic 99 usage comp-5 value 0.
           03 users occurs 100 times.
               05 user-id       pic 9(10).
               05 username      pic x(50).
               05 email         pic x(100).
               05 password-hash pic x(64).
               05 role          pic x(20).
               05 status        pic x(10).
               05 created-date  pic x(20).

       01 current-user-index   pic 99 usage comp-5.
       01 temp-password        pic x(50).
       01 temp-hash            pic x(64).

       linkage section.
       01 auth-request.
           03 action           pic x(20).
           03 username         pic x(50).
           03 password         pic x(50).
           03 email            pic x(100).
           03 role             pic x(20).

       01 auth-response.
           03 success          pic x(1).
           03 message          pic x(200).
           03 user-data.
               05 user-id      pic 9(10).
               05 username     pic x(50).
               05 email        pic x(100).
               05 role         pic x(20).

       procedure division using auth-request auth-response.

       *> Initialize default users
       perform initialize-users.

       *> Handle authentication action
       evaluate action
           when "login"
               perform handle-login
           when "register"
               perform handle-register
           when "logout"
               perform handle-logout
           when "check"
               perform check-session
           when other
               move "N" to success
               move "Invalid action" to message
       end-evaluate.

       goback.

       initialize-users section.
           *> Create default admin user
           add 1 to user-count.
           move user-count to current-user-index.
           move 1 to user-id(current-user-index).
           move "admin" to username(current-user-index).
           move "admin@nodebol-cms.com" to email(current-user-index).
           move "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8" to password-hash(current-user-index).
           move "admin" to role(current-user-index).
           move "active" to status(current-user-index).
           move "2024-01-01 00:00:00" to created-date(current-user-index).

           *> Create default editor user
           add 1 to user-count.
           move user-count to current-user-index.
           move 2 to user-id(current-user-index).
           move "editor" to username(current-user-index).
           move "editor@nodebol-cms.com" to email(current-user-index).
           move "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8" to password-hash(current-user-index).
           move "editor" to role(current-user-index).
           move "active" to status(current-user-index).
           move "2024-01-01 00:00:00" to created-date(current-user-index).

       handle-login section.
           move "N" to success.
           perform varying current-user-index from 1 by 1
               until current-user-index > user-count

               if username(current-user-index) = username of auth-request
                   if status(current-user-index) = "active"
                       *> Simple password check (in production, use proper hashing)
                       if password-hash(current-user-index) = password of auth-request
                           move "Y" to success
                           move "Login successful" to message
                           move user-id(current-user-index) to user-id of user-data
                           move username(current-user-index) to username of user-data
                           move email(current-user-index) to email of user-data
                           move role(current-user-index) to role of user-data
                           
                           *> Create session
                           perform create-session
                           exit perform
                       end-if
                   end-if
               end-if
           end-perform.

           if success = "N"
               move "Invalid username or password" to message
           end-if.

       handle-register section.
           move "N" to success.
           
           *> Check if username already exists
           perform varying current-user-index from 1 by 1
               until current-user-index > user-count
               if username(current-user-index) = username of auth-request
                   move "Username already exists" to message
                   exit perform
               end-if
           end-perform.

           if current-user-index > user-count
               *> Create new user
               add 1 to user-count.
               move user-count to current-user-index.
               move user-count to user-id(current-user-index).
               move username of auth-request to username(current-user-index).
               move email of auth-request to email(current-user-index).
               move password of auth-request to password-hash(current-user-index).
               move role of auth-request to role(current-user-index).
               move "active" to status(current-user-index).
               move "2024-01-01 00:00:00" to created-date(current-user-index).

               move "Y" to success.
               move "User registered successfully" to message.
               move user-id(current-user-index) to user-id of user-data.
               move username(current-user-index) to username of user-data.
               move email(current-user-index) to email of user-data.
               move role(current-user-index) to role of user-data.
           end-if.

       handle-logout section.
           move "N" to session-valid.
           move "Y" to success.
           move "Logged out successfully" to message.

       check-session section.
           if session-valid = "Y"
               move "Y" to success
               move "Session valid" to message
               move user-id to user-id of user-data
               move username to username of user-data
               move user-role to role of user-data
           else
               move "N" to success
               move "Invalid session" to message
           end-if.

       create-session section.
           move "Y" to session-valid.
           move user-id(current-user-index) to user-id.
           move username(current-user-index) to username.
           move role(current-user-index) to user-role.
           move "2024-12-31 23:59:59" to session-expires.

       end program auth. 