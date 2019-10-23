
# One to Many Push Rollout Configurations 

### Scenario Roadmap

Out-of-the-box(AEM 6.5 GA), MSM only allowed 1:1 pull rollouts, i.e. "synchronize" button/option in AEM Live Copy UI. It wasn't possible to initiate rollouts on the live copy source.

In order to allow 1:many push-rollouts, turning a live copy source into a "blueprint" (for many live copies), a "Blueprint Configuration" had to be created (AEM Start/Tools/Sites/Blueprints).

With AEM as a Cloud Service, this would have not been possible as Blueprint Configurations at author runtime are stored under /libs/msm.

In AEM as a Cloud Service, any live copy source is now a "blueprint", meaning rollout can now be initiated on a live copy source. As soon a live copy is created, the source automatically becomes a "blueprint".

#### Lesson Context
