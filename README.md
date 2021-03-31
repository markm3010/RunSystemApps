Written by Mark Matthias while employed at an oil service company
for 13 years.  It was written in Perl and was a very useful sanity
test while I was working as a QA Engineer at this company.

This is not a complicated program.  The application suite 
I tested for years consisted of MANY separate 
applications that did a particular job very well.  
The app suite was in maintenance mode since before I 
arrived and there were regular bug fixes and feature 
upgrades that were released on a semi-regular basis.  
One issue that occassionally came up was, one of the 80+ 
applications wouldn't start, due to some dll modification 
or somesuch.

This application was semi-automated.  It starts every application 
(except those that get executed as part of sanity testing and 
were super low-risk), and the tester had to close the app so the
next one would run automatically.  This way we were able to spot
startup issues with a particular app before the produce was released.
