'use strict';

class PagerDash.Views.IncidentsWeeklyView extends Backbone.View
  template: PagerDash.JST['incidents-weekly']
  el: "#main"

  events:
    "mouseleave .critical": "clearDetails"
    "mouseenter .critical": "showDetails"


  initialize: (options)->
    @filter = options.filter
    # @collection.on('add', this.render, this)
    # @collection.on('remove', this.render, this)
    @collection.on('sync', this.render, this)

  render: ->
    now = new Date()
    start = now.addDays(-7).clearTime()
    now_offset = Math.floor((now-start)/3600000)

    count = 0
    hours = []
    hours[i] = [] for i in [0..(8*24-1)]

    incidents = @collection.filterByService(@filter.service ? null)
    _(incidents).each (incident) ->
      created = new Date(incident.get('created_on'))
      updated = new Date(incident.get('last_status_change_on'))
      if updated > start
        id = incident.get('id')
        created_offset = if created > start then Math.floor((created-start)/3600000) else 0
        updated_offset = Math.floor((updated-start)/3600000)
        hours[i].push(id) for i in [created_offset..updated_offset]
        count += 1

    # TODO: this template is in dire need of a sane set of data structures
    #   days: { shortName, dow, hours[24] }
    #     shortName: "Mon Jul 23",
    #     dow: 0
    #     hours[24] = [[], [], ... null] # empty implies ok, null implies future
    #   ready
    # TODO: navbar (w/ links and query) should be moved into their own view/template
    html = @template(
      hours: hours
      count: count
      start: start
      now_offset: now_offset
      ready: @collection.inSync
      links: PagerDash.links.weekly
      query: window.location.search
    )
    this.$el.html(html);
    this # maintains chainability

  clearDetails: (evt) ->
    this.$el.find('.details').html('')

  showDetails: (evt) ->
    ids = $(evt.currentTarget).data('incidents').split(',')
    incidents = @collection.filter (inc) -> _.contains(ids, inc.get('id'))
    view = PagerDash.VM.create( this, 'IncidentsList', PagerDash.Views.IncidentsListView, {incidents: incidents})
    view.render()

