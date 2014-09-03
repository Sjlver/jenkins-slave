A Jenkins slave, ready to run with the dslabci.epfl.ch

To use this, run it as::

    $ docker.io run -d -P sjlver/jenkins-slave
    $ docker.io ps -a

Note the port. Add a Jenkins slave with that hostname and port.
