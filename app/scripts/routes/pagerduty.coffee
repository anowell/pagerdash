'use strict';

class PagerDash.Routers.PagerDutyRouter extends Backbone.Router
  routes:
    "":                     "index"
    "incidents":            "incidents"

  initialize: ->
    # start watching for hashchange events
    Backbone.history.start(
      pushState : true
      root : '/'
    )

  index: ->
    defaultRoute = "incidents" + (PagerDash.links?.weekly[0]?.query ? "")
    Backbone.history.navigate(defaultRoute, true)

  incidents: (params) ->
    filter = params ? {}
    view = PagerDash.VM.create( {}, 'IncidentsWeekly', PagerDash.Views.IncidentsWeeklyView, {collection: PagerDash.incidents, filter: filter})
    view.render()
