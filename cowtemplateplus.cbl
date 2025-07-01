       identification division.
       program-id. cowtemplateplus.

       environment division.
       input-output section.
       file-control.
           select readfile
               assign to readfile-name
               file status is readfile-status
               organization is line sequential.

       data division.
       file section.
       fd  readfile.
       01  readline pic x(1024).

       working-storage section.
       01  readfile-name pic x(255).
       01  readfile-status pic x(2).
       01  templine pic x(1024).
       01  processed-line pic x(1024).
       01  the-var pic x(100).
       01  what-we-change pic x(100).
       01  counter pic 9(4).
       01  nested-level pic 9(2) value 0.
       01  in-conditional pic x(1) value "N".
       01  in-loop pic x(1) value "N".
       01  condition-true pic x(1) value "N".
       01  skip-line pic x(1) value "N".
       
       *> HTML escaping
       01  char-idx pic 9(4).
       01  escaped-value pic x(1024).
       01  current-char pic x(1).

       *> Loop handling
       01  loop-vars.
           05 loop-table occurs 10 times.
              10 loop-var-name pic x(99).
              10 loop-current-idx pic 9(4).
              10 loop-start-idx pic 9(4).
              10 loop-end-idx pic 9(4).

       linkage section.
       01 the-vars.
          03  COW-vars occurs 99 times.
            05 COW-varname pic x(99).
            05 COW-varvalue pic x(99).
            05 COW-var-type pic x(1).
               88 is-array value "A".
               88 is-scalar value "S".
            05 COW-array-size pic 9(4).

       01 template-filename pic x(255).

       procedure division using the-vars template-filename.
       main-section.
           move function concatenate(
               "views/",
               function trim(template-filename)
           ) to readfile-name

           perform process-template
           goback.

       process-template.
           open input readfile
           call 'checkfilestatus' using readfile-name readfile-status
           read readfile

           perform until readfile-status = '10'
               move function trim(readline) to templine
               move "N" to skip-line

               *> Check for control structures
               if templine(1:6) = "{{#if "
                   perform process-if
               else if templine(1:9) = "{{#each "
                   perform process-each
               else if templine(1:7) = "{{/if}}"
                   subtract 1 from nested-level
                   move "N" to in-conditional
               else if templine(1:8) = "{{/each}}"
                   subtract 1 from nested-level
                   move "N" to in-loop
                   perform end-loop
               else
                   if skip-line = "N"
                       perform process-line
                   end-if
               end-if

               read readfile
           end-perform

           close readfile.

       process-if.
           add 1 to nested-level
           move "Y" to in-conditional
           *> Extract condition variable
           move templine(6:) to the-var
           perform until the-var(counter:2) = "}}"
               add 1 to counter
           end-perform
           move the-var(1:counter) to what-we-change
           
           *> Evaluate condition
           perform check-condition
           if condition-true = "N"
               move "Y" to skip-line
           end-if.

       process-each.
           add 1 to nested-level
           move "Y" to in-loop
           *> Setup loop variables
           perform setup-loop
           if loop-current-idx > loop-end-idx
               move "Y" to skip-line
           end-if.

       process-line.
           move templine to processed-line
           perform varying counter from 1 by 1 until counter > 99
               if COW-var-type(counter) = "S"
                   move function concatenate(
                       '{{' function trim(COW-varname(counter)) '}}'
                   ) to what-we-change
                   
                   *> Escape HTML special characters
                   perform escape-html-value
                   
                   move function substitute(
                       processed-line,
                       function trim(what-we-change),
                       function trim(escaped-value)
                   ) to processed-line
               end-if
           end-perform
           
           display function trim(processed-line).

       escape-html-value.
           move spaces to escaped-value
           move 1 to char-idx
           
           perform varying counter from 1 by 1 
               until counter > function length(COW-varvalue(counter))
               
               move COW-varvalue(counter)(counter:1) to current-char
               evaluate current-char
                   when "<"
                       move "&lt;" to escaped-value(char-idx:4)
                       add 4 to char-idx
                   when ">"
                       move "&gt;" to escaped-value(char-idx:4)
                       add 4 to char-idx
                   when "&"
                       move "&amp;" to escaped-value(char-idx:5)
                       add 5 to char-idx
                   when """"
                       move "&quot;" to escaped-value(char-idx:6)
                       add 6 to char-idx
                   when "'"
                       move "&#39;" to escaped-value(char-idx:5)
                       add 5 to char-idx
                   when other
                       move current-char to escaped-value(char-idx:1)
                       add 1 to char-idx
               end-evaluate
           end-perform.

       check-condition.
           move "N" to condition-true
           perform varying counter from 1 by 1 until counter > 99
               if COW-varname(counter) = what-we-change
                   if COW-varvalue(counter) not = spaces and
                      COW-varvalue(counter) not = "0" and
                      COW-varvalue(counter) not = "false"
                       move "Y" to condition-true
                   end-if
               end-if
           end-perform.

       setup-loop.
           *> Initialize loop variables for array iteration
           perform varying counter from 1 by 1 until counter > 99
               if COW-var-type(counter) = "A"
                   move COW-varname(counter) to loop-var-name(nested-level)
                   move 1 to loop-current-idx(nested-level)
                   move 1 to loop-start-idx(nested-level)
                   move COW-array-size(counter) to loop-end-idx(nested-level)
               end-if
           end-perform.

       end-loop.
           add 1 to loop-current-idx(nested-level)
           if loop-current-idx(nested-level) <= loop-end-idx(nested-level)
               *> Continue loop
               subtract 1 from nested-level
           end-if.

       end program cowtemplateplus. 