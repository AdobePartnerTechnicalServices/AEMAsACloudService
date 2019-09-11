# Using Dispatcher Configuration Validator

## Table of Contents

  
  - [Table of Contents](#table-of-contents)
  - [Scenario Overview](#scenario-overview)
  - [Key Takeaways](#key-takeaways)
 - [Pre-requisites](#pre-requisites)
  - [Lesson 1 - Setting up Docker](#lesson-1---setting-up-docker)
  - [Lesson 2 - Setup Dispatcher SDK Validator](#lesson-2---setup-dispatcher-sdk-validator)
  - [Lesson 3 - Run Dispatcher SDK Validator](#lesson-3---run-dispatcher-sdk-validator)


## Scenario Overview

Checking in invalid dispatcher configurations will interrupt the Cloud Manager pipeline. So, we need to check in  code only after validating them locally. Adobe has provided Dispatcher SDK Validator for validating configurations locally.

The Dispatcher SDK provides:

* Dispatcher Configuration : a vanilla file structure containing the configuration files to include in a maven project for dispatcher
* Dispatcher Validator: tooling for customers to validate a dispatcher configuration locally
* Dispatcher Docker Image: a Docker image that brings up the dispatcher locally

The validation tool is available in the SDK as a macOS or Linux binary.

It allows customers to run the same validation that Cloud Manager will perform while building and deploying a release.

### Key Takeaways

* Setup Dispatcher SDK Validator
* Use Dispatcher SDK Validator to validate dispatcher Configureations


### Pre-requisites

* AEM Project with Dispatcher Configurations

## Lesson 1 - Setting up Docker

1. Install Docker for Mac (https://docs.docker.com/v17.12/docker-for-mac/install/) or to Windows (https://docs.docker.com/v17.12/docker-for-windows/install/)

2. **[INTERNAL ONLY]** SSO to https://artifactory-uw2.adobeitc.com and create an API key that will be used in the next section
3. To create an API key, click on your user name on the top right 
Onthe profile
4. create a new API key. 

![SSO](./sso.jpg)

```
docker login docker2-granite-release-local.dr-uw2.adobeitc.com 
Username : <ldapid>
Password: < Paste Token >

```
## Lesson 2 - Setup Dispatcher SDK Validator

1. Copy DispacthcerSDKv1.0.2sh to a folder
2. Open Terminal in the folder and add executable permission to .sh file
```
chmod +x DispacthcerSDKv1.0.2sh
```

## Lesson 3 - Create Dispatche Configuration

### Lesson Context
In skyline the dispatcher configurations will be installed on to the container through Cloud Manager. Hence the dispatcher configurations must be checked in into the code along with the AEM Code. Dispatcher is going to become another module.

1. Create a folder called "dispatcher" as a sibling of "core" "ui.apps" etc.
2. Create a subfolder called "src" underneatch the dispatcher
3. Create two sub folders called config.d and config.dispatcher.d under src
4. Organize the files in those folders as outlined following :

```
./
├── conf.d
│   ├── available_vhosts
│   │   └── default.vhost
│   ├── dispatcher_vhost.conf
│   ├── enabled_vhosts
│   │   ├── README
│   │   └── default.vhost -> ../available_vhosts/default.vhost
│   └── rewrites
│   │   ├── default_rewrite.rules
│   │   └── rewrite.rules
│   └── variables
|       ├── custom.vars
│       └── global.vars
└── conf.dispatcher.d
    ├── available_farms
    │   └── default.farm
    ├── cache
    │   ├── default_invalidate.any
    │   ├── default_rules.any
    │   └── rules.any
    ├── clientheaders
    │   ├── clientheaders.any
    │   └── default_clientheaders.any
    ├── dispatcher.any
    ├── enabled_farms
    │   ├── README
    │   └── default.farm -> ../available_farms/default.farm
    ├── filters
    │   ├── default_filters.any
    │   └── filters.any
    ├── renders
    │   └── default_renders.any
    └── virtualhosts
        ├── default_virtualhosts.any
        └── virtualhosts.any
```
Refer [Dispatcher Config](DispatcherConfig.md) for more details.

5. In Dispatcher Folder, create pom.xml
6. Add following code to pom.xml and change parent as per your project name.

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <!-- ====================================================================== -->
    <!-- P A R E N T P R O J E C T D E S C R I P T I O N -->
    <!-- ====================================================================== -->
    <parent>
        <groupId>com.deloitte.digital</groupId>
        <artifactId>dd</artifactId>
        <version>1.10.2-SNAPSHOT</version>
        <relativePath>../pom.xml</relativePath>
    </parent>
 
    <artifactId>dd-dispatcher</artifactId>
    <packaging>pom</packaging>
    <name>${project.groupId} - ${project.artifactId}</name>
 
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>3.1.0</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals><goal>single</goal></goals>
                        <configuration>
                            <descriptors>
                                <descriptor>assembly.xml</descriptor>
                            </descriptors>
                            <appendAssemblyId>false</appendAssemblyId>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>

```

7. Add assembly.xml and update with following code
   ```
    <assembly xmlns="http://maven.apache.org/ASSEMBLY/2.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.0.0 http://maven.apache.org/xsd/assembly-2.0.0.xsd">
    <id>distribution</id>
    <formats>
        <format>zip</format>
    </formats>
    <includeBaseDirectory>false</includeBaseDirectory>
    <fileSets>
        <fileSet>
            <directory>${basedir}/src</directory>
            <includes>
                <include>**/*</include>
            </includes>
            <outputDirectory></outputDirectory>
        </fileSet>
    </fileSets>
</assembly>
   ```

9. Add dispatcher module to parent pom.xml
```
<project  xmlns="http://maven.apache.org/POM/4.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
.
.
    <modules>
        <module>core</module>
        <module>dispatcher</module>
        .
        .
    </modules>
</project>

```
10.  Run followinng command to validate the package successfully both at the dispatcher folder level as well as parent level
    ```
    $> mvn clean install
    ```


## Lesson 4 - Run Dispatcher SDK Validator

1. Run Validator by executing following command

```
./bin/validator full -d out ~/AEMProjectDirectory/dd-dispatcher/src

```

You should get following 
![Terminal Output](validator-terminal.png)

Step 2. If needed make changes to dispatcher configurations and Re-run step 6.