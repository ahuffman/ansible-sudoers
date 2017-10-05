FROM fedora:latest

ENV container="docker"

RUN dnf clean all \
 && dnf makecache \
 && dnf install -y \
	curl \
	findutils \
	gcc \
	glibc-langpack-en.x86_64  \
	libffi-devel \
	net-tools \
	openssh-server \
	openssl-devel \
	python2-devel \
	python2-pip \
	redhat-lsb \
	redhat-rpm-config \
	sudo \
	systemd \
 && pip install --upgrade pip \
 && dnf clean all \
 && login_shell=$(command -v bash) \
 && if ! getent passwd <%= @username %>; then \
      useradd -u 9000 -d /home/<%= @username %> -m -s "${login_shell}" -p '*' <%= @username %>; \
    fi \
 && echo "<%= @username %> ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kitchen \
 && chmod 440 /etc/sudoers.d/kitchen \
 && echo "Defaults !requiretty" >> /etc/sudoers \
 && mkdir -p /home/<%= @username %>/.ssh \
 && chown -R <%= @username %> /home/<%= @username %>/.ssh \
 && chmod 0700 /home/<%= @username %>/.ssh \
 && echo '<%= IO.read(@public_key).strip %>' >> /home/<%= @username %>/.ssh/authorized_keys \
 && chown <%= @username %> /home/<%= @username %>/.ssh/authorized_keys \
 && chmod 0600 /home/<%= @username %>/.ssh/authorized_keys \
 && export LANG="en_US.UTF-8" && echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf \
 && cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
 && rm -f /lib/systemd/system/multi-user.target.wants/* \
 && rm -f /etc/systemd/system/*.wants/* \
 && rm -f /lib/systemd/system/local-fs.target.wants/* \
 && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
 && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
 && rm -f /lib/systemd/system/basic.target.wants/* \
 && rm -f /lib/systemd/system/anaconda.target.wants/*  \
 && rm -f /lib/systemd/system/plymouth* \
 && rm -f /lib/systemd/system/systemd-update-utmp* \
 && sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?UsePrivilegeSeparation\s+.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config \
 && echo "UseDNS=no" >> /etc/ssh/sshd_config \
 && systemctl set-default multi-user.target \
 && ln -s /lib/systemd/system/systemd-journald.service /etc/systemd/system/multi-user.target.wants/systemd-journald.service \
 && ln -s /lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/sshd.service \
 && echo $'[Unit]\
\nDescription=Finish boot up\
\nAfter=ssh.service\
\n\
\n[Service]\
\nType=oneshot\
\nRemainAfterExit=yes\
\nExecStartPre=/bin/sleep 3s\
\nExecStart=/bin/rm -f /run/nologin\
\n\
\n[Install]\
\nWantedBy=default.target' >> /etc/systemd/system/FinishBootUp.service \
 && ln -s /etc/systemd/system/FinishBootUp.service /etc/systemd/system/multi-user.target.wants/FinishBootUp.service


EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
