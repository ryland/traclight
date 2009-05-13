Traclight 
---------
- version 0.1
- author: Ry Wharton
- url: http://tech.howcast.com
- source: http://github.com/ryland/traclight/tree/master

Why hello, you have stumbled upon a simple script to import a trac.db database file into Lighthouse. 

## Requirements
- activerecord
- activeresource
- activesupport
- lighthouse-api (http://github.com/Caged/lighthouse-api/tree/master)

## Limitations
- The tickets will show up as being reported by the owner of the account you specify in the ticket, not the original reporter. The original Trac reporter will show up in the description for the ticket.
- It is not possible to set the original date the ticket was reported in Lighthouse. The original reporting date of the Trac ticket will appear in the Lighthouse ticket description.
- Attachments are _not_ imported, as support currently doesn't exist in the API.

## Tips
- Starting with an empty Lighthouse project will maintain your ticket numbers, assuming your Trac tickets start at 1 and none have been deleted.
- If you need to do a selected import, check out the convert method, which allows you to pass an options parameter to an ActiveRecord.find() call. (At some point this will be available via the command line...) 

## Use

Please read the LICENSE.

1. Create all milestones and users for your project before running the script. You will need the ID numbers for these to convert them correctly.

2. The export your trac database. You should have a copy of trac.db to run the script on. See http://trac.edgewall.org/wiki/TracFaq#is-there-any-way-to-migrate-tickets-from-one-trac-installation-to-another for more info.

3. You will need to edit the commented sections at the beginning of the traclight.rb file in order to add your project related info. 

4. Once you have entered your information in the script, you can simply run:
    traclight.rb PATH_TO_YOUR_TRAC_DB


