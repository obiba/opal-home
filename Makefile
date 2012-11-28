#
# Makefile for Opal developpers
#
projects=$(HOME)/projects
version=1.11-SNAPSHOT
magma_version=1.3-SNAPSHOT
java_opts="-Xmx1G -XX:MaxPermSize=256M"

opal_project=${projects}/opal
magma_project=${projects}/magma
opal_home=${projects}/opal-home

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
	sed -i 's/^java $$JAVA_OPTS $$JAVA_DEBUG/java $$JAVA_OPTS/g' ${opal_project}/opal-server/target/opal-server-${version}/bin/opal && \
	${opal_project}/opal-server/target/opal-server-${version}/bin/opal --upgrade

launch-debug:
	cd ${opal_home} && \
	export OPAL_HOME=${opal_home} && \
	export JAVA_OPTS=${java_opts} && \
	sed -i 's/^java $$JAVA_OPTS $$JAVA_DEBUG/java $$JAVA_OPTS/g' ${opal_project}/opal-server/target/opal-server-${version}/bin/opal && \
	sed -i 's/^java $$JAVA_OPTS/java $$JAVA_OPTS $$JAVA_DEBUG/g' ${opal_project}/opal-server/target/opal-server-${version}/bin/opal && \
	${opal_project}/opal-server/target/opal-server-${version}/bin/opal --upgrade

conf:
	rm -rf conf data work logs
	cp -r ${opal_project}/opal-server/src/main/conf .

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

magma-hibernate:
	cd ${magma_project}/hibernate && \
	mvn clean install && \
	cp hibernate-audit/target/magma-hibernate-audit-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate-common/target/magma-hibernate-common-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate-datasource/target/magma-hibernate-datasource-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

log:
	tail -f logs/opal.log

