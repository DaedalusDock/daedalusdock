#!/bin/bash


md5sum -c - <<< "6fd98c16cc74226a409d43ddb2a4541f *html/changelogs/example.yml"
tools/bootstrap/python tools/changelog/ss13_genchangelog.py html/changelogs
