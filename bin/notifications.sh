#!/usr/bin/env bash

defaults write com.apple.notificationcenterui bannerTime 15
killall NotificationCenter
