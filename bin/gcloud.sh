#!/usr/bin/env bash

if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
	gcloud components install gke-gcloud-auth-plugin
else
	gcloud components install gke-gcloud-auth-plugin >/dev/null 2>&1
fi
