# Working with Cloud Ready Quickstart

## Table of Contents
* [Senario Overview](#scenario-overview)
* [Lesson 1 - Download & Install Cloud Ready Quickstart](#lesson-1---Download-&-Install-Cloud-Ready-Quickstart)
* [Lesson 2 - Create Project & Deploy to AEM ](#lesson-2---Create-AEM-Project-for-Cloud-Ready-Quickstart)

## Scenario Overview
As AEM Cloud will be upgrading frequently with daily patches,feature releases etc. If we need to develop against most recent version of AEM CLoud locally we will need to download Cloud Ready Quickstart.

The quictstart jar version is subject to change very frequently . There is a corresponding global-apis jar which must be used as a dependency in the AEM Project pom files for compile time. And deploy the built artifact into the skyline quickstart based AEM instance for testing before pushing the code to GIT connected with the Cloud Manager which will eventually deploy the code to the target skyline instance(s)

### Key Takeaways

* Setup Local development Environment
* Use Cloud Ready Quickstart Global API for Project

### Pre-requisites

* Maven setup with setting.xml ponting to Adobe Repository
* License File For AEM

## Lesson 1 - Download & Install Cloud Ready Quickstart

### Lesson Context
In this lesson we will learn how to download and setup local AEM Environment using Cloud Ready Quickstart

#### Exercise 1.1
1. Go to [Cloud Ready Quickstart Artifactory](https://artifactory.corp.adobe.com/artifactory/maven-aem-release-local/com/day/cq/cq-quickstart-cloudready/V16061/)

* Note : This is internal link, we should have public link by GA 

2. Find the latest version released (It should be at end of the page) and click to see list of available jars,docs,files etc for the version.
3. Download jar file which should be named as *cq-quickstart-cloudready-V16068.jar* - Version name will be different
4. Put the downloaded jar file and license file in one folder.
5.  Run following command to unpack and start
   ```
   $> java -jar cq-quickstart-cloudready-V16061.jar -unpack
   $> cd cq-quickstart/bin
   $> ./start
   $> tail -f ../logs/error.log

   ```     
6. Go to http://localhost:4502 to verify running AEM. ( Port may change if 4502 is already occupied, You may check logs files to know the current port on which AEM is running.)


## Lesson 2 - Create AEM Project for Cloud Ready Quickstart
 
### Lesson Context
In this lesson we will to create AEM project and update it for Cloud Ready Quickstart.

#### Exercise 2.1
1. Create a new project using Archetype
    ```
    mvn archetype:generate \
        -DarchetypeGroupId=com.adobe.granite.archetypes \
        -DarchetypeArtifactId=aem-project-archetype \
        -DarchetypeVersion=20
        ```
2. Once the project is generated , Go to parent pom.xml add following dependencies.

```
<dependency>
    <groupId>com.day.cq</groupId>
    <artifactId>cq-quickstart-cloudready</artifactId>
    <version>V16061</version>
    <classifier>global-apis</classifier>
    <scope>provided</scope>
</dependency>

```
3. Deploy the project
   ```
   $> cd projectfoldername
   $> mvn clean install -PautoInstallPackage

   ```

4. Go to AEM > Sites and verify your newly created site in AEM.

## Additional Resources
* Source of Information [Wiki - Local AEM (Skyline) Setup]([LinkURL](https://wiki.corp.adobe.com/display/aememergingtech/Local+AEM+%28Skyline%29+Setup))