A Jenkins slave, ready to run with the dslabci.epfl.ch

To build this Docker container, run::

    $ git clone https://github.com/Sjlver/jenkins-slave
    $ cd jenkins-slave
    $ docker.io build -t Sjlver/jenkins-slave .

To use this, run it as::

    $ docker.io run -d --name="asap_jenkins_slave" -p 10022:22 sjlver/jenkins-slave

Once it runs, connect using SSH::

    $ ssh -p 10022 jenkins@<host>

When you're connected, you will need to set up whatever you build host needs to
work. This probably includes compilers and other tools. Have a look at the
`scripts` folder for inspiration.

You also need to ensure that your host has access to the repos it needs; for
this, copy the corresponding SSH key to `/home/jenkins/.ssh`.

In the Jenkins web interface, you can then add a new slave as follows:

- Manage Jenkins > Nodes > New Node
- Add a new "dumb node"
- Give your node a title, a label, etc.
- Select launch method: "Launch slave agents on Unix machines via SSH"
- Enter the host name where your container is running. Click on "Advanced" and
  enter the port (10022 in our example). For credentials, choose the Jenkins
  SSH key.
