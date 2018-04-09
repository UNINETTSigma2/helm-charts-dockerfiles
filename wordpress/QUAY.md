# Pushing things to QUAY without selling your soul

Quay is your next hip cloud thingy that's going to change the world.
Here, we're going to use it as a Docker registry without giving it
full write access to our GitHub account, because we're having cold feet.

You see, when you try to create a new Docker repository in Quay, it helpfully
suggests pointing it to a GitHub repo, so it can do all Docker building stuff
for you.  But in order to let it do that, it wants to have full read and write
access to all your repos, both private and public.  Personally, I don't think
that's the way to go.

If you share my paranoia, use this guide to push a docker image to Quay from
your local machine.  This means that you'll have to do the building yourself,
so a local (not to mention working) Docker installation is required.  I'll leave
you alone with the internet for a couple of minutes to sort that out privately,
promise I won't look.

..got all that?

Okay, first of all you will need Quay access.  Go to https://quay.io and log in;
you may log in with your GitHub account here, for login-only they don't ask for
scary access.  Although you will need a password eventually, which you'll see
later on in this guide (step 2).

1. Now make a repository by clicking the big + symbol at the upper right.  You
   want a **New Repository**.  You'll make it **Public** and of the type
   **(Empty repository)** which lets you upload it by hand.  Let's assume for
   this guide that you called your project `wordpress`.

So now you've created the project `quay.io/uninett/wordpress`, k?

2. Log in to Quay.. No, not your webbrowser, but the commandline Docker
   instance.

You may need to set a password in Quay.  If you've first logged in through
GitHub you don't have a password.  Quay has this fancy feature called
"Encrypted Password" because it's *dangerous*™ to use your own password on
the command-line.  It doesn't work when you haven't set a password on your Quay
account, though.  That's because it's not an application password, but an
[encrypted password](https://security.blogoverflow.com/2011/11/why-passwords-should-be-hashed/).

Yay.  So you've logged in via your GitHub account in order to avoid needing
yet another password you need to keep track of.  And now you must set a
password.  Which you're expected to remember, or at least store.
Funny, isn't it?

So what should you do?  Go to your profile (in Quay click your username upper
right, click **Account Settings** and then click **Change password** about
halfway through the page).  Generate some random password and write it on a
post-it, and use that password on the command line when it asks for it in the
next step.

		docker login quay.io

Now it'll ask you for your credentials.  Fill out as you see fit.

4. Go stand in the project root (use `cd`), it's the directory the Dockerfile is
   in.

		cd ~/hipstertech/docker/projects/wordpress

5. Copy these commands, go to your terminal, close your eyes and press ⌘V:

		docker build . -t quay.io/uninett/wordpress
		docker push quay.io/uninett/wordpress

Open your eyes, and you've now probably successfully published a docker image to
Quay.

You can now deploy it on UNINETT infrastructure using [HELM](helm/README.md).
