'use strict';

class PagerDash.Views.IncidentsListView extends Backbone.View
  template: PagerDash.JST['incidents-list']
  el: ".details"

  events:
    "mouseleave .critical": "clearDetails"
    "mouseenter .critical": "showDetails"


  initialize: (options)->
    @filter = options.filter
    @incidents = options.incidents

  render: ->
    html = @template({ incidents: @incidents })
    this.$el.html(html);
    this # maintains chainability
