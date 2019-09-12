<div class="aem-logo"></div>
<div class="adobe-logo"></div>

---

# Integrate Cloud Manager with an external system using Adobe I/O.

## Table of Contents

* [Lesson 1 - Create a Webhook](#lesson-4---create-a-webhook)
* [Lesson 2 - Webhook Setup](#lesson-5---webhook-setup)
* [Lesson 3 - Testing it Out](#lesson-6---testing-it-out)
* [Next Steps](#next-steps)
* [Additional Resources](#additional-resources)



### Scenario Roadmap

In this scenario, we'll be using a number of different tools, so before we get started, let's do a quick overview of what each of these tools does and how we will be using them.

* Cloud Manager
    *  In this scenatio, we'll be setting up a CI/CD pipeline in Cloud Manager and executing it a few times. 
*  Git
   * Git is a version control system. Every Cloud Manager customer is provided with a git repository. This scenario won't be teaching you the ins and outs of using git; just enough to get by. 
* Adobe I/O
    *  Adobe I/O is Adobe's centralized API Gateway through which customers and partners can integrate with the entire Adobe product portfolio. 
* Microsoft Teams
    * Microsoft Teams is a collaboration platform which includes chat (both group and one-on-one), voice, video, and other types of communication.

![Lab Touchpoints](images/overview/roadmap.png)

The last item in this picture is a webhook. This is a small piece of software which you'll be configuring, running, and (if you want) modifying which will act as a notification broker between Adobe I/O and Microsoft Teams. Your webhook (created in Lesson 4) will receive notifications _from_ Adobe I/O and then send notifications _to_ Microsoft Teams. In addition to receiving notifications from Adobe I/O, the webhook will make API calls _to_ Adobe I/O to augment the information provided in the initial notification.

### Prerequisites

As a LiveTrial attendee, you have been provisioned with all of the necessary access and software needed to participate in this scenario. If you are using this workbook outside of the LiveTrial, you'll need the following:

* Access to Cloud Manager with the Deployment Manager role.
* The System Administrator role for your Organization in the Adobe Admin Console.
* A git client (either the command line client or as part of an Integrated Development Environment).

## Lesson 1 - Create a Webhook

### Objectives

1. Run a Simple Webhook
2. Expose the Webhook using ngrok

### Lesson Context

> NodeJS is required for this lesson. Please install it if you haven't done so.

In this lesson, you will run a simple web application which illustrates the type of application typically run to receive events from Adobe I/O. You will also use a tool called [ngrok](https://ngrok.com/) to expose that application to the public internet.

![Lab Touchpoints - Lesson 4](images/lesson4/roadmap.png)

#### Exercise 1.1

The next two lessons are focused on how to use the Cloud Manager API and Adobe I/O to receive notifications from Cloud Manager when the pipeline starts. To do this, we will create a _webhook_. A webhook is simply a small web application which receives a request from a service when something has happened. In this case, Adobe I/O will invoke the webhook on any pipeline event -- when the pipeline starts, when it ends, when individual steps start and end, etc.

The bulk of the webhook has already been written and in the next lesson we will be configuring the webhook, but before we get to the real webhook implementation, let's start by running a very simple webhook. 

To start this: 
1. Go back to Visual Studio Code. 
2. Open the _File_ menu and select _Open Folder..._. 
3. Click on <USB Contents>/aem65livetrials/cloudmanager_imp/CloudManagerOnline/webhook.
4. Click the _Open_ button.

![Open Webhook Folder](images/lesson4/open-webhook-folder.png)

> You may need to run npm install to initialize the project

> The webhook project is available in a public GitHub repository. See the [Additional Resources](#additional-resources) section for the link.

This folder contains two webhook implementations written in JavaScript -- _simple.js_ and _webhook.js_. We're going to run _simple.js_ script first. To do this, open the _Terminal_ menu and select _New Terminal_.

![New Terminal](images/lesson4/terminal-menu.png)

This will open a new Terminal panel in Visual Studio Code with a shell prompt. In this panel, run the command 
1. `npm install` . This will install the node modules
2. `npm run start-simple`. This will run the _simple.js_ webhook.

![Running Simple Webhook](images/lesson4/terminal-running-simple.png)

To test this out, we'll use a second terminal panel. To do this, open the _Terminal_ menu and select _Split Terminal_.-- Or just open a new terminal window.

![Split Terminal](images/lesson4/terminal-menu-split.png)

In the second Terminal panel, run the command `curl -X POST http://localhost:[PORT]/webhook`. What you should see is a simple response (`pong`) to the request and a message in the first panel showing that a webhook request was received.

![Testing Simple Webhook](images/lesson4/after-running-curl-to-localhost.png)

Congratulations! You've run a simple webhook.

#### Exercise 1.2

In order for Adobe I/O to access the webhook, it must be accessible on the public internet. Since your laptops are not publicly accessible, we will use a piece of software named [ngrok](https://ngrok.com/download) to create a tunnel which allows Adobe I/O to access the webhook.

To do this, go back to the second Terminal panel in Visual Studio Code and click the plus icon to open a second terminal window. In this window, type

```
ngrok http 3000
```

This command instructs _ngrok_ to open a tunnel from a randomly generated URL to port 3000 on your lab workstation.

ngrok will start running and output something like this to confirm it is up and running:

![Running ngrok](images/lesson4/after-running-ngrok.png)

In this screen, the URL generated by ngrok is `https://4830004e.ngrok.io`

> If you register for an ngrok account, you will be able to assign a custom domain name.

If you want to be sure this is working, feel free to open a third split Terminal panel and run `curl -X POST <ngrok URL>/webhook`.

![Running curl to ngrok](images/lesson4/after-running-curl-to-ngrok.png)

Now that we have a simple webhook running, we can setup and run the real webhook.

## Lesson 2 - Webhook Setup

### Objectives

1. Register an API integration with Adobe I/O
2. Set up Webhook for publishing to Microsoft Teams
3. Register your webhook with Adobe I/O

### Lesson Context

In this lesson, you will be configuring the actual webhook which will be invoked by Adobe I/O and will, in turn, invoke a Microsoft Teams API in order to send a notification when your Cloud Manager pipeline starts.



#### Exercise 2.1

> Before proceeding with this exercise, make sure that ngrok is running; the URL generated each time you start ngrok may be different and that URL will be used in this exercise (and the next one). If you need to stop and restart ngrok, you will need to go back to the Adobe I/O console.

The bulk of the real webhook is already written (in the file _webhook.js_ in the same directory opened in the prior lesson in Visual Studio Code). It does need to be configured so that it can invoke the Cloud Manager API *and* so that it can post messages to Microsoft Teams or Slack.

The webhook uses a Node.js library named _dotenv_ to read its configuration. As the name suggests, this library uses a file named _.env_. In Visual Studio Code, click on this file in the Explorer to open it.

> In the actual git project linked to from the [Additional Resources](#additional-resources) section, this file is not provided; the file _.env.template_ is present and needs to be copied to a file named _.env_.

![Empty .env file](images/lesson5/empty-env-file.png)

We now need to populate the first handful of lines in this file. To do this, we will register an Integration in the Adobe I/O Console. Before doing that, we need to generate a cryptographic certificate in order to securely sign requests to Adobe I/O.

Select the first Terminal panel (i.e. the one where the webhook is running, not the panel in which ngrok is running) and type Ctrl-C.

```
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout private.key -out certificate.crt
```

You'll be prompted here for a series of values. The actual values don't really matter for the purposes of this lab, but you must *at minimum* provide an email address.

Now, switch back to Chrome. Open a new tab and navigate to https://console.adobe.io/

> You shouldn't have to log in, but if you do, use the same credentials as used in Lesson 1.

Click the New integration button.

![Adobe I/O Console Home](images/lesson5/console-home.png)

The integration (which is how Adobe I/O refers to API clients) will both need to receive events and make API calls, so the answer to the question "Do you want to access an API or receive near-real time events" is actually _both_, but Adobe I/O requires this to be a two-step process. Leave _Access an API_ selected (it should be the default) and click Continue.

![New Integration Type Select](images/lesson5/new-integration-type-select.png)

Select Cloud Manager and click the Continue button.

![New Integration Service Select](images/lesson5/new-integration-service-select.png)

On the _Create a new integration_ screen, ensure _New integration_ is selected and click the Continue button.

![New Integration Confirmation](images/lesson5/new-integration-confirm.png)

Provide a name and description for your integration.

![New Integration Details](images/lesson5/new-integration-details.png)

In the _Public keys certificates_ box, click the _Select a File_ link and open the _certificate.crt_ file created by `openssl`.

![New Integration Certificate Select](images/lesson5/new-integration-certificate-select.png)

Finally, select the _Cloud Manager - Deployment Manager Role_ profile from the product profile list and click the _Create integration_ button.

![New Integration Role Select](images/lesson5/new-integration-role-select.png)

You'll now see a confirmation screen saying that your integration has been created. Click the _Continue to integration details_ button to see the details of the created integration.

![Integration Creation Confirmation](images/lesson5/integration-created.png)

You now need to copy and paste the values for the API Key, Technical account ID, Organization ID, and Client Secret from this screen into the `.env` file in Visual Studio Code. Use the Copy button next to each value (clicking the _Retrieve client secret_ button to show the Client Secret) and paste them into the corresponding variable in the `.env` file.

![Integration Details](images/lesson5/integration-details.png)

![Integration Details in .env file](images/lesson5/env-file-with-integration-details.png)

The `PRIVATE_KEY` variable needs to be set as the value of the generated `private.key` file but *without any line breaks*. There's a helper script which will do this for you. To run this and copy the result to the clipboard, in the terminal panel type:

```
npm run clean-private-key | pbcopy
```
Then you can paste this value into the `.env` file.

![Private Key in .env file](images/lesson5/env-file-with-private-key.png)

#### Exercise 2.2

The next value we need is a webhook URL which will be used to post messages to Microsoft Teams or Slack.

> This part is a bit complicated, but essentially Adobe I/O is going to invoke a webhook on your lab machine which *in turn* will invoke a webhook hosted by Microsoft/Slack.

To start, open [Microsoft Teams](https://teams.microsoft.com/l/team/19%3a5b863af592054aeeb1a626312d632c92%40thread.skype/conversations?groupId=c439f143-e41d-4170-bb84-ee0a79a7e846&tenantId=fa7b1b5a-7b34-4387-94ae-d2c178decee1) 

If you see the _Welcome to Teams! screen (see below), click the _Continue_ button.

![Teams Login - Welcome](images/lesson5/welcome-to-teams.png)

To create an Incoming Webhook integration, click the Store icon.

![Teams Store Button](images/lesson5/teams-store-button.png)

Search for _incoming_ and click on _Incoming Webhook_.

![Search for Incoming Webhook Connector](images/lesson5/teams-incoming-search.png)

Select _Summit Lab 722_ as the team. Since the connector is already installed, click the _Available_ link.

![Select Team](images/lesson5/teams-team-select-available.png)

The webhook should send messages to the General channel by default. On the next screen, click _Set up_.

You need to provide a name for your webhook. Do this with a name based on your attendee number and click the _Create_ button.

![Name Teams Webhook](images/lesson5/teams-webhook-name.png)

You will now see a URL (it will begin with `https://outlook.office.com/webhook/`). Click the button to copy this to the clipboard and click the _Done_ button.

![Name Teams URL](images/lesson5/teams-webhook-url.png)

Now switch back to Visual Studio Code and paste the copied URL as the value of the `TEAMS_WEBHOOK` variable in the _.env_ file.

![Teams URL in .env file](images/lesson5/env-file-with-teams-url.png)

The last value which needs to be populated in the `.env` file is the name of the pipeline you created in Lesson 1. After adding this, make sure save the file in Visual Studio Code.

![Pipeline Name in .env file](images/lesson5/env-file-with-pipeline-name.png)

#### Exercise 2.3

With our webhook fully configured, we can start it and register it with Adobe I/O.

> In order to register a webhook with Adobe I/O, it must be running and, as mentioned in Lesson 4, accessible from the public internet.

To start the webhook, in the terminal panel in Visual Studio Code run

```
npm start
```

![Webhook Started](images/lesson5/webhook-started.png)

Switch back to Chrome (you should still be on the Integration Details page in the Adobe I/O Console) and click the Events tab.

Under the _Add New Event Providers_ section, select Cloud Manager and click the _Add event provider_ button.

![Add Event Provider](images/lesson5/add-event-provider.png)

Then click the Add Event Registration button.

![Add Event Registration](images/lesson5/add-event-registration.png)

Provide a name and description for your webhook and as the URL, use the ngrok-generated URL plus `/webhook`, e.g. if ngrok displayed `https://4830004e.ngrok.io`, the webhook URL is `https://4830004e.ngrok.io/webhook`. Adobe I/O registrations can receive multiple types of events (even multiple types of events from different providers). For the purpose of this lab, we only _need_ to subscribe to the _Pipeline Execution Started_ event. Click the checkbox next to this event. Then click the Save button.

![Event Registration Details](images/lesson5/event-details.png)

If you've entered the URL correctly, the event registration is now Active.

![Active Event Registration](images/lesson5/active-event-registration.png)

However, if you have entered the wrong URL, you will see a message that the verification has failed. If you see this, click the View button and double check the URL.

![Failed Event Registration](images/lesson5/failed-event-registration.png)

## Lesson 3 - Testing it Out

### Objectives

1. Re-Execute the Pipeline
2. Watch Notifications in Microsoft Teams

### Lesson Context

In this last lesson, you will test the process end to end by starting the pipeline in Cloud Manager and, if everything is working correctly, observe the resulting notification in Microsoft Teams.

![Lab Touchpoints - Lesson 6](images/lesson6/roadmap.png)

#### Exercise 3.1

At this point, your webhook and ngrok should be running and registered with Adobe I/O. So now it is time to run the pipeline again. Go back to the Overview page in Cloud Manager, find your pipeline and start it.

#### Exercise 3.2

Depending on how quickly everyone in the lab has reached this step, our Microsoft Teams channel is about to get very noisy. Each pipeline start should result in this kind of notification in the channel:

![Notification in Teams](images/lesson6/teams-notification.png)

If you see this notification for your pipeline, feel free to experiment with the webhook (see the [Next Steps](#next-steps) section for some ideas).

If not, you should go back to Lesson 5 and make sure the `.env` file is set up correctly. If you need to change anything in this file, you need to stop the webhook process (using Ctrl-C) and restart it.

Another thing to look at is the Debug Tracing tab in the Adobe I/O console. This will list the requests sent to your webook. To see this information, click the View button for your Event Registration in the console and select the Debug Tracing tab. This will show you the requests made to your webhook by Adobe I/O.

![Adobe I/O Events Debug Tracing List](images/lesson6/debug-tracing.png)

Clicking on one of these entries will show you the headers and body for both the request and response.

![Adobe I/O Events Debug Tracing Detail](images/lesson6/debug-tracing-detail.png)

If you're still stuck, check with a Lab TA.

## Next Steps

In this lab, we have really just scratched the surface of what can be done with the Cloud Manager API and webhooks. If you've gotten this far and want to experiment some more, here are some ideas of things to try:

> Remember that anytime you change the webhook code or the `.env` file, you need to stop and restart the webhook process, but you shouldn't restart ngrok.

* Change the notification sent to Microsoft Teams when a pipeline is started. Hint: open up `webhook.js` and find where this message is defined.
* Send a message to Microsoft Teams when the pipeline ends. Hint: each time the webhook is invoked, it is passed a JSON object where the `@type` property indicates the event type. The list of event types can be found in the [API Reference](https://www.adobe.io/apis/experiencecloud/cloud-manager/api-reference.html).
* Change the color or title of the notification sent to Microsoft Teams. Hint: the current color is `0072C6`; look for this in `webhook.js`.
* Instead of (or in addition to) Microsoft Teams, send a notification to a different service or even [IFTTT](https://ifttt.com/). Hint: most services (including IFTTT) support the same kind of incoming webhooks as Microsoft Teams, just with a different payload.
* As seen in Lesson 1, CI/CD pipelines in Cloud Manager can be triggered on changes to the git repository.
    * Reconfigure your pipeline (but only your pipeline) to use this trigger and try pushing another change to the project code from Visual Studio Code and see the pipeline re-execute. Hint: You can only edit a pipeline's configuration when it is idle.
    * Add the trigger for the execution to your Microsoft Teams notification. Hint: how an execution was triggered is contained in the API response used to get the execution details and will be either `MANUAL` or `ON_COMMIT`.

## Additional Resources

* To learn more about Cloud Manager, visit https://www.adobe.com/go/aem_cloud_mgr_userguide_en
* To learn more about the Cloud Manager API, visit https://www.adobe.io/apis/experiencecloud/cloud-manager/docs.html
* To see the reference documentation for the Cloud Manager API, visit https://www.adobe.io/apis/experiencecloud/cloud-manager/api-reference.html
* To obtain the source code used in the pipeline lessons, visit https://github.com/adobe/summit2019-l722-lab-project
* To obtain the source code used in the webhook lessons, visit https://github.com/adobe/summit2019-l722-lab-webhook
* To learn more about the `MessageCard` data used for Microsoft Teams notifications, visit https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference.
