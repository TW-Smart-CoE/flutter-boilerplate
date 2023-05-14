#!/usr/bin/env bash

# Unit tests
printf "\e[33;1m%s\e[0m\n" '=== Running Unit Tests ==='
flutter test
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Unit tests error ==='
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Unit Tests'
printf '%s\n' ""
