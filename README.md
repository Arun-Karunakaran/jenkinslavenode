### General Info:
Configuring a Jenkins slave node is an essential step in setting up a CI/CD automation process. <br />
Before doing this there are certain prerequisites that needs to be taken care, such as: <br /> 
>- ***Spinup node machine:*** Before adding a slave node to the Jenkins master we need to spinup and configure a slave node machine for performing the slave tasks.
>- ***Java installation:*** We need to install Java on the slave node machine. Jenkins will install a client program on the slave node. To run the client program we need to install a Java version. 
>-             Need JRE 1.8.0 minimum to be installed on the slave node.
>-             Go to Control Panel-> Programs -> Java(double click)-> Java Control Panel (Advanced)-> JNLP File Association -> Change to always allow.

**Manual Steps for configuring slave node:**<br />
- Log in to the Jenkins console via the browser and click on “Manage Jenkins” and scroll down to the bottom.
- From the list click on “Manage Nodes”. 
- In the new window click on “New Node”.
- There are various entry field check boxes such as remote root directory, credentials, Launch Method, Executors, labels etc.
- Once you save the new node setup by providing all the suggestions. You might still need to run an agent command on the remote machine. For which you need to download the jar from the master and also need to have jnlp setup on the remote machine to establish the connection.
- At times when the remote machine where the slave node is configured might go down or when you restart you might have to set this setup process of configuring the agent once again.

**Let’s Automatize it:**<br />
<br />
	To instantly configure Jenkins slave nodes on your work node machine, run the **configslavenodes.bat** script on your work node.

**How to use it:**<br />
- You can run the **configslavenodes.bat** script as the logged in user which will setup the remote machine over the Jenkins Server in a low elevated mode. 
- You can run the **configslavenodes.bat** script in an elevated command windows which will setup the remote machine over the Jenkins Server to run with admin privileges.

> **Usage:** <br />
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configslavenodes.bat <br /> <br />
  **_Usage Prompt:_** <br />
  &emsp; &emsp; &emsp; &emsp; &emsp; Username for Jenkins login? _<username>_ <br />
  &emsp; &emsp; &emsp; &emsp; &emsp; Password for Jenkins? _<password>_ <br />
  &emsp; &emsp; &emsp; &emsp; &emsp; Mention the jenkins url you need to connect _eg. http://<name>:8080? <http://jenkinsservername:8080>_ <br />
  &emsp; &emsp; &emsp; &emsp; &emsp; Tell the node name you want to create? _<nodename>_ <br />
  &emsp; &emsp; &emsp; &emsp; &emsp; No of executors required? _<1> or <2> or <n>_ <br />
> &emsp; &emsp; &emsp; &emsp; &emsp; Specify full path for configuring node? _eg. C:\Users\admin\Documents=> <path>_ <br />

**Logs:** <br />
```
Java Web Start 11.251.2.08
Using JRE version 1.8.0_251-b08 Java HotSpot(TM) Client VM
JRE expiration date: 8/17/20 12:00 AM
console.user.home = C:\Users\admin
----------------------------------------------------
c:   clear console window
f:   finalize objects on finalization queue
g:   garbage collect
h:   display this help message
m:   print memory usage
o:   trigger logging
p:   reload proxy configuration
q:   hide console
r:   reload policy configuration
s:   dump system and deployment properties
t:   dump thread list
v:   dump thread stack
0-5: set trace level to <n>
----------------------------------------------------
Feb 23, 2021 7:50:23 AM hudson.remoting.jnlp.Main createEngine
INFO: Setting up agent: usaueatest
Feb 23, 2021 7:50:23 AM hudson.remoting.Engine startEngine
INFO: Using Remoting version: 3.40
Feb 23, 2021 7:50:23 AM org.jenkinsci.remoting.engine.WorkDirManager initializeWorkDir
INFO: Using C:\Users\admin\Documents\remoting as a remoting work directory
Feb 23, 2021 7:50:23 AM org.jenkinsci.remoting.engine.WorkDirManager setupLogging
INFO: Both error and output logs will be printed to C:\Users\admin\Documents\remoting
Feb 23, 2021 7:50:23 AM org.jenkinsci.remoting.engine.JnlpAgentEndpointResolver resolve
INFO: Remoting server accepts the following protocols: [JNLP4-connect, Ping]
```
	
**Pros of using the configslavenodes.bat:**
1. User will be able to instantly setup Jenkins slave nodes anytime.
2. Reconfiguring the slave node on the same machine is easier (with same name or different name)
3. Deletes the existing service entries and registry entries created by other nodes on the machine and setups an entirely a new node as per user decides.
4. In an ansible environment where one decides to control several Windows machines / VM remotely through a Jenkins CLI / pipeline scripting, then all you need to do is to simply modify the .bat script to get parameters from command prompt.
5. A Jenkins slave node can also be configured during the runtime of jobs executions using external controls i.e. from an ansible system.
6. Based on the order of job execution in series, the same Jenkins slave node name can be used for mapping to different machines / VM’s, by invoking the confislavenodes.bat to be run after each job on different VM’s listed in a series order, and by controlling it externally using an ansible playbooks.
7. For parallel execution of jobs this bat script can be used for configuring the slave node prior running Jenkins jobs on a desired machines . It cannot be used to configure on runtime in a parallel execution of Jenkins jobs.
8. This way of configuring also limits the use of unnecessary Jenkins slave node configurations and eases the maintenance of slave nodes over Jenkins.
