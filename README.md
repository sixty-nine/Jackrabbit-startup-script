Simple script to start / stop a Jackrabbit server.

Author: D. Barsotti <daniel.barsotti@liip.ch>, B. Widmer <bastian.widmer@liip.ch>

Introduction
============
This relies on a PID file to check if Jackrabbit is running or not.
If you kill Jackrabbit without removing the PID file, you will not be
able to start Jackrabbit with this script before you manually removed
the PID file.

Installation
============

    # Get the code
    mkdir -p /opt/jackrabbit-startup    # or wherever you want to put the code
    cd /opt/jackrabbit-startup
    git clone https://github.com/sixty-nine/Jackrabbit-startup-script.git
    # Configure the script
    ## <edit jackrabbit.sh to configure some settings> ##
    # Create JMX config files
    cp jmx.role.template jmx.role
    cp jmx.user.template jmx.user
    chmod 0600 jmx.role
    chmod 0600 jmx.user
    # Create an alias to the script
    ln -s /opt/jackrabbit-startup/jackrabbit.sh /etc/init.d/jackrabbit
    chmod 755 /etc/init.d/jackrabbit
    # on debian, register with
    update-rc.d jackrabbit defaults
    # if not using a system that provides update-rc.d, you hopefully know how
    # to proceed...

Usage
=====

The service should be started and stopped automatically from now on. 

If you ever want to control it manually, you can run

    /etc/init.d/jackrabbit start|stop|status

If you have a pid file blocking startup, you can just stop and then start
jackrabbit again. You will get an error on stop that you can ignore.

    /etc/init.d/jackrabbit stop
    /etc/init.d/jackrabbit start


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

