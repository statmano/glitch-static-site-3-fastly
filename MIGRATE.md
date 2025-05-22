# Migrate your static Glitch site to Fastly Compute

Use this repo if you have a static Glitch site you want to deploy to Fastly Compute, like a **Glitch in Bio** or **Hello Eleventy** remix. We'll be using the [Static Publisher](https://github.com/fastly/compute-js-static-publish) tool with some helper scripts that run in a GitHub Codespace.

> **🚧 This project is an experiment in hosting static sites built on Glitch on Fastly!**
> 
> **🚨 The container scripts in this repo will attempt to automate parts of the migration process for you, but they won't work across all Glitch websites because there are simply to many weird and wonderful variations to accommodate. 🌈 🛼 🪩**
>
> **We'd love your help making this process helpful to more people, so please share problems, suggestions, and feedback, either here in the repo [Issues](https://github.com/glitchdotcom/glitch-static-site-to-fastly/issues) or on the [Fastly community forum](https://community.fastly.com). 📣**

## Set up your repo 

* Fork the migration repo: [glitchdotcom/glitch-static-site-to-fastly](https://github.com/glitchdotcom/glitch-static-site-to-fastly/)
* Download your Glitch project from the editor **Tools** menu: [Glitch help docs export guide](https://help.glitch.com/s/article/Downloading-Projects)
* Unzip your downloaded app – remove some files that might appear in your export and could complicate subsequent steps, for example:
  * `package-lock.json`
  * `shrinkwrap.yaml`
  * _Check for any other files you think you can remove, including files beginning with `.` that may be hidden by default_
* Add your Glitch project files to your new repo
  * You might find this easiest by cloning your forked repo locally and copying the files over – remember to push your changes to GitHub

### Static sites with no build process

If your site does not contain a `package.json` file, for example if it's a **Hello Website** remix, you'll need to add a couple of files to use a build process which will add your files to an output folder:

Add a `package.json` file:

```json
{  
  "scripts": {
    "start": "vite",
    "build": "vite build",
    "serve": "vite preview"
  },
  "devDependencies": {
    "vite": "^4.0.0"
  },
  "engines": {
    "node": "16.x"
  }
}
```

And a `vite.config.js` file:

```js
import { defineConfig } from "vite";

export default defineConfig(async ({ command, mode }) => {
  return {
    build: {
      outDir: "build"
    }
  };
});
```

## Update your images

If you uploaded images to Glitch through the Assets folder you’ll need to move them separately:

* Download your images
* Include them in a folder in your new repo 
* Update image references in your site code (like `src` in `img` elements) to point at your local files

## Open your project in a Codespace

Open your project in a GitHub Codespace by clicking **Code** on your new repo and creating a new codespace on your branch. 

![create codespace](https://github.com/user-attachments/assets/078484b0-af79-45e8-8f4f-4a3ef045b185)

The Codespace container scripts will attempt to build and run your site. Use the **🔎 Split** button to show the preview side by side with your files.

![running local app](https://github.com/user-attachments/assets/4311816e-5cab-4207-addf-78cea7194823)

You'll find some helper buttons along the bottom of the editor that run scripts in the `_migrate` folder – you might need to tweak these commands depending on your website.

## Build your site locally

In most cases you'll need your site output files to be in the `build` folder to deploy to Fastly – this folder should appear and be populated automatically if you're using a **Glitch in Bio** or **Hello Eleventy** remix and will include the static assets that make up your production website (e.g. HTML, CSS, client side JS, images).

Check your `build` folder for your output files. If they're there you're good to move forward.

### Sites with a different build process or output folder

If you're having trouble getting the build process to complete, check out your project `package.json` file for the relevant commands to try, and any config files you have for the framework you're using, in case the output folder is named something different – if it is, change the `_migrate/serve.sh` and `_migrate/publish.sh` scripts to point at the relevant folder instead of `build`.

## Test your Compute app

Click the **🧪 Serve** button at the bottom of the Codespace to try building and running a Compute app to deliver your website.

The Fastly tooling will attempt to scaffold a new Compute app for your project and run it in the Codespace – it might take a couple of minutes but you should see a preview of your site open in the Codespace. 

![running test compute app](https://github.com/user-attachments/assets/f3c17565-4e42-449d-892f-8adc49e02c6c)

You should see the preview URL change to reflect the port number for your Compute app which will be `7676`.

Your Compute app code will be in the `compute-js` folder, and the `fastly.toml` file will update with your Fastly service details as you execute the commands.

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

> You can alternatively add your API key in the repo **Settings** > **Secrets and variables** > **Codespaces**.

![reload codespace](https://github.com/user-attachments/assets/b7a3271a-b183-44f2-82ed-968aa26f921e)

> _When you reload your codespace you might see an error about a port already being in use – this happens in Vite projects like Glitch in Bio. You can fix it by removing the `server` object from your `vite.config.js` file, or you can just ignore it._ 💅

Go ahead and click the **🚀 Publish** button at the bottom of the Codespace editor, confirm you want to proceed with a `y` and watch the Terminal for the output! 

![follow link](https://github.com/user-attachments/assets/ed2c4a60-5d4e-4a0d-b06b-a6d7a6d45c70)

Hopefully you see an `edgecompute.app` domain that returns your site – go ahead and open it!

![deployed app](https://github.com/user-attachments/assets/a6c2210b-bdf0-4256-bcd9-67052c15d9f9)

> ⚠️ Note that if you go through this flow for more than one site you’ll need to change the KV Store name in your `_migrate` scripts to avoid duplicates.

## If you’re using a domain through Fastly 

If you already have a domain for your site in a Fastly CDN service, you have two choices:

* Remove the domain from your CDN service and add it to your new Compute service, OR 
* Point your CDN service at your new Compute site by setting the origin host in your CDN service to your `edgecompute.app` address instead of the `glitch.me` address

You’ll find your new Compute service in your Fastly account and can access Observability data as well as other service settings.

## HELP

📣 The migration scripts in this repo are very much a work in progress and we'll be iterating on them based on your feedback – please feel welcome to create Issues on [this GitHub repo](https://github.com/glitchdotcom/glitch-static-site-to-fastly)!

🛟 Need support? Post on the [Fastly Community Forum](https://community.fastly.com)
