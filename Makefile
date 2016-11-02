##
## Makefile for Opal developpers
##
projects=$(HOME)/projects
version=2.7-SNAPSHOT
magma_version=1.14-SNAPSHOT
#version=2.6-SNAPSHOT
#magma_version=1.13-SNAPSHOT
commons_version=1.8-SNAPSHOT
java_opts="-Xms1G -Xmx4G -XX:MaxPermSize=256M -XX:+UseG1GC"

opal_project=${projects}/opal
magma_project=${projects}/magma
commons_project=${projects}/obiba-commons
opal_home=${projects}/opal-home

skipTests=false
mvn_exec=mvn -Dmaven.test.skip=${skipTests}
gradle_exec=${magma_project}/gradlew
orientdb_version=2.1.2

mysql_root=root
mysql_password=1234
opal_db=opal_dev
key_db=key_dev

#
# Compile Opal and prepare Opal server
#
all: clean compile server

#
# Clean Opal
#
clean:
	cd ${opal_project} && \
	${mvn_exec} clean

#
# Compile Opal
#
compile:
	cd ${opal_project} && \
	${mvn_exec} -U install

#
# Compile Opal without compiling GWT
#
compile-no-gwt:
	cd ${opal_project} && \
	${mvn_exec} install -Dgwt.compiler.skip=true

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
# Launch Opal GWT in debug mode (port 8001)
#
launch-gwt-debug:
	cd ${opal_project}/opal-gwt-client && \
	${mvn_exec} gwt:debug -Dgwt.debugPort=8001

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
	chmod +x ./scripts/opal && \
	export PYTHONPATH=${opal_project}/opal-python-client/target/opal-python/bin && \
	./scripts/opal ${args}

#
# Install Opal conf directory
#
conf:
	rm -rf conf data work logs && \
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
	${gradle_exec} build install && \
	cp target/libs/${p}-${magma_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Compile and install all Magma sub-projects
#
magma-all:
	cd ${magma_project} && \
	${gradle_exec} build install && \
	find ${opal_project}/opal-server/target/opal-server-${version}/lib -type f | grep magma | grep -v health-canada | grep -v geonames | xargs rm && \
	cp `find . -type f | grep jar$$ | grep -v sources | grep -v javadoc | grep -v jacoco` ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Compile and install a Commons sub-project
#
commons:
	cd ${commons_project}/${p} && \
	${mvn_exec} clean install && \
	cp target/${p}-${commons_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Compile and install all Commons sub-projects
#
commons-all:
	cd ${commons_project} && \
	${mvn_exec} clean install && \
	cp obiba-core/target/obiba-core-${commons_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp obiba-git/target/obiba-git-${commons_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp obiba-shiro/target/obiba-shiro-${commons_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp obiba-shiro-web/target/obiba-shiro-web-${commons_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib && \
	cp obiba-shiro-crowd/target/obiba-shiro-crowd-${commons_version}.jar ${opal_project}/opal-server/target/opal-server-${version}/lib

#
# Tail Opal log file
#
log:
	tail -f logs/opal.log

#
# Delete all log files
#
clear-log:
	rm logs/*

#
# Delete ES indexes
#
clear-data:
	rm -rf data/opal/*

clear-config:
	rm -rf data && \
	rm -rf conf && \
	rm -rf logs && \
	rm -rf work

check-updates:
	cd ${opal_project} && ${mvn_exec} versions:display-dependency-updates

check-plugin-updates:
	cd ${opal_project} && ${mvn_exec} versions:display-plugin-updates

check-magma-updates:
	cd ${magma_project} && ${gradle_exec} dependencyUpdates -Drevision=release

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

download-orientdb:
	mkdir -p work && \
	cd work && \
	wget "http://orientdb.com/download.php?email=unknown@unknown.com&file=orientdb-community-$(orientdb_version).zip&os=multi" -O orientdb-community-$(orientdb_version).zip && \
	unzip orientdb-community-$(orientdb_version).zip && \
	rm orientdb-community-$(orientdb_version).zip && \
	chmod a+x orientdb-community-$(orientdb_version)/bin/*.sh

orientdb-console:
	@echo
	@echo "To connect to Opal OrientDB:"
	@echo "  connect premote:localhost:2424/opal-config admin admin"
	@echo "or"
	@echo "  connect plocal:$(opal_home)/data/orientdb/opal-config admin admin"
	@echo
	@cd work/orientdb-community-$(orientdb_version)/bin && ./console.sh
