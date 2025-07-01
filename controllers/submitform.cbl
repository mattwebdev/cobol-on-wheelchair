       identification division.
       program-id. submitform.

       data division.
       working-storage section.

       01 the-vars.
          03  COW-vars OCCURS 99 times.
            05 COW-varname       pic x(99).
            05 COW-varvalue      pic x(99).    

       01 i pic 9(4).

       linkage section.
       01 path-values.
          05 path-query-values           occurs 10 times.
            10 path-query-value-name     pic x(90).
            10 path-query-value          pic x(90).

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

           display "<h2>Form Submission Results</h2>"
           display "<h3>POST Data:</h3>"
           display "<table border='1'>"
           display "<tr><th>Field</th><th>Value</th></tr>"
           
           perform varying i from 1 by 1 until i > body-param-count
               display "<tr>"
               display "<td>" function trim(body-param-name(i)) "</td>"
               display "<td>" function trim(body-param-value(i)) "</td>"
               display "</tr>"
           end-perform
           
           display "</table>"

           display "<h3>Query Parameters:</h3>"
           display "<table border='1'>"
           display "<tr><th>Parameter</th><th>Value</th></tr>"
           
           perform varying i from 1 by 1 until i > param-count
               display "<tr>"
               display "<td>" function trim(param-name(i)) "</td>"
               display "<td>" function trim(param-value(i)) "</td>"
               display "</tr>"
           end-perform
           
           display "</table>"

           goback.
       end program submitform. 