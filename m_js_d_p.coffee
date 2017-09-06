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
# or better
Westeros = Westeros or {}

# first check if the object already exists, and use that version instead of reassigning the variable.
# This allows you to spread your definitions over a number of files - define a single class in each
# file and then bring them all together as part of the build process

# Abstract Factory -> concrete factories -> products

class KingJoffery

KingJoffery::makeDecision = ->
  log 'decision made by king Joffery'

KingJoffery::marry = ->

class LordTywin

LordTywin::makeDecision = ->
  log 'decision made by hand lord Tywin'

# concrete factory method

class LannisterFactory

LannisterFactory::getKing = ->
  new KingJoffery()
LannisterFactory::gerHandOfTheKing = ->
  new LordTywin()

# use

class CourtSession
  constructor: (abstractFactory, complaintThreshold) ->
    @abstractFactory = abstractFactory
    @complaintThreshold = 10

CourtSession::complaintPresented = (complaint) ->
  log complaint
  if complaint.severity < @complaintThreshold
    @abstractFactory.gerHandOfTheKing().makeDecision()
  else
    @abstractFactory.getKing().makeDecision()


courtSession1 = new CourtSession(new LannisterFactory())
courtSession1.complaintPresented {severity: 8}
courtSession1.complaintPresented {severity: 12}







