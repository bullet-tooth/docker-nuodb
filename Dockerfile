FROM ubuntu:latest

#java 8 and supervisor
RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    apt-get install oracle-java8-installer -y --force-yes  && \
    apt-get install oracle-java8-set-default && \
	apt-get install -y supervisor && \
	apt-get clean


ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle


# add the nuodb package to the image and run the install
RUN wget -O /tmp/nuodb-distro.deb http://download.nuohub.org/nuodb-ce_2.6.1.5_amd64.deb && \
    /usr/bin/dpkg -i /tmp/nuodb-distro.deb && \
    rm /tmp/nuodb-distro.deb

# copy the supervisor conf file into the image
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add a wrapper that will stage all properties and use it on entry
ADD run.sh /tmp/
RUN /bin/chmod +x /tmp/run.sh
CMD /tmp/run.sh
