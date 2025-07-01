       identification division.
       program-id. showform.

       data division.
       working-storage section.

       01 the-vars.
          03  COW-vars OCCURS 99 times.
            05 COW-varname       pic x(99).
            05 COW-varvalue      pic x(99).    

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
           call 'cowtemplate' using the-vars "form.cow".
           goback.
       end program showform. 