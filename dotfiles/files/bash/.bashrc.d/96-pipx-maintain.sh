#!/usr/bin/env bash

if [ -f /run/.containerenv ] && [ -f /run/.toolboxenv ]; then
	if command -v pipx &>/dev/null; then
		if command -v pipx-maintain &>/dev/null; then
			# If not running interactively, don't do anything
			if [[ $- != *i* ]]; then
				:
			else
				pipx-maintain
			fi
		fi
	fi
fi