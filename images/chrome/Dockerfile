FROM ubuntu:18.04

RUN useradd chrome-user \
 && mkdir /home/chrome-user \
 && chown chrome-user:chrome-user /home/chrome-user

RUN apt-get update \
 && apt-get install -y gnupg wget \
 && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
    | apt-key add - \
 && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' \
    | tee /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update \
 && apt-get install -y google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

USER chrome-user
CMD /usr/bin/google-chrome-stable