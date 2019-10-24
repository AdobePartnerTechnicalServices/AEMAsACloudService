

### Scenario Roadmap/Lesson Context

With AEM as a Cloud Service, the well known replication framework (used from 5.0-6.5) is no longer used to publish pages. Instead it uses the Distribution (Sling Content Distribution) capability to move the content to a pipeline service run on Adobe I/O that is outside of the AEM runtime. 

The setup is automated and also auto-configures itself during runtime when when publish or author nodes are added, removed or recycled. 

Publication/Unpublication is automatic, in that a single un/publication request will succeed for all resources in the AEM Publish Service, or fail for all. The resources within the AEM Publish Service will never be in a inconsistent state.

>   ![scd_o.png](./images/scd_0.png)


In this lesson we will explore the Sling Content Distribution Framework

### Step 1. Use the content distribution framework


1. Navigate to ` Tools > Deployment > Distribution `

    > ![scd_1.png](./images/scd_1.png)

2. Click the ` forwardPublisher ` card

    > ![scd_2.png](./images/scd_2.png)

3. Verify the ` forwardPublisher  ` Content Distribution Agent's configuration 

    > ![scd_3.png](./images/scd_3.png)

4. Select one of the queue and click the ![scd_5.png](./images/scd_5.png) button

5. Click ` Clear `

    > ![scd_4.png](./images/scd_4.png)

6. Click on one of the queue to view the detailed status

    > ![scd_6.png](https://media.giphy.com/media/JpSDE8jsV3M4LQrJj4/giphy.gif)

7. Click on ` Logs ` Tab to view the log messages

    > ![scd_8.png](./images/scd_8.PNG)

8. Click on ` Distribute `

    > ![scd_9.png](./images/scd_9.PNG)

9. Select ` Add Tree ` and select a content path

    > ![scd_10.png](./images/scd_10.png)

10. Click ` Submit `

11. Verify the status for ` forwardPublisher ` agent by going back to the ` Status ` tab

  > ![scd_11.png](./images/scd_11.PNG)

12. Click on the ` Logs ` tab to verify the log messages



