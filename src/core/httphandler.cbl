       identification division.
       program-id. httphandler.

       environment division.
       input-output section.
       file-control.
           select stdin
               assign to keyboard
               organization is line sequential
               file status is stdin-status.

       data division.
       file section.
       fd stdin.
           01 stdin-record pic x(1024).

       working-storage section.
       01 stdin-status pic xx.
       01 content-length pic 9(8).
       01 query-string pic x(1024).
       01 request-method pic x(10).
       01 request-body pic x(4096).
       01 temp-var pic x(1024).
       01 char pic x.
       01 i pic 9(4).
       01 j pic 9(4).
       01 k pic 9(4).
       01 pair-count pic 9(4) value 0.
       01 pair-name pic x(100).
       01 pair-value pic x(1024).
       01 hex-digit pic x.
       01 hex-value pic 99.
       01 decoded-char pic x.

       linkage section.
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

       procedure division using http-request-data.

       main-paragraph.
           perform get-request-method
           perform get-query-string
           if request-method = "POST" or request-method = "PUT" 
               or request-method = "PATCH"
               perform get-request-body
           end-if
           perform process-data
           goback.

       get-request-method.
           accept request-method from environment "REQUEST_METHOD"
           move request-method to method.

       get-query-string.
           accept query-string from environment "QUERY_STRING"
           move 0 to pair-count
           if query-string not = spaces
               perform process-query-string.
           move pair-count to param-count.

       process-query-string.
           move 1 to i
           perform until i > length of query-string
               move spaces to pair-name
               move spaces to pair-value
               move 1 to j
               perform until query-string(i:1) = "=" or i > length of query-string
                   move query-string(i:1) to pair-name(j:1)
                   add 1 to i
                   add 1 to j
               end-perform
               add 1 to i
               move 1 to j
               perform until query-string(i:1) = "&" or i > length of query-string
                   move query-string(i:1) to pair-value(j:1)
                   add 1 to i
                   add 1 to j
               end-perform
               add 1 to i
               add 1 to pair-count
               perform url-decode-value
               move pair-name to param-name(pair-count)
               move pair-value to param-value(pair-count)
           end-perform.

       get-request-body.
           accept temp-var from environment "CONTENT_LENGTH"
           if temp-var is numeric
               move temp-var to content-length
           else
               move 0 to content-length
           end-if
           if content-length > 0
               open input stdin
               move spaces to request-body
               read stdin into request-body
               close stdin
               move 0 to pair-count
               perform process-request-body
               move pair-count to body-param-count
           end-if.

       process-request-body.
           move 1 to i
           perform until i > length of request-body
               move spaces to pair-name
               move spaces to pair-value
               move 1 to j
               perform until request-body(i:1) = "=" or i > length of request-body
                   move request-body(i:1) to pair-name(j:1)
                   add 1 to i
                   add 1 to j
               end-perform
               add 1 to i
               move 1 to j
               perform until request-body(i:1) = "&" 
                   or i > length of request-body
                   move request-body(i:1) to pair-value(j:1)
                   add 1 to i
                   add 1 to j
               end-perform
               add 1 to i
               add 1 to pair-count
               perform url-decode-value
               move pair-name to body-param-name(pair-count)
               move pair-value to body-param-value(pair-count)
           end-perform.

       url-decode-value.
           move spaces to temp-var
           move 1 to j
           move 1 to k
           perform until j > length of pair-value
               if pair-value(j:1) = "+"
                   move space to temp-var(k:1)
               else
                   if pair-value(j:1) = "%"
                       add 1 to j
                       move pair-value(j:1) to hex-digit
                       perform convert-hex
                       compute hex-value = hex-value * 16
                       add 1 to j
                       move pair-value(j:1) to hex-digit
                       perform convert-hex
                       add hex-value to hex-value
                       move hex-value to decoded-char
                       move decoded-char to temp-var(k:1)
                   else
                       move pair-value(j:1) to temp-var(k:1)
                   end-if
               end-if
               add 1 to j
               add 1 to k
           end-perform
           move temp-var to pair-value.

       convert-hex.
           evaluate hex-digit
               when "0" move 0 to hex-value
               when "1" move 1 to hex-value
               when "2" move 2 to hex-value
               when "3" move 3 to hex-value
               when "4" move 4 to hex-value
               when "5" move 5 to hex-value
               when "6" move 6 to hex-value
               when "7" move 7 to hex-value
               when "8" move 8 to hex-value
               when "9" move 9 to hex-value
               when "A" or "a" move 10 to hex-value
               when "B" or "b" move 11 to hex-value
               when "C" or "c" move 12 to hex-value
               when "D" or "d" move 13 to hex-value
               when "E" or "e" move 14 to hex-value
               when "F" or "f" move 15 to hex-value
           end-evaluate.

       end program httphandler. 