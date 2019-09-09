The Dispatcher SDK provides:

* Dispatcher Configuration : a vanilla file structure containing the configuration files to include in a maven project for dispatcher
* Dispatcher Validator: tooling for customers to validate a dispatcher configuration locally
* Dispatcher Docker Image: a Docker image that brings up the dispatcher locally

The validation tool is available in the SDK as a macOS or Linux binary.

It allows customers to run the same validation that Cloud Manager will perform while building and deploying a release.



Step 1. Install Docker for Mac (https://docs.docker.com/v17.12/docker-for-mac/install/) or to Windows (https://docs.docker.com/v17.12/docker-for-windows/install/)

Step 2. **[INTERNAL ONLY]** SSO to https://artifactory-uw2.adobeitc.com and create an API key that will be used in the next section
* To create an API key, click on your user name on the top right 
Onthe profile
*  create a new API key. 

![SSO](./sso.jpg)

```
docker login docker2-granite-release-local.dr-uw2.adobeitc.com 
Username : <ldapid>
Password: < Paste Token >

```


Step 3. Copy DispacthcerSDKv1.0.2sh to a folder
Step 4. Open Terminal in the folder
```
chmod +x ispacthcerSDKv1.0.2sh
```
Step 5. Put your project in the folder
Step 6. Run Validator

```
./bin/validator full -d out ~/AEMProjectDirectory/dd-dispatcher/src

```

You should get following 
![Terminal Output](validator-terminal.png)

Step 7. If needed make changes to dispatcher configurations and Re-run step 6.