#!/bin/bash
exec du "${@--xd1}" -h | sort -h
