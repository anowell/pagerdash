window.PagerDash =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  VM: {}
  links: window.pagerduty.links ? {}
  init: ->
    'use strict'
    console.log 'Initializing PagerDash...'
    options = {}
    PagerDash.incidents = new PagerDash.Collections.Incidents(null, options)

  fetchOptions:
    error: (collection, response, options) ->
      collection.fetchesFailed += 1
      collection.inSync = false
      console.log("Error fetching #{collection.url}: #{collection.fetchesFailed} consecutive fails")
      setTimeout( ->
        console.log("Retrying #{collection.url}")
        collection.fetch(PagerDash.fetchOptions)
      , collection.refreshInterval*1000)

    success: (collection, response, options) ->
      console.log("Updated #{collection.url}: #{collection.length} items")
      collection.fetchesFailed = 0
      collection.inSync = true
      setTimeout( ->
        collection.fetch(PagerDash.fetchOptions)
      , collection.refreshInterval*1000)

    data:
      sort_by: "created_on:desc"

  beginSync: (options) ->
    console.log("Initial sync of all collections")
    PagerDash.incidents.fetch(@fetchOptions)


# All navigation that is relative should be processed by the router.
$(document).on("click", "a[href]", (evt) ->
  href = { prop: $(this).prop("href"), attr: $(this).attr("href") }
  root = location.protocol + "//" + location.host + "/";

  # Ensure the root is part of the anchor href, meaning it's relative.
  if href.prop.slice(0, root.length) == root
    evt.preventDefault();
    Backbone.history.navigate(href.attr, true) unless href.attr == '#'
)

Date.prototype.addDays = (days) ->
  dat = new Date(this.valueOf())
  dat.setDate(dat.getDate() + days)
  dat

Date.prototype.clearTime = () ->
  dat = new Date(this.valueOf())
  dat.setHours(0)
  dat.setMinutes(0)
  dat.setSeconds(0)
  dat

Date.prototype.getDayOfWeek = () ->
  ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][this.getDay()]

Date.prototype.getShortDayOfWeek = () ->
  this.getDayOfWeek().substr(0,3)

Date.prototype.toMonthDayString = () ->
  (this.getMonth()+1) + "/" + this.getDate()

$ ->
  'use strict'
  PagerDash.init()
  PagerDash.beginSync()
  PagerDash.router = new PagerDash.Routers.PagerDutyRouter()