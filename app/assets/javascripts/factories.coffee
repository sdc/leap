angular.module 'leapApp'

.factory 'Topic', ($http,$rootScope,$q,$log) ->
  topic = false
  urlBase = ->
    (switch topic.topic_type
      when "person" then "/people/"
      when "course" then "/courses/"
    ) + topic.mis_id
  urlBase: urlBase
  set: (mis_id = "user", type = "person") ->
    deferred = $q.defer()
    if topic && topic.mis_id == mis_id && topic.topic_type == type
      deferred.resolve topic
    else
      $http.get("/#{if type == 'person' then 'people' else 'courses'}/#{mis_id}.json").then (result) ->
        topic = result.data
        $rootScope.$broadcast("topicChanged")
        deferred.resolve topic
    deferred.promise
  reset: ->
    topic = false
    $rootScope.$broadcast("topicChanged")
  get: -> topic
  update: ->
    return unless topic
    $log.info "TopicFactory: I'm about to update the topic"
    $http.get(urlBase() + ".json?refresh=true")
    .success (data) ->
      topic = data
      $rootScope.$broadcast("topicUpdated")

.factory 'Timeline', ($http,$rootScope,$q,Topic,$log,academicYearFilter) ->
    events = []
    viewName = null
    view = null
    setView: (v) ->
      if viewName != v
        viewName = v
        $rootScope.$broadcast "viewChanged"
    getView: -> view
    get: -> events
    years: -> _.map(_.uniq(_.map(events,(e) -> academicYearFilter(e.event_date))), (y) -> {year: y,show: true})
    update: ->
      deferred = $q.defer()
      $http.get("#{Topic.urlBase()}/timeline_views/#{viewName}").success (data) ->
        view = data.view
        events = data.events
        (event.eventDate = new Date event.event_date) for event in events
        (event.academicYear = academicYearFilter(event.eventDate)) for event in events
        (event.showDate = (events[i-1]?.eventDate.toDateString() != event.eventDate.toDateString())) for event,i in events
        $rootScope.$broadcast("timelineUpdated")
        deferred.resolve events
      deferred.promise
