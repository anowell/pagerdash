'use strict';

class PagerDash.Models.Incident extends PagerDash.Models.BaseModel
  defaults:
    id: null
    incident_number: null
    created_on: null
    last_status_change_on: null
    last_status_change_by: null
    status: null
    html_url: null
    incident_key: null
    service:
      id: null
      name: null
      html_url: null
    escalation_policy:
      name: null
      id: null
    assigned_to_user: null
    trigger_type: null
    trigger_summary_data:
      description: null
    trigger_details_html_url: null



class PagerDash.Collections.Incidents extends PagerDash.Collections.BaseCollection
  model: PagerDash.Models.Incident
  initialize: (models, options) ->
    super(models, options)
    this.url = 'pagerduty/incidents'

  parse: (response) ->
    response.incidents

  filterByService: (ids) ->
    return @models if ids==null or ids.length==0
    @filter (incident) ->
      ids = [ids] unless _.isArray(ids)
      _.indexOf(ids, incident.get('service').id) >= 0