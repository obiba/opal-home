##
## Makefile for Opal developpers
##
projects=$(HOME)/projects
version=1.13-SNAPSHOT
magma_version=1.5-SNAPSHOT
java_opts="-Xmx1G -XX:MaxPermSize=256M"

opal_project=${projects}/opal
magma_project=${projects}/magma
opal_home=${projects}/opal-home

skipTests=false
mvn_exec=mvn -Dmaven.test.skip=${skipTests}

mysql_root=root
mysql_password=1234
opal_db=opal_dev
key_db=key_dev

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
# Compile and install all Magma sub-projects
#
magma-all:
	cd ${magma_project} && \
	${mvn_exec} clean install && \
	cp api/target/magma-api-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp beans/target/magma-beans-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp crypt/target/magma-crypt-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp datasource-limesurvey/target/magma-datasource-limesurvey-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp datasource-null/target/magma-datasource-null-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp datasource-spss/target/magma-datasource-spss-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp filter/target/magma-filter-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate/hibernate-audit/target/magma-hibernate-audit-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate/hibernate-common/target/magma-hibernate-common-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp hibernate/hibernate-datasource/target/magma-hibernate-datasource-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp integration/target/magma-integration-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp js/target/magma-js-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp math/target/magma-math-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp security/target/magma-security-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp spring/target/magma-spring-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

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

#
# Dump MySQL databases
#
sql-dump: sql-opal-dump sql-key-dump

sql-opal-dump:
	mysqldump -u $(mysql_root) --password=$(mysql_password) --hex-blob --max_allowed_packet=1G $(opal_db) > $(opal_db)_$(version)_dump.sql
	
sql-key-dump:
	mysqldump -u $(mysql_root) --password=$(mysql_password) $(key_db) > $(key_db)_$(version)_dump.sql

#
# Drop databases and import SQL dump
#
sql-import: sql-opal-import sql-key-import

sql-opal-import:
	mysql -u $(mysql_root) --password=$(mysql_password) -e "drop database `$(opal_db)`; create database `$(opal_db)`;" && \
	mysql -u $(mysql_root) --password=$(mysql_password) `$(opal_db)` < $(opal_db)_$(version)_dump.sql
	
sql-key-import:
	mysql -u $(mysql_root) --password=$(mysql_password) -e "drop database `$(key_db)`; create database `$(key_db)`;" && \
	mysql -u $(mysql_root) --password=$(mysql_password) `$(key_db)` < $(key_db)_$(version)_dump.sql
