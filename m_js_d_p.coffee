# Mastering JS design patterns

log = console.log.bind(console)
fs = require 'fs'
numFile = './numbers.txt'
strFile = './string.txt'
EventEmmiter = require 'events'
server = require('http').createServer()
pry = require 'pry'

after = (ms, fn) -> setTimeout(fn, ms)

# modules
# attach an object to the global namespace

Westeros = {}
#or better
Westeros = Westeros or {}

# first check if the object already exists, and use that version instead of reassigning the variable.
# This allows you to spread your definitions over a number of files - define a single class in each
# file and then bring them all together as part of the build process


