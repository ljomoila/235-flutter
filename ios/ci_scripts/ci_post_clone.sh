#!/bin/bash
set -e

cd "$CI_WORKSPACE/ios"
pod install --repo-update