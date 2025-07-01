       identification division.
       program-id. advanced.

       data division.
       working-storage section.

       01 the-vars.
          03  COW-vars OCCURS 99 times.
            05 COW-varname       pic x(99).
            05 COW-varvalue      pic x(99).
            05 COW-var-type      pic x(1).
            05 COW-array-size    pic 9(4).

       01 var-idx pic 9(2) value 1.
       01 item-idx pic 9(2).

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

      *> Set scalar values
           move "site_name" to COW-varname(var-idx)
           move "COBOL on Wheelchair" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)
           add 1 to var-idx

           move "logged_in" to COW-varname(var-idx)
           move "true" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)
           add 1 to var-idx

           move "username" to COW-varname(var-idx)
           move "John Doe" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)
           add 1 to var-idx

           move "is_admin" to COW-varname(var-idx)
           move "true" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)
           add 1 to var-idx

           move "current_year" to COW-varname(var-idx)
           move "2024" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)
           add 1 to var-idx

           move "company_name" to COW-varname(var-idx)
           move "COBOL Industries" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)
           add 1 to var-idx

      *> Set up items array
           move "items" to COW-varname(var-idx)
           move "A" to COW-var-type(var-idx)
           move 3 to COW-array-size(var-idx)

      *> Item 1
           add 1 to var-idx
           move "items[0].name" to COW-varname(var-idx)
           move "Laptop" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           add 1 to var-idx
           move "items[0].description" to COW-varname(var-idx)
           move "Powerful workstation" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           add 1 to var-idx
           move "items[0].price" to COW-varname(var-idx)
           move "999.99" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

      *> Item 2
           add 1 to var-idx
           move "items[1].name" to COW-varname(var-idx)
           move "Mouse" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           add 1 to var-idx
           move "items[1].description" to COW-varname(var-idx)
           move "Ergonomic design" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           add 1 to var-idx
           move "items[1].price" to COW-varname(var-idx)
           move "49.99" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

      *> Item 3
           add 1 to var-idx
           move "items[2].name" to COW-varname(var-idx)
           move "Keyboard" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           add 1 to var-idx
           move "items[2].description" to COW-varname(var-idx)
           move "Mechanical switches" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           add 1 to var-idx
           move "items[2].price" to COW-varname(var-idx)
           move "129.99" to COW-varvalue(var-idx)
           move "S" to COW-var-type(var-idx)

           call 'cowtemplateplus' using the-vars "advanced.cow"
           goback.
       end program advanced. 