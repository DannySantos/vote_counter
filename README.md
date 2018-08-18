# Challenge Notes

Despite being such a small task I started by converting the task into a series of stories on Pivotal Tracker. It's easier to tackle things in bitesize chunks and mapping out a piece of work in stages helps to prepare you for it, and gets you thinking about avoidable mistakes.

**Setup**

-   Created a new Rails app, skipping Test and the bundle and setting the database to postgresql. I'll be using RSpec for unit testing and Postgres over SQLite.
-   Added Pry, Cucumber, Database Cleaner, Faker, and RSpec to the Gemfile and bundled.
-   Installed Cucumber and RSpec.
-   Created and migrated the database.
-   Initialized a git repo, added, committed, and saved. As it's just me doing a small task I'll just work from the master branch.

**A visitor views a list of campaigns**

-   Wrote a Cucumber test for viewing a list of campaigns and tagged the Pivotal Tracker story ID.
-   TEST FAIL (note: the test fails/passes were more frequent than they appear in my notes but I grouped them together for readability).
-   Created a Campaign model with a name property and migrated the database: TEST PASS
-   TEST FAIL
-   Added a route, created a controller, added an index controller action, created an index view: TEST PASS
-   TEST FAIL
-   Loaded the campaigns from the database in the controller and rendered them on the index page: TEST PASS
-   Commited changes.

**A visitor views a campaign**

-   Wrote a Cucumber test for viewing a campaign and tagged the Pivotal Tracker story ID.
-   TEST FAIL
-   Created a Candidate model with a name property and migrated: TEST PASS
-   TEST FAIL
-   Created a Vote model as a join table between Campaign and Candidate: TEST PASS
-   I considered having it so that a Campaign has_many candidates and a Candidate has_many votes, but decided instead that it was more extensible to use a join table. I don't have all the facts but it leaves the option for one candidate to be part of many campaigns, for example.
-   TEST FAIL
-   Generated a migration to add validity to Vote as an integer (then set it up as an enum), migrated, added relationships to Campaign and Candidate models: TEST PASS
-   TEST FAIL
-   Turned campaign names into links, added the show route, action, and view: TEST PASS
-   TEST FAIL
-   Rendered camapign candidates, their scores, and uncounted votes on the campaign show page: TEST PASS
-   Committed changes.

**Small refactor**

- Slightly refactored the candidates code for performance.

**A developer runs a vote parsing script**

With this I started with a little strategising. Because we're thinking about scalability with this app I want to be careful about slurping a whole file into memory, so for starters I'll use a sequential method like foreach to read the file, rather than something like readlines. Next I want to avoid creating these records one at a time with ActiveRecord so instead I'm thinking it would be far faster to parse the file into big SQL statements that I can just execute in one go at the end.

-   Wrote an RSpec test for the task and created a test file for it to run. (Note: I won't record the PASS/FAILs for this as they're going to be pretty frequent! But I am using TDD).
- Used the rails g task command to create the parser task with a filepath argument.
-   Declared four array variables to hold campaign/candidate names and campaign/candidate SQL values. Also declared a votes variable as a string as I'll be building the votes SQL more directly.
- Started by turning each line into an array so that the individual components can be played around with.
-   Wrote a method to verify a line is well formed by ensuring the right fields are there in the right order and that a choice exists.
- Started getting an encoding error when testing the sample file. Put the strange character into the votes test file and modified the test to include this scenario. Corrected it using the encode method on the lines as they are being parsed.
- For each valid line I shovelled the campaign name and the candidate name into the appropriate array. This step is so that I can later use the uniq method to avoid duplication. As for the votes I shovelled into the string a list of values in brackets, with a comma and space at the end. This is how the INSERT INTO statement will need it to be structured.
- Because there's no Activerecord magic available I added the created_at and updated_at columns in too. Invoking DateTime.now wasn't enough as the database wasn't a fan of the timezone so I used the strftime method to put it into appropriate format.
- Looped through a uniqued version of the campaign names and candidate names and shovelled them into the appropriate arrays. Created an INSERT INTO SQL statement by joining the arrays with a comma and then executed.
- Now that the campaigns and candidates exist in our database we have the IDs required for the votes SQL statement. After creating the statement I looped through the campaigns and candidates and replaced any instance of their names with the appropriate ID.
- Finally I replaced the validity with the appropriate enum integer, chomped the final, unnecessary comma and space from the end of the statement, then executed.
- TEST PASS

It's looking pretty good at this point but there are a couple of improvements that could be made. Firstly, as we are dealing with user-submitted data we're wide open to SQL injection attacks. Secondly we aren't fully protected against duplicate record entries. So for a couple of final touches:

- Added the sanitize_sql method to the SQL statement variables.
- Looped through existing campaign and candidate names before adding to the values arrays.

Votes could also use a similar process but I'm assuming that would best be done using a unique identifier such as the GUID, which isn't part of this exercise. Although perhaps the epoch time value along with the campaign and candidate would do it? Something to talk about in the interview.

**Styling**

- Started Rails server for the first time!
- Added some styling for fun.