#!/usr/bin/env bash

JAVA_VERSION=17
DEBUG_PORT=5005
WINDOWS_USER_HOME=$(cygpath -w ~)
JDT_LS_WORKSPACE="$HOME\.local\share\java\eclipse\ruby"

~/.local/share/java/$JAVA_VERSION/bin/java.exe \
    -XX:+ShowCodeDetailsInExceptionMessages \
    -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=127.0.0.1:$DEBUG_PORT \
    -Dorg.eclipse.swt.graphics.Resource.reportNonDisposed=true \
    -Dfile.encoding=UTF-8 \
    -Dosgi.configuration.area=$WINDOWS_USER_HOME/AppData/Local/CAS/Merlin/10.17.0-product/configuration \
    -Duser.language=de \
    -Dorg.eclipse.update.reconcile=false \
    -DKeycloakServerCheckTimeout=15 \
    -Xms128M \
    -Xmx2048M \
    --add-modules=ALL-SYSTEM \
    -classpath "$HOME\.local\share\java\eclipse\ruby\.metadata\.plugins\org.eclipse.pde.core\.bundle_pool\plugins\org.eclipse.equinox.launcher_1.5.100.v20180827-1352.jar" org.eclipse.equinox.launcher.Main \
    -launcher "$HOME\.local\share\java\eclipse\ruby\.metadata\.plugins\org.eclipse.pde.core\.bundle_pool\eclipse.exe" \
    -name Eclipse \
    -showsplash 600 \
    -product de.cas.merlin.product.model.vario.MModelProduct \
    -data "$HOME\.local\share\java\eclipse\ruby/../runtime-MModel.product" \
    -configuration file:$WINDOWS_USER_HOME/.local/share/java/eclipse/ruby/.metadata/.plugins/org.eclipse.pde.core/MModel.product/ \
    -dev file:$WINDOWS_USER_HOME/.local/share/java/eclipse/ruby/.metadata/.plugins/org.eclipse.pde.core/MModel.product/dev.properties \
    -os win32 \
    -ws win32 \
    -arch x86_64 \
    -nl de_DE \
    -consoleLog \
    -vm ./jre/bin \
    -data @noDefault \
    -clearPersistedState
