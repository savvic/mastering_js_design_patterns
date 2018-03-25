# Mastering JS design patterns

# single responsibility principle
# ensure that each class has only one thing for which it has some responsibility

# class that looks up users from a database should itself not contain functionality to send e-mails to these users.
# That is too much responsibility.
# Complex adapters can be replaced with a composite object that will be explored later in this chapter.

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

# Creational Patterns   **************************************************************************************

# Westeros = {}
# or better
Westeros = Westeros or {}

class Castle
  constructor: (@name) ->

# słowo kluczowe new, które tworzy obiekty na podstawie funkcji konstruujących

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

class LannisterTournamentBuilder

LannisterTournamentBuilder::build = ->
  tournament = new Tournament
  tournament.events.push new Event('Joust')
  tournament.events.push new Event('Melee')
  tournament.attendees.push new Attendee('Jim')
  tournament.prizes.push new Prize('gold medal')
  tournament.prizes.push new Prize('silver medal')
  log tournament

Westeros.LannisterTournamentBuilder = LannisterTournamentBuilder

class TournamentBuilder

TournamentBuilder::build = (builder) ->
  builder.build()

Westeros.TournamentBuilder = TournamentBuilder

tournamentB = new Westeros.TournamentBuilder()
log tournamentB
theTournament = tournamentB.build(new Westeros.LannisterTournamentBuilder())
log theTournament

# Factory Method   *****************************************   *******************************************

religion = require './religion'
{watery} = require './religion'

log watery
log religion.watery

class GodFactory

GodFactory::build = (godName) ->
  if godName is 'watery'
    new religion.watery()
  else if godName is 'ancient'
    new religion.ancient()
  else
    new religion.DefaultGods()

class GodDeterminant
  constructor: (@religion, @prayerPurpose) ->

class Prayer
Prayer::pray = (godName) ->
  p = new GodFactory
  p.build(godName).prayTo()


god = new GodFactory
asia = god.build('watery')
log asia
log asia.name()
euroasia = god.build('ancient')

log asia.prayTo()
log euroasia.prayTo()

prejer = new Prayer
prejer.pray('watery')

# polish book example

class CarMaker

CarMaker::drive = ->
  log "Brum, I have #{@doors} doors"
CarMaker.factory = (type) ->
  constr = type
  if typeof CarMaker[constr] isnt "function"
    throw
      # {name: 'Error', message: "#{constr} nie istnieje"}
      log "Error #{constr} nie istnieje"
  if typeof CarMaker[constr]::drive isnt "function"
    CarMaker[constr].prototype = new CarMaker
  newCar = new CarMaker[constr]
  newCar

CarMaker.Compact = ->
  @doors = 4
CarMaker.SUV = ->
  @doors = 7


log CarMaker
auto = new CarMaker
auto_2 = CarMaker
log "to jest auto: #{auto}"
log "to jest auto_2: #{auto_2}"

for i,v of auto
  log i, " :: ", v

for i,v of auto_2
  log i, " :: ", v

corolla = CarMaker.factory('Compact')
log corolla
corolla.drive()
# expedition = new CarMaker.factory('suv')
f150 = auto_2.factory('SUV')
f150.drive()

o = new Object()
n = new Object(1)
s = Object('1')
b = Object(true)

log o.constructor is Object
log n.constructor is Number
log s.constructor is String
log b.constructor is Boolean


# Prototype pattern page 79

#   *************************************************   ***************************************************
#   Copying existing objects

clone = (source, destination) ->
  for attr of source.prototype
    destination.prototype[attr] = source.prototype[attr]

cloneCoffee = (s,d) ->
  for attr of s::
    d::attr = s::attr
#   *************************************************   ***************************************************

class Lannister
  Lannister::clone = ->
    clone = new Lannister
    for attr of @
      clone[attr] = @[attr]
    clone

jamie = new Lannister
jamie.swordSkills = 9
jamie.charm = 6
jamie.wealth = 10
tyrion = jamie.clone()
tyrion.charm = 10

log "tyrion wealth is cloned and = #{tyrion.wealth}"


# Singleton book pl str 139


Universe1 = -> # class Universe
  return Universe1.instance if typeof Universe1.instance is 'object'
  @start_time = 0
  @big_bang = 'wielki'
  Universe1.instance = @

uni1 = new Universe1
uni2 = new Universe1
log "uni1 is uni2 #{uni1 is uni2}"
log Universe1.instance
log Universe1

Universe2 = ->
  instance = @
  @start_time = 1
  @big_bang = 'duży'
  Universe2 = ->
    return instance

# uni5 = new Universe2 - # drugie i następne wywołania wykonują już zmieniony konstruktor
# jest to wzorzec samomodyfikującej się funkcji :: WADA :: nadpisana funkcja utraci wszystkie właściwości
# dodane między jej zdefiniowaniem i nadpisaniem
uni3 = new Universe2
uni4 = new Universe2
log "uni3 is uni4 #{uni3 is uni4}"

# Universe3 = ->
#   Universe3 = -> instance
#   Universe3.prototype = @
#   instance = new Universe3
#   instance.constructor = Universe3
#   instance.start_time = 2
#   instance.big_bang = 'ogromny'
#   instatnce

# Universe3::nothing = true
# uni6 = new Universe3
# Universe3::everything = true
# uni7 = new Universe3
# log "uni6 is uni7 #{uni6 is uni7}"



# Structural Patterns   *************************************   simple ways in which objects can interact

# Adapter pattern   *****************************************  p.84  *******************************************

# We may need to make use of a class that does not perfectly fit the required interface.
# The class may be missing methods or may have additional methods we would like to hide.
# When building library code, adapters can be used to mask the internal method and only present the limited functions needed by the end user.
# ShipAdapter is simplified version of Ship interface

class Ship
  SetRudderAngleTo: (angle) -> log angle
  SetSailConfiguration: (configuration) ->
  SetSailAngle: (sailId, sailAngle) -> log sailId, sailAngle
  GetCurrentBearing: () -> 7
  GetCurrentSpeedEstimate: () -> 7
  ShiftCrewWeightTo: (weightToShift, locationId) ->

ShipAdapter = do ->
  class ShipAdapter
    constructor: (ship) ->
      @ship = new Ship

    TurnLeft: () ->
      @ship.SetRudderAngleTo(-30)
      @ship.SetSailAngle(3, 12)

    TurnRight: () ->
      @ship.SetRudderAngleTo(30)
      @ship.SetSailAngle(5, -9)

  ShipAdapter::GoForward = () -> log "ship goes forward"
  ShipAdapter


ship = new ShipAdapter
ship.GoForward()
log ship.TurnRight()

for i,v of ship
  log i, " :: ", v


# Bridge pattern   *****************************************  p.88  *******************************************


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


# Composite Pattern   *****************************************   *******************************************


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

# Decorator Pattern   *****************************************   *******************************************

























