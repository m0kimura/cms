FROM ubuntu:14.04

EXPOSE 80 443
ARG user=${user:-docker}

RUN apt-get update -y && \
    apt-get -y install language-pack-ja-base language-pack-ja ibus-mozc \
      fonts-takao-mincho fonts-takao \
      git nano sudo \
      nodejs npm && \
    update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10 && \
    rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    export LANG=ja_JP.UTF-8 && export LC_MESSAGES=ja_JP.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g forever && \
    export uid=1000 gid=1000 && \
    mkdir -p /home/${user} && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user} && \
    chown ${uid}:${gid} -R /home/${user}

COPY init.sh /home/${user}/init.sh
RUN cd /home/${user} && git clone https://github.com/m0kimura/web-project

VOLUME /home/${USER}
VOLUME /home/${USER}/web-project/html

WORKDIR /home/${user}
USER ${user}
CMD ./init.sh
