
# Replication

### Scenario Roadmap

With AEM Cloud Service, the well known replication framework (used from 5.0-6.5) is no longer used to publish pages. Instead it uses the Distribution (Sling Content Distribution) capability to move the content to a pipeline service run on Adobe I/O that is outside of the AEM runtime. 

The setup is automated and also auto-configures itself during runtime when when publish nodes are added or removed. Further when author server nodes are add or removed or recycled.

Publication/Unpublication is atomic, in that a single un/publication request will succeed for all resources in the AEM Publish Service, or fail for all. The resources within the AEM Publish Service will never be in a inconsistent state.

#### Lesson Context


