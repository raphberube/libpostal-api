FROM python:3.8-buster AS python

WORKDIR /
RUN  apt-get update && apt-get install -y git && \
     apt-get -y install curl autoconf automake libtool pkg-config && \
     git clone https://github.com/openvenues/libpostal && \
     cd libpostal && \
     ./bootstrap.sh && \
     ./configure --datadir=/libpostal_data && \
     make -j4 && \
     make install && \
     ldconfig && \ 
     rm -rf /var/lib/apt/lists/* && \
     cd / && \ 
     /bin/bash -c "pip install postal"

RUN cd / && git clone --single-branch --branch master https://github.com/raph84/libpostal-api
RUN pip3 install --default-timeout=100 -r /libpostal-api/requirements.txt

FROM python AS dev

RUN   apt-get update && apt-get install -y openssh-server && \
      rm -rf /var/lib/apt/lists/* && \
      mkdir /var/run/sshd && \
      echo 'root:password' | chpasswd && \
      sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
      sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose SSH
EXPOSE 22