#!/usr/bin/env bash

# Flutter formatter
printf "\e[33;1m%s\e[0m\n" '=== Running Dart Formatter ==='
dart format .
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter Formatter'
printf '%s\n' ""

# Flutter Analyzer
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter analyzer ==='
flutter analyze
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Flutter analyzer error ==='
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter analyzer'
printf '%s\n' ""
