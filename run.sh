#!/bin/sh

unicorn -E ${RACK_ENV:-development} --config=./config/unicorn.rb --port=${PORT:-5000}
