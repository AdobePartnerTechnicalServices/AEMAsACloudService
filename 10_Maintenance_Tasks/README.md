
# Maintenance Tasks

### Scenario Roadmap

In 6.x, the admin UI's Maintenance card (Tools > Operations > Maintenance) provided a means to configure Maintenance Tasks. It linked to ` /system/console/configMgr `, which persisted various configurations to the repository. For 
Adobe Expereince Manager, the Maintenance card will not be accessible and so configuration should be committed to source control and deployed via Cloud Manager. 

Going ahead Maintenance Tasks, can be divided into two main categories: 

1. Adobe Managed Maintenance Tasks i.e. Adobe fully manages MTs that don't require any customer decisioning. For example, Datastore Garbage Collection, Lucene Binaries Cleanup, Revision Cleanup

2. Shared Maintenance Tasks i.e. Maintenance Tasks configurations that can be shared between Adobe and the customer. Customer owns a subset of properties (e.g. number of versions) and the
maintenance window is owned by Adobe. For example, version purge, project purge, workflow purge

| 6.5 Maintenance Task         | Who owns configuration | How to manage configuration       |
|------------------------------|------------------------|-----------------------------------|
| Datastore garbage collection | Adobe                  | N/A - Adobe Owned                 |
| Version Purge MT             | Shared                 | UI removed so must be done in git |
| Audit Log Purge              | Shared                 | UI removed so must be done in git |
| Lucene Binaries cleanup      | Removed from Skyline   | N/A - removed                     |
| Ad-hoc Task Purge            | Shared                 | UI removed so must be done in git |
| Workflow Purge               | Shared                 | UI removed so must be done in git |
| Project Purge                | Shared                 | UI removed so must be done in git |


#### Lesson Context

In this scenario we will configure and schedule Maintenance Tasks for Skyline Author Instance

1. 
