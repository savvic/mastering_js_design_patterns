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

class Castle
  constructor: (@name) ->

Westeros.Castle = Castle
Westeros.castle = new Westeros.Castle('castle tomek')
log Westeros.castle.name
for i of Westeros
  log i, "::", Westeros[i]

# first check if the object already exists, and use that version instead of reassigning the variable.
# This allows you to spread your definitions over a number of files - define a single class in each
# file and then bring them all together as part of the build process

# Abstract Factory -> concrete factories -> products

class KingJoffery

KingJoffery::makeDecision = ->
  log 'decision made by king Joffery'

KingJoffery::marry = ->

# for i of KingJoffery
#   log "king Joffery i is: #{i}"

class LordTywin

LordTywin::makeDecision = ->
  log 'decision made by hand lord Tywin'

# concrete factory method

class LannisterFactory

LannisterFactory::getKing = ->
  new KingJoffery()
LannisterFactory::getHandOfTheKing = ->
  new LordTywin()

# # for different family it looks like this:
# class DiffFamilyFactory
# DiffFamilyFactory::getKing = ->
#   new DiffFamilyKing()
# DiffFamilyFactory::getHandOfTheKing = ->
#   new DiffFamilyHandOfKing()

# use

class CourtSession
  constructor: (@abstractFactory, @complaintThreshold = 10) ->

CourtSession::complaintPresented = (complaint) ->
  log complaint
  if complaint.severity < @complaintThreshold
    @abstractFactory.getHandOfTheKing().makeDecision()
  else
    @abstractFactory.getKing().makeDecision()


courtSession1 = new CourtSession(new LannisterFactory, 7)
# courtSession2 = new CourtSession(new DiffFamilyFactory, 15)
log "courtSession1 complainThreshold is #{courtSession1.complaintThreshold}"
courtSession1.complaintPresented {severity: 8}
courtSession1.complaintPresented {severity: 12}

# Builder

class Event
  constructor: (@name) ->

Westeros.Event = Event

class Prize
  constructor: (@name) ->

Westeros.Prize = Prize

class Attendee
  constructor: (@name) ->

Westeros.Attendee = Attendee

class Tournament
  constructor: (events, attendees, prizes) ->
    @events = []
    @attendees = []
    @prizes = []

Westeros.Tournament = Tournament

class LanisterTournamentBuilder

LanisterTournamentBuilder::build = ->
  tournament = new Tournament
  tournament.events.push new Event('Joust')
  tournament.events.push new Event('Melee')
  tournament.attendees.push new Attendee('Jim')
  tournament.prizes.push new Prize('gold medal')
  tournament.prizes.push new Prize('silver medal')
  log tournament

Westeros.LanisterTournamentBuilder = LanisterTournamentBuilder

class TournamentBuilder

TournamentBuilder::build = (builder) ->
  builder.build()

Westeros.TournamentBuilder = TournamentBuilder

tournamentB = new Westeros.TournamentBuilder()
theTournament = tournamentB.build(new Westeros.LanisterTournamentBuilder())
log theTournament

# Factory Method

religion = require './religion'
{watery} = require './religion'

log watery
log religion.watery

class GodFactory

GodFactory::build = (godName) ->
  if godName is 'watery'
    new religion.watery()
  else if godName is 'ancient'
    new religion.AncientGods()
  else
    new religion.DefaultGods()

class GodDeterminant
  constructor: (@religion, @prayerPurpose) ->

class Prayer
Prayer::pray = (godName) ->
  GodFactory.build(godName).prayTo()


god = new GodFactory
asia = god.build('watery')

log asia.prayTo()

# polish book example

class CarMaker
CarMaker::drive = ->
  "Brum, I have #{@doors} doors"
CarMaker.factory = (type) ->
  constr = type
  if typeof Carmaker[constr] isnt "function"
    throw
      {name: 'Error', message: "#{constr} nie istnieje"}
  if typeof CarMaker[constr]::drive isnt "function"
    CarMaker[constr].prototype = new Carmaker
  newCar = new CarMaker[constr]
  newCar

CarMaker.Compact = ->
  @doors = 4
CarMaker.SUV = ->
  @doors = 5


clone = (source, destination) ->
  for attr of source.prototype
    destination.prototype[attr] = source.prototype[attr]


# Adapter pattern

class Ship
  SetRudderAngleTo: (angle) ->
    log angle
  SetSailConfiguration: (configuration) ->
  SetSailAngle: (sailId, sailAngle) ->
  GetCurrentBearing: () -> 7
  GetCurrentSpeedEstimate: () -> 7
  ShiftCrewWeightTo: (weightToShift, locationId) ->


class ShipAdapter
  constructor: (ship) ->
    @ship = new Ship

  TurnLeft: () ->
    @ship.SetRudderAngleTo(-30)
    @ship.SetSailAngle(3, 12)

  TurnRight: () ->
    @ship.SetRudderAngleTo(30)
    @ship.SetSailAngle(5, -9)

  GoForward: () ->

ship = new ShipAdapter
log ship.TurnLeft()

# Bridge pattern

class OldGods
OldGods::prayTo = (sacrifice) ->
  log "we old gods hear your prayer"

class DrownedGods
DrownedGods::prayTo = (sacrifice) ->
  log "we drowned gods hear your prayer"

class OldGodsAdapter
  constructor: (oldGods) ->
    @oldGods = new OldGods
OldGodsAdapter::prayTo = ->
  sacrifice = new Sacrifice
  @oldGods.prayTo sacrifice

class DrownedGodsAdapter
  constructor: (drownedGods) ->
    @drownedGods = new DrownedGods
DrownedGodsAdapter::prayTo = ->
  humanSacrifice = new HumanSacrifice
  @drownedGods.prayTo humanSacrifice

class Sacrifice

class HumanSacrifice


god2 = new DrownedGodsAdapter
god3 = new OldGodsAdapter
gods = [god2, god3]

for god in gods
  god.prayTo()


# Composite Pattern

class SimpleIngredient
  constructor: (@name, @calories, @ironContent, @vitaminContent) ->

SimpleIngredient::GetName = ->
  @name
SimpleIngredient::GetCalories = ->
  @calories
SimpleIngredient::GetIronContent = ->
  @ironContent
SimpleIngredient::GetVitaminContent = ->
  @vitaminContent

class CompoundIngredient
  constructor: (@name, ingredients) ->
    @ingredients = new Array

CompoundIngredient::AddIngredient = (ingredient) ->
  @ingredients.push ingredient
CompoundIngredient::GetName = ->
  @name
CompoundIngredient::GetCalories = ->
  total = 0
  for i in @ingredients
    total += i.GetCalories()
  total
CompoundIngredient::GetIronContent = ->
  total = 0
  for i in @ingredients
    total += i.GetIronContent()
  total
CompoundIngredient::GetVitaminContent = ->
  total = 0
  for i in @ingredients
    total += i.GetVitaminContent()
  total
CompoundIngredient::getArr = ->
  log @ingredients

egg = new SimpleIngredient("Egg", 155, 6, 0)
milk = new SimpleIngredient("Milk", 42, 0, 0)
sugar = new SimpleIngredient("Sugar", 387, 0, 0)
rice = new SimpleIngredient("Rice", 370, 8, 0)

ricePudding = new CompoundIngredient 'Rice Pudding'
ricePudding.AddIngredient(egg)
ricePudding.AddIngredient(rice)
ricePudding.AddIngredient(milk)
ricePudding.AddIngredient(sugar)

ricePudding.getArr()

log "A serving of rice pudding contains: #{ricePudding.GetCalories()} calories"

# Decorator Pattern
























