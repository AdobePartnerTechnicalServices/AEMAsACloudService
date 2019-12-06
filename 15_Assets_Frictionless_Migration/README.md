
# Asset Micro Service - Frictionless Migration 

#### WIP

To encourage migration to Assets in the Cloud, we are working to make the process as easy as possible for our customers.  To this end, we have built a “frictionless” migration tool that customers can use to migrate their asset processing workflows to Asset Compute Service processing profiles and configurations for the Custom DAM Workflow Runner.

Installation and Execution

Customers can download the tool as a compiled jar file from [TBD GitHub Release Page].  After downloading, they can run it from anywhere on their local filesystem with the following syntax:
```
java -jar aem-cloud-migration-0.1.jar <PATH_TO_MAVEN_PROJECT> [OPTIONAL_DIRECTORY_FOR_REPORT_OUTPUT]
```
When finished, the script will output a report, called migration-report.md, on the changes that it has made.  After reviewing these changes, the customer can build and deploy their project using their existing Maven build process to test them in a local environment or can check these changes into a development branch for validation through a Cloud Manager deployment.

Migration Steps

During execution, the migration tool will perform the following changes:

Create Maven Projects

We may create one or two Maven projects that will be added as submodules to the customer’s reactor POM.  These will be created to contain some of the content that is generated by the migration project and will only be created if needed.  The two Maven projects that we may create are:

` aem-cloud-migration.apps ` – contains immutable configurations, notably the configuration for the Custom DAM Workflow Runner service

` aem-cloud-migration.content ` – contains mutable configurations, notably any generated processing profiles for the Asset Compute service.
Any modifications to existing workflow launchers and models are done in-place.

Disable Workflow Launchers

Workflow launchers that are determined to be used for asset processing will be disabled.  This will be done in-place, in the customer’s existing Maven project.  Note that in Assets in the Cloud environments, DAM Update Asset is automatically disabled.  For customers who have not created any custom launchers, no action needs to be taken in this area.

Create Processing Profiles

We will analyze all workflow models that are referenced by these disabled launchers and automatically generate Processing Profiles for the Asset Compute Service as needed.  Supported workflow step configuration settings will be used to determine configuration of the renditions to be requested.  The processing profile configurations will be added to the aem-cloud-migration.content project.  


Update Workflow Models

For each of these workflows, we will determine if the workflow has any custom steps or steps that are supported on Skyline.  If so, we will edit the workflow model in-place and remove any unsupported steps from it.  For workflows that do not contain any supported or custom steps, we will ignore them as they will not be executed on Assets in the Cloud.

For any workflow models that are determined to be “runnable”, we will ensure that they contain the DamUpdateAssetWorkflowCompleted workflow step.  This is to ensure that assets are marked as Processed when the workflow completes.  This is done so that the asset can remain in a Processing state while running through the customer’s custom processing steps. 

Create Custom DAM Workflow Runner configurations

For any workflow models that were modified in the model analysis, we will configure a configuration entry for the Custom DAM Workflow Runner OSGi service.  This service will execute the workflow model after we have completed Asset Compute Service processing of the asset (and potentially uploaded the asset to Scene7 and processed it through the Smart Tag service).








