magma_project=$(HOME)/projects/magma
opal_project=$(HOME)/projects/opal
version=1.11-SNAPSHOT
magma_version=1.3-SNAPSHOT
java_opts="-Xmx1G -XX:MaxPermSize=256M"
opal_home=$(HOME)/opal-home

all: compile server

compile:
	cd ${opal_project} && \
	mvn clean install

update:
	cd ${opal_project} && \
	git pull

server:
	cd ${opal_project}/opal-server/target && \
	unzip opal-server-${version}-dist.zip

launch:
	cd ${opal_home} && \
	export OPAL_HOME=${opal_home} && \
	export JAVA_OPTS=${java_opts} && \
	${opal_project}/opal-server/target/opal-server-${version}/bin/opal --upgrade

conf:
	rm -rf conf data work logs
	cp -r ${opal_project}/opal-server/target/opal-server-${version}/conf .

opal:
	cd ${opal_project}/${p} && \
	mvn clean install && \
	cp target/${p}-${version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

magma-update:
	cd ${magma_project} && \
	git pull

magma:
	cd ${magma_project}/${p} && \
	mvn clean install && \
	cp target/magma-${p}-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

log:
	tail -f logs/opal.log

