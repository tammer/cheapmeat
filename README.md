cheapmeat
=========

1. Create a csv of people to email.  The format is email_address, name
2. create a spec.yml file to specify the email you want to send these people.
   note $name can be used in the body of the email to refer to the exact name
   from teh csv file in (1)

3. ruby spam.rb spec.yml

This command will first ask you for an email address for a test mail.
Use your own email address (DUH)
Check the email looks right. Check list:

- Subject field
- Salutation
- body
- sign off
- do all the links work

if all looks good, type "YES" to fire off the same email to everyone on the list