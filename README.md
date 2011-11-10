Simple script to start / stop a Jackrabbit server.

Author: D. Barsotti <daniel.barsotti@liip.ch>, B. Widmer <bastian.widmer@liip.ch>

Introduction
============
This relies on a PID file to check if Jackrabbit is running or not.
If you kill Jackrabbit without removing the PID file, you will not be
start Jackrabbit with this script before you manually removed the PID
file.

JMX Monitoring
==============
The default JMX-Port for monitoring is set to 1111.
You have to copy the jmx.user.template and jmx.group.template to the directory where your
Jackrabbit JAR file is stored and remove the .template suffix

In the User file you should specify a different password for your admin user.

Memory Settings
===============
You can Tweak the Memory Settings with the Values Xmx (Maximal Memory) Xms (Start Memory)
and MaxPermSize (Size of Maximum permanent generation heap)
