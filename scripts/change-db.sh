#!/usr/bin/env bash


gitRootDir=$(git rev-parse --show-toplevel)

version=$(printf 'master\nlts-11-0\nlts-10-10' | fzf)

keycloakConf="$gitRootDir/../Keycloak/conf/keycloak.conf"
sed -i "s/;databaseName=keycloak$/;databaseName=keycloak-$version/" "$keycloakConf"

tomcatConf="$gitRootDir/maven/bundle/tomcat-conf-eclipse/merlin.settings"
sed -i "s/;databaseName=merlin$/;databaseName=merlin-$version/" "$tomcatConf"
