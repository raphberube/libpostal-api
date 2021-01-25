FROM raph84/libpostal-python:release-1.1.1 AS python

#RUN cd / && git clone --single-branch --branch master  https://github.com/raph84/libpostal-api
COPY . /libpostal-api/
RUN pip3 install --default-timeout=100 -r /libpostal-api/requirements.txt

FROM python AS prod
RUN pip install Flask gunicorn

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
WORKDIR /libpostal-api
CMD exec gunicorn --log-level=debug --bind :$PORT --workers $WORKERS --threads 4 --timeout 0 api:app 


FROM prod AS dev

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

EXPOSE 8080