       identification division.
       program-id. content-types.

       environment division.

       data division.

       working-storage section.
       01 content-type-definitions.
           03 content-type-count pic 99 usage comp-5 value 0.
           03 content-types occurs 20 times.
               05 type-name        pic x(50).
               05 type-label       pic x(100).
               05 field-count      pic 99 usage comp-5.
               05 fields occurs 20 times.
                   10 field-name   pic x(50).
                   10 field-label  pic x(100).
                   10 field-type   pic x(20).
                   10 field-required pic x(1).
                   10 field-default pic x(255).

       01 current-type-index pic 99 usage comp-5.
       01 current-field-index pic 99 usage comp-5.

       procedure division.

       *> Initialize default content types
       perform initialize-content-types.

       goback.

       initialize-content-types section.
           *> Blog Post Content Type
           add 1 to content-type-count.
           move content-type-count to current-type-index.
           move "blog_post" to type-name(current-type-index).
           move "Blog Post" to type-label(current-type-index).
           move 6 to field-count(current-type-index).

           move 1 to current-field-index.
           move "title" to field-name(current-type-index, current-field-index).
           move "Title" to field-label(current-type-index, current-field-index).
           move "text" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "content" to field-name(current-type-index, current-field-index).
           move "Content" to field-label(current-type-index, current-field-index).
           move "textarea" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "excerpt" to field-name(current-type-index, current-field-index).
           move "Excerpt" to field-label(current-type-index, current-field-index).
           move "textarea" to field-type(current-type-index, current-field-index).
           move "N" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "author" to field-name(current-type-index, current-field-index).
           move "Author" to field-label(current-type-index, current-field-index).
           move "text" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "publish_date" to field-name(current-type-index, current-field-index).
           move "Publish Date" to field-label(current-type-index, current-field-index).
           move "date" to field-type(current-type-index, current-field-index).
           move "N" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "status" to field-name(current-type-index, current-field-index).
           move "Status" to field-label(current-type-index, current-field-index).
           move "select" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           *> Page Content Type
           add 1 to content-type-count.
           move content-type-count to current-type-index.
           move "page" to type-name(current-type-index).
           move "Page" to type-label(current-type-index).
           move 4 to field-count(current-type-index).

           move 1 to current-field-index.
           move "title" to field-name(current-type-index, current-field-index).
           move "Title" to field-label(current-type-index, current-field-index).
           move "text" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "content" to field-name(current-type-index, current-field-index).
           move "Content" to field-label(current-type-index, current-field-index).
           move "textarea" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "slug" to field-name(current-type-index, current-field-index).
           move "URL Slug" to field-label(current-type-index, current-field-index).
           move "text" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "status" to field-name(current-type-index, current-field-index).
           move "Status" to field-label(current-type-index, current-field-index).
           move "select" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           *> User Content Type
           add 1 to content-type-count.
           move content-type-count to current-type-index.
           move "user" to type-name(current-type-index).
           move "User" to type-label(current-type-index).
           move 5 to field-count(current-type-index).

           move 1 to current-field-index.
           move "username" to field-name(current-type-index, current-field-index).
           move "Username" to field-label(current-type-index, current-field-index).
           move "text" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "email" to field-name(current-type-index, current-field-index).
           move "Email" to field-label(current-type-index, current-field-index).
           move "email" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "password" to field-name(current-type-index, current-field-index).
           move "Password" to field-label(current-type-index, current-field-index).
           move "password" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "role" to field-name(current-type-index, current-field-index).
           move "Role" to field-label(current-type-index, current-field-index).
           move "select" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

           add 1 to current-field-index.
           move "status" to field-name(current-type-index, current-field-index).
           move "Status" to field-label(current-type-index, current-field-index).
           move "select" to field-type(current-type-index, current-field-index).
           move "Y" to field-required(current-type-index, current-field-index).

       end program content-types. 