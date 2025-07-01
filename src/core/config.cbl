move 8 to nroutes.

*> Default route (GET /)
move "/"                           to routing-pattern(1).
move "GET"                         to routing-method(1).
move "indexweb"                    to routing-destiny(1).

*> GET /showsum/%value1/%value2
move "/showsum/%value1/%value2"    to routing-pattern(2).
move "GET"                         to routing-method(2).
move "showsum"                     to routing-destiny(2).

*> GET /showname/%value
move "/showname/%value"            to routing-pattern(3).
move "GET"                         to routing-method(3).
move "showname"                    to routing-destiny(3).

*> GET /form - Display the form
move "/form"                       to routing-pattern(4).
move "GET"                         to routing-method(4).
move "showform"                    to routing-destiny(4).

*> POST /submit-form example
move "/submit-form"                to routing-pattern(5).
move "POST"                        to routing-method(5).
move "submitform"                  to routing-destiny(5).

*> PUT /update/%id example
move "/update/%id"                 to routing-pattern(6).
move "PUT"                         to routing-method(6).
move "updateitem"                  to routing-destiny(6).

*> DELETE /delete/%id example
move "/delete/%id"                 to routing-pattern(7).
move "DELETE"                      to routing-method(7).
move "deleteitem"                  to routing-destiny(7).

*> GET /advanced - Advanced template example
move "/advanced"                   to routing-pattern(8).
move "GET"                         to routing-method(8).
move "advanced"                    to routing-destiny(8).
