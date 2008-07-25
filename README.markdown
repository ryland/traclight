Traclight 
version 0.1
http://tech.howcast.com

A simple script to import a trac.db file into Lighthouse.


## Requirements
- activerecord
- activeresource
- activesupport
- lighthouse-api (http://github.com/Caged/lighthouse-api/tree/master)

## Limitations
- Due to the Lighthouse API limitations, ticket comments will be merged into a formatted description of the ticket.
- The tickets will show up as being reported by the owner of the account you specify in the ticket, not the original reporter. The original Trac reporter will show up in the description for the ticket.
- It is not possible to set the reported date in Lighthouse. The original reporting date of the Trac ticket will appear in the Lighthouse ticket description.

## Use

You will need to edit the commented sections at the beginning of the traclight.rb file in order to add your project related info. Once completed, you can simplyrun:

    traclight.rb PATH_TO_YOUR_TRAC_DB


