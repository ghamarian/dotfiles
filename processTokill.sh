#!/bin/bash

read TOKILL

ps -lef | grep $TOKILL | grep -v grep | awk '{print $2}'
