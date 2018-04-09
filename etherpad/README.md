# Fast 'n ugly Dataporten + Etherpad deploy

This is a proof of concept.  Do not use it to store *ANY* data you'd like to hold on.  
This **WILL** shave your cat and then eat it.

This repository forked from https://github.com/UNINETT/ep_dataporten.

Ingredients:

- Docker
- Dataporten application credentials (obtain from dashboard.dataporten.no)
	- Make sure that your application has access to all scopes!
	- `groups` `userid` `profile` `userid-feide` `email`
	- Redirect URL: `http://localhost:8001/dataporten/callback`

How to make:

1. Create a file env.txt with contents somewhat similar to:

		HOST=localhost:8001
		TLS=false
		DATAPORTEN_CLIENTID=00000000-0000-0000-0000-000000000000
		DATAPORTEN_CLIENTSECRET=00000000-0000-0000-0000-000000000000
		DATAPORTEN_SCOPES=groups,userid,profile,userid-feide,email

Remember not to skimp on the scopes!

2. Then start the whole rigamarole with:

		docker rm --force etherpad
		docker build -t etherpad .
		docker run -p 8001:9001 --env-file env.txt etherpad

3. You should now be able to use Etherpad on http://localhost:8001
