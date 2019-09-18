<div class="aem-logo"></div>
<div class="adobe-logo"></div>

---

# Integrate Cloud Manager with an external system using Adobe I/O.

## Table of Contents

* Lesson 1 - Glitch Setup
* Lesson 2 - Webhook Setup
* Lesson 3 - Testing it Out
* Next Steps




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

### Prerequisites

As a LiveTrial attendee, you have been provisioned with all of the necessary access and software needed to participate in this scenario. If you are using this workbook outside of the LiveTrial, you'll need the following:

* Access to Cloud Manager with the Deployment Manager role.
* The System Administrator role for your Organization in the Adobe Admin Console.
* A git client (either the command line client or as part of an Integrated Development Environment).

## Lesson 1 - Glitch Setup

### Objectives

* Setup a Glitch Account

### Lesson Context


In this lesson, we will set up a Glitch Account. [Glitch](https://glitch.com/about/) is a simple tool for creating Web Applications

1. Navigate to https://glitch.com/ 
2. Click ` Sign In `

     > ![snitch-1](./images/snitch_1.PNG)

3. Select an appropriate Sign In option to create an account. For this exercise we are using ` Sign in with GitHub ` option

    > ![snitch-2](./images/snitch_2.PNG)

## Lesson 2 - Webhook Setup

### Objectives

1. Run a Simple Webhook
2. Expose the Webhook using Glitch

### Lesson Context

In this lesson, you will run a simple web application which illustrates the type of application typically run to receive events from Adobe I/O. You will also use a tool called [Glitch](https://glitch.com/) to deploy and expose the application to the public internet.


1. Click on bellow button to setup code the webhook within your Glitch Workspace.

  <a href="https://glitch.com/edit/#!/remix/webhook-ms-teams">
  <img src="https://cdn.glitch.com/2bdfb3f8-05ef-4035-a06e-2043962a3a13%2Fremix%402x.png?1513093958726" alt="remix this" height="33"></a> 


2. Webhook code should load up in the Glitch IDE
    > ![snitch-3](./images/snitch_3.PNG)

3. ` .env ` file defines the Environment Configuration i.e. the Client Id, Client Secret, Microsft teams API endpoint etc will be specified here
4. ` index.js ` contains the Webhook code. For more information on creating webhhoks please refer to https://github.com/AdobeDocs/cloudmanager-api-docs/tree/master/tutorial
5. ` package.json ` defines the build profiles and dependencies.
6. To test the Webhook, simply click the ` Show ` button and select ` In a New Window `

    > ![snitch-4](./images/snitch_4.PNG)

7. You should see an output like this

    > ![snitch-5](./images/snitch_5.PNG)

8. Copy the Webhook URL from the address bar and using CURL or Postman run: ` run curl -X POST <Webhook URL>/webhook `

     > ![snitch-6](./images/snitch_6.PNG)

9. 



