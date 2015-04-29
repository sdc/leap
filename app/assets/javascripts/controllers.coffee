angular.module 'leapApp', ['ngRoute','mm.foundation','duScroll']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/:topic_type/:topic_id',
      controller: "TimelineController",
      templateUrl: "/assets/timeline.html"
    .when '/:topic_type/:topic_id/:view_name',
      controller: "TimelineController"
      templateUrl: "/assets/timeline.html"
    .when '/search',
      controller: 'SearchController',
      templateUrl: '/assets/search.html'
])

.run ($rootScope,Topic,Timeline,$interval,$document,$log) ->
  Topic.set().then (data) -> $rootScope.user = data
  $rootScope.$on "topicChanged", ->
    if topic = Topic.get()
      $log.info "Leap: I set the topic to #{topic.topic_type}: #{topic.name} (#{topic.mis_id})"
      #$interval Topic.update, 5000
    else
      $log.info "Leap: I cleared the topic!"
  $rootScope.$on "topicUpdated", -> $log.info "Leap: Topic #{Topic.get().topic_type}: #{Topic.get().name} updated."
  $rootScope.$on "timelineUpdated", -> $log.info "Leap: The timeline got updated!"
  $rootScope.$on "viewChanged", ->
    $log.info "Leap: The view has changed to " + Timeline.getView()
    Timeline.update()

.controller 'TimelineController', ($scope,$http,$routeParams,Topic,Timeline,$rootScope,$log,$interval) ->
  Topic.set($routeParams.topic_id,$routeParams.topic_type).then ->
    Timeline.setView $routeParams.view_name || "all"
    Topic.update()
    #$interval Timeline.update, 4000
  $rootScope.$on "timelineUpdated", ->
    $scope.years = Timeline.years()
    $scope.events = Timeline.get()
    $scope.view = Timeline.getView()

#.controller 'moodleCoursesController', ($scope,$http,$rootScope) ->
#  $scope.getCourses = (mis_id) ->
#    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
#     $scope.courses = data
#  $rootScope.$watch "user", (user) -> $scope.getCourses(user.mis_id) if user
#
.controller 'SearchController', ($scope,$http,$location,$routeParams,Topic,Timeline) ->
  $scope.working = false
  $scope.filter = "people"
  $scope.search = -> $location.path("/search").search("q",$scope.q)
  $scope.doSearch = ->
    Topic.reset()
    return unless $routeParams.q
    $scope.working = true
    $http.get("/people/search.json?q=#{$routeParams.q}").success (data) ->
      $scope.people = data.people
      $scope.courses = data.courses
      $scope.filter = "courses" if data.people.length == 0
      $scope.working = false
  $scope.doSearch()

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
        for e in data.events
          (event.eventDate = new Date event.event_date) for event in events
          (event.academicYear = academicYearFilter(event.eventDate)) for event in events
          (event.showDate = (events[i-1]?.eventDate.toDateString() != event.eventDate.toDateString())) for event,i in events
          if _.findWhere(events, {id: e.id})
            console.log "not new"
          else
            console.log e
            events.push e
          events = (_.sortBy(events,'eventDate')).reverse()
        $rootScope.$broadcast("timelineUpdated")
        deferred.resolve events
      deferred.promise


.filter 'academicYear', ->
  (d) ->
    date = new Date(d)
    year = date.getFullYear()
    if date.getMonth() >= 9
      String(year).substring(2) + "/" + String(year + 1).substring(2)
    else
      String(year - 1).substring(2) + "/" + String(year).substring(2)

.directive 'leapViewsMenu', ($http,Topic,$rootScope) ->
  restrict: "E"
  templateUrl: "/assets/views_menu.html"
  link: (scope) ->
    refresh = ->
      $http.get('/timeline_views.json').success (data) ->
        scope.timeline_views = data
        scope.baseUrl = "#/#{Topic.get().topic_type}/#{Topic.get().mis_id}/"
    $rootScope.$on 'topicChanged', -> refresh()
    refresh()

.directive 'leapTopicHeader', ($rootScope,Topic,$log,$document) ->
  restrict: "EA"
  templateUrl: '/assets/topic_header.html'
  link: (scope, element) ->
    $rootScope.$on 'topicUpdated', ->
      scope.topic = Topic.get()
      $log.info "TopicHeader: I saw the topic (#{scope.topic.name}) update"
      scope.$broadcast "person_#{scope.topic.id}_updated"
    $rootScope.$on 'topicChanged', ->
      scope.topic = Topic.get()
      $log.info "TopicHeader: I saw the topic change to #{scope.topic.name}"
    $document.on 'scroll', ->
      scope.collapseTopicBar = $document.scrollTop() > (element.find('header').prop('offsetHeight') - 24)

.directive 'leapTopBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/top_bar.html'

.directive 'leapPersonHeader', ($http,Topic,$log) ->
  restrict: "EA"
  templateUrl: '/assets/person_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.detailsPane='contacts'
    scope.refresh = -> Topic.update()
    scope.$watch 'misId', ->
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data
        $log.info "PersonHeader: I changed to #{scope.person.name}"

.directive 'leapCourseHeader', ($http,Topic) ->
  restrict: "EA"
  templateUrl: '/assets/course_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.$watch 'misId', ->
      $http.get("/courses/#{scope.misId}.json").success (data) ->
        scope.course = data

.directive 'leapCourse', ($http,$rootScope,Topic) ->
  restrict: "E"
  templateUrl: '/assets/course.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.$watch 'misId', ->
      return unless scope.misId
      $http.get("/courses/#{scope.misId}.json").success (data) ->
        scope.course = data

.directive 'leapPerson', ($http,$log) ->
  restrict: "EA"
  templateUrl: '/assets/person.html'
  scope:
    misId: '='
    flags: '@'
  link: (scope,element,attrs) ->
    scope.flags = scope.flags=="flags"
    scope.$on "person_#{scope.misId}_updated", ->
      $log.info "Person #{scope.name}: I need to update myself"
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data
        $log.info "Person #{data.name}: I updated myself."
    scope.$watch 'misId', ->
      return unless scope.misId
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data

.directive 'leapTimelineEvent', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/timeline_event.html'
  scope:
    leapEventId: '='
    showDate: '='
  link: (scope,element,attrs) ->
    $http.get("#{Topic.urlBase()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data
      scope.eventDate = new Date(scope.event.eventDate)
      scope.showTime = !(scope.eventDate.getHours() == scope.eventDate.getMinutes() == scope.eventDate.getSeconds() == 0)
      scope.showPerson = Topic.get().topic_type != "person"
      scope.iconType = if scope.event.icon.substring(0,3) == "fa-" then "fa" else "image"

.directive 'leapTimelineControls', (Timeline,$rootScope) ->
  restrict: "E"
  templateUrl: '/assets/timeline_controls.html'
  link: (scope) ->
    scope.$on "cancelEventForm", ->
      scope.view.showControls = false
      scope.view.showButton = true
    $rootScope.$on "timelineUpdated", ->
      view = Timeline.getView()
      view.showButton = view.controls.length > 0

.directive 'leapEventForm', ($http,Topic,Timeline) ->
  restrict: "E"
  scope:
    templateUrl: '='
    eventType: '='
  templateUrl: '/assets/event_form.html'
  link: (scope) ->
    scope.newEvent = {}
    scope.cancelForm = -> scope.$emit("cancelEventForm")
    scope.createEvent = ->
      toPost = {eventable_type: scope.eventType }
      toPost[scope.eventType] = scope.newEvent
      $http.post(Topic.urlBase() + "/events.json",toPost).success (data) ->
        Timeline.update()
        scope.$emit("cancelEventForm")
        #Timeline.addEvent(dataI

.directive 'leapTile', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/tile.html'
  scope:
    leapEventId: '@'
  link: (scope,element,attrs) ->
    $http.get("#{Topic.urlBase()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data

.directive 'autoActive', ($location) ->
  restrict: 'A',
  scope: false,
  link: (scope, element) ->
    setActive = ->
      path = $location.path()
      angular.forEach element.find('li'), (li) ->
        anchor = li.querySelector('a')
        if (anchor.href.match('#' + path + '(?=\\?|$)'))
          angular.element(li).addClass('active')
        else
          angular.element(li).removeClass('active')
    scope.$on '$locationChangeSuccess', setActive
    setActive()
