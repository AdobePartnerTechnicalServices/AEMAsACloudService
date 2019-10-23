
# Access Log files for AEM as a Cloud Service Environment

### Scenario Roadmap

In this scenario, we will use Cloud Manager and the Cloud Manager plugin for the Adobe I/O CLI to access log files for AEM as a Cloud Service Environment.

#### Lesson Context

For this scenario, we will utilize:

* Adobe I/O CLI
* Cloud Manager UI

```
While Log Download is available through both the Cloud Manager UI and API, Log Tailing is API/CLI-only
``` 
---

##### 1. Access Log via Cloud Manager UI

1. Navigate to Cloud Manager
2. Go to the ` Environments ` Card
3. Click on the setting cog and select ` Download Logs `
    > ![1.PNG](./images/1.PNG)
4. Alternatively, click on the ` Environments ` Tab
5. Click ` Manage ` Button and Select ` Download Logs `
    > ![2.PNG](./images/2.PNG)

6. Download the log file for the specific environment

    > ![3.PNG](./images/3.PNG)

##### 2. Access Logs via Cloud Manager plugin for the Adobe I/O CLI

1. Launch Command Prompt/Terminal 
2. Navigate to Adobe IO CLI Plugin Installation Directory
3. Execute the following commands:
    > Obtain Environment ID: ` aio cloudmanager:list-environments `

    > ![4.PNG](./images/5.PNG)

    > View Available Log Options: ` aio cloudmanager:list-available-log-options 6314 `

    > ![5.PNG](./images/6.PNG)

    > Download Logs: ` aio cloudmanager:download-logs --programId 3356 6314 author aemerror `

    > Tail Logs: ` aio cloudmanager:tail-log --programId 3356 6314 author aemerror `

