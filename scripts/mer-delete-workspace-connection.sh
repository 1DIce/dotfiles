#!/usr/bin/env bash

 find . -type f -name 'de.cas.merlin.product.model.common.prefs' | head -n1 | xargs sed -i '/PersonalRemoteWorkspace=.*$/d'
