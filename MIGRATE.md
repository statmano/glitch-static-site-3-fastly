# Migrate your static Glitch site to Fastly Compute

Use this repo if you have a static Glitch site you want to deploy to Fastly Compute, like a Glitch in Bio or Hello Eleventy remix.

## Set up your repo and Codespace

* Fork the migration repo: https://github.com/glitchdotcom/glitch-static-site-to-fastly/
* Export your Glitch project to your forked repo from the editor Tools menu https://help.glitch.com/s/article/Exporting-Projects-to-GitHub
* Merge your glitch branch into your main branch
* Remove a couple of files that might appear in your export and could complicate subsequent steps (make sure you’re on your glitch branch if you’re in GitHub):
  * `package-lock.json`
  * `shrinkwrap.yaml`

Open your project in a GitHub Codespace by clicking **Code** on your new repo and creating a new codespace on your main branch.

## Update your images

If you uploaded images to Glitch through the Assets folder you’ll need to move them too:

* Download your images
* Include them in a folder in your Codespaces app 
* Update image references in yoru site code (like `src` in `img` elements) to point at your local files

## Test your site locally

Your Codespace scripts will attempt to build and run your site. You'll need files in the `build` folder to deploy to Fastly – this folder should appear and be populated automatically if you're using a Glitch in Bio or Hello Eleventy remix. If you were using a static site with no `package.json` file you'll need to make the folder manually:

* Create a folder named `build`
* Copy all of your static site files into the new folder (e.g. HTML, CSS, client side JS, images)

Check your `build` folder for your output files. If they're there you're good to move forward.

Click the **🧪 Serve** button at the bottom of the Codespace. 

The Fastly tooling will attempt to scaffold a new Compute app for your project and run it in the Codespace – it might take a couple of minutes but you should see a preview of your site open in the Codespace.

## Deploy your site

Ready to publish? Great, [sign up for a free Fastly developer account](https://www.fastly.com/signup/).

* Get an API Token from **Account > API Tokens > Personal Tokens > Create Token**
  * _Type_: Automation
  * _Role_: Engineer
  * _Scope_: Global (deselect the Read-only access box)
  * _Access_: All services
  * _Expiration_: Never expire
* Copy the token value

Back in your Codespace, click into the textfield at the top of the editor and type `>` to access the command palette:

* Type `secret` and select **Codespaces: Manage user secrets**
* Click **+ Add a new secret**
* Enter the name `FASTLY_API_TOKEN`
* Paste your token value and enter
  
In the notifications area at the bottom right of your codespace, you should see a prompt to reload for the new environment variable, so go ahead and click that (otherwise click the little bell 🔔 icon to check for the message).

Go ahead and click the **🚀 Publish** button at the bottom of the Codespace editor and watch the Terminal for the output! Hopefully you see an `edgecompute.app` domain that returns your site...

## If you’re using a domain through Fastly 

If you already have a domain for your site in a Fastly CDN service, you have two choices:

* Remove the domain from your CDN service and add it to your new Compute service, OR 
* Point your CDN service at your new Compute site by setting the origin host in your CDN service to your `edgecompute.app` address instead of the `glitch.me` address

You’ll find your new Compute service in your Fastly account and can access Observability data as well as other service settings.

## HELP

Need support? Post on the [Fastly Community Forum](https://community.fastly.com)

