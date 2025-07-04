       identification division.
       program-id. enhanced-template.

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

       01  the-var           pic x(100).
       01  what-we-change    pic x(100).
       01  replacement-value pic x(500).

       01 counter    PIC 9(4).

       01 layout-data.
           03 layout-name     pic x(100).
           03 content-block   pic x(2000).
           03 has-layout      pic x(1) value "N".

       linkage section.

       01 the-vars.
           03  COW-vars OCCURS 99 times.
               05 COW-varname       pic x(99).
               05 COW-varvalue      pic x(99).
               05 COW-var-type      pic x(1).

       01 template-filename     pic x(255).

       procedure division using the-vars template-filename.

       *> Initialize template processing
       perform initialize-template.

       *> Process the template
       perform process-template.

       goback.

       initialize-template section.
           move spaces to layout-name.
           move spaces to content-block.
           move "N" to has-layout.

       process-template section.
           move function concatenate("views/", function trim(template-filename))
               to readfile-name.

           open input readfile.
           call 'checkfilestatus' using readfile-name readfile-status.

           read readfile.

           perform until readfile-status = '10'
               move function trim(readline) to templine
               
               *> Check for layout directive
               if templine(1:8) = "{{layout"
                   perform handle-layout-directive
               else
                   *> Process regular line
                   perform process-line
               end-if

               read readfile
           end-perform.

           close readfile.

           *> If we have a layout, render it
           if has-layout = "Y"
               perform render-layout
           end-if.

       handle-layout-directive section.
           *> Extract layout name from {{layout "layout-name"}}
           move templine to processed-line.
           move "Y" to has-layout.
           move "default" to layout-name.

       process-line section.
           move templine to processed-line.

           *> Process variable substitutions
           perform varying counter from 1 by 1 until counter > 99
               if COW-varname(counter) not = spaces
                   move function concatenate(
                       '{{' function trim(COW-varname(counter)) '}}'
                   ) to what-we-change.

                   move COW-varvalue(counter) to replacement-value.

                   move function SUBSTITUTE(
                       processed-line,
                       function trim(what-we-change),
                       function trim(replacement-value)
                   ) to processed-line.
               end-if
           end-perform.

           *> If we have a layout, collect content
           if has-layout = "Y"
               string content-block delimited by size
                      processed-line delimited by size
                      x'0a' delimited by size
                      into content-block
           else
               display function trim(processed-line)
           end-if.

       render-layout section.
           *> Load and render the layout template
           move function concatenate("views/layouts/", function trim(layout-name), ".cow")
               to readfile-name.

           open input readfile.
           call 'checkfilestatus' using readfile-name readfile-status.

           read readfile.

           perform until readfile-status = '10'
               move function trim(readline) to templine
               
               *> Replace {{content}} with collected content
               move function SUBSTITUTE(
                   templine,
                   "{{content}}",
                   function trim(content-block)
               ) to templine.

               *> Process other variables
               perform varying counter from 1 by 1 until counter > 99
                   if COW-varname(counter) not = spaces
                       move function concatenate(
                           '{{' function trim(COW-varname(counter)) '}}'
                       ) to what-we-change.

                       move function SUBSTITUTE(
                           templine,
                           function trim(what-we-change),
                           function trim(COW-varvalue(counter))
                       ) to templine.
                   end-if
               end-perform.

               display function trim(templine)
               read readfile
           end-perform.

           close readfile.

       end program enhanced-template.
