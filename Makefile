##
## Makefile for Opal developpers
##
projects=$(HOME)/projects
version=1.12-SNAPSHOT
magma_version=1.3-SNAPSHOT
java_opts="-Xmx1G -XX:MaxPermSize=256M"

opal_project=${projects}/opal
magma_project=${projects}/magma
opal_home=${projects}/opal-home

skipTests=false
mvn_exec=mvn -Dmaven.test.skip=${skipTests}

#
# Compile Opal and prepare Opal server
#
all: compile server python-client

#
# Compile Opal
#
compile:
	cd ${opal_project} && \
	${mvn_exec} clean install

#
# Update Opal source code
#
update:
	cd ${opal_project} && \
	git pull

#
# Unzip Opal distribution
#
server:
	cd ${opal_project}/opal-server/target && \
	unzip opal-server-${version}-dist.zip

#
# Unzip Python client
#
python-client:
	cd ${opal_project}/opal-python-client/target && \
	unzip opal-python_${version}.zip && \
	chmod +x opal-python/bin/opal.py

#
# Launch Opal
#
launch:
	cd ${opal_home} && \
	export OPAL_HOME=${opal_home} && \
	export JAVA_OPTS=${java_opts} && \
	sed -i 's/^java $$JAVA_OPTS $$JAVA_DEBUG/java $$JAVA_OPTS/g' ${opal_project}/opal-server/target/opal-server-${version}/bin/opal && \
	${opal_project}/opal-server/target/opal-server-${version}/bin/opal

#
# Launch Opal in debug
#
launch-debug:
	cd ${opal_home} && \
	export OPAL_HOME=${opal_home} && \
	export JAVA_OPTS=${java_opts} && \
	sed -i 's/^java $$JAVA_OPTS $$JAVA_DEBUG/java $$JAVA_OPTS/g' ${opal_project}/opal-server/target/opal-server-${version}/bin/opal && \
	sed -i 's/^java $$JAVA_OPTS/java $$JAVA_OPTS $$JAVA_DEBUG/g' ${opal_project}/opal-server/target/opal-server-${version}/bin/opal && \
	${opal_project}/opal-server/target/opal-server-${version}/bin/opal

#
# Launch Opal GWT
#
launch-gwt:
	cd ${opal_project}/opal-gwt-client && \
	${mvn_exec} gwt:run

#
# Launch Rserve daemon
#
launch-Rserve:
	R CMD Rserve --vanilla

#
# Execute a R script
#
launch-R:
	R --vanilla < ${R}

#
# Execute Python client
#
launch-python:
	cd ${opal_project}/opal-python-client/target/opal-python/bin && \
	./opal.py ${args}

#
# Install Opal conf directory
#
conf:
	rm -rf conf data work logs
	cp -r ${opal_project}/opal-server/src/main/conf .

#
# Compile and install a Opal sub-project
#
opal:
	cd ${opal_project}/${p} && \
	${mvn_exec} clean install && \
	cp target/${p}-${version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Update Magma source code
#
magma-update:
	cd ${magma_project} && \
	git pull

#
# Compile and install a Magma sub-project
#
magma:
	cd ${magma_project}/${p} && \
	${mvn_exec} clean install && \
	cp target/magma-${p}-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Compile and install a Magma Hibernate sub-projects
#
magma-hibernate:
	cd ${magma_project}/hibernate && \
	${mvn_exec} clean install && \
	cp hibernate-audit/target/magma-hibernate-audit-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate-common/target/magma-hibernate-common-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate-datasource/target/magma-hibernate-datasource-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Tail Opal log file
#
log:
	tail -f logs/opal.log
