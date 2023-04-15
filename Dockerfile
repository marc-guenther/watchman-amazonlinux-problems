#FROM amazonlinux:2
FROM amazonlinux:2023

# upgrade everything
RUN yum -y update && yum clean all && rm -rf /var/cache/yum

# begin: install watchman

# # Unfortunately, this repo has been removed
# RUN curl -L https://download.opensuse.org/repositories/home:crantila:watchman/CentOS_7/home:crantila:watchman.repo >/etc/yum.repos.d/watchman.repo
# RUN yum -y install watchman
# RUN mkdir /var/run/watchman
# RUN chmod 2777 /var/run/watchman

# Installing the binary fails due to old glibc:
# watchman: /lib64/libm.so.6: version `GLIBC_2.29' not found (required by watchman)
# watchman: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.26' not found (required by watchman)
RUN curl -OL https://github.com/facebook/watchman/releases/download/v2023.04.10.00/watchman-v2023.04.10.00-linux.zip
RUN yum install -y unzip
RUN unzip watchman-*-linux.zip
RUN mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman
RUN cp watchman-v*.*.*.*-linux/bin/* /usr/local/bin
RUN cp watchman-v*.*.*.*-linux/lib/* /usr/local/lib
RUN chmod 755 /usr/local/bin/watchman
RUN chmod 2777 /usr/local/var/run/watchman
RUN yum install -y openssl11

# end: install watchman

# a script to test that watchman is correctly installed and functioning
RUN echo ./test-watchman.sh >/root/.bash_history
COPY test-watchman.sh .
