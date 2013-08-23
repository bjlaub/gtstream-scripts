#!/bin/bash

nova list --name gtstream-ng | grep gtstream-ng | awk '{print $4}'
