angular.module 'leapApp', ['ngRoute']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/:topic_type/:topic_id',
      controller: "TimelineController",
      templateUrl: "/assets/timeline.html"
    .when '/:topic_type/:topic_id/timeline/:view_name',
      controller: "TimelineController"
      templateUrl: "/assets/timeline.html"
    .when '/:topic_type/:topic_id/tiles/:view_name',
      controller: "TimelineController"
      templateUrl: "/assets/tiles.html"
    .when '/search',
      controller: 'SearchController',
      templateUrl: '/assets/search.html'
])

.run ($rootScope,Topic,$interval) ->
  Topic.set().then (data) -> $rootScope.user = data
  #$interval Topic.update, 60000

.controller 'TimelineController', ($scope,$http,$routeParams,$rootScope,Topic) ->
  $scope.getEvents = ->
    # date = $scope.events[$scope.events.length-1].event_date if $scope.events.length > 1
    $http.get("#{Topic.urlBase()}/views/#{$routeParams.view_name || 'all'}").success (data) ->
      $scope.events = $scope.events.concat(data)
  #$scope.$on "updated_topic", -> $scope.updateEvents()
  $scope.events = []
  Topic.set($routeParams.topic_id,$routeParams.topic_type).then ->
    $scope.getEvents()
    Topic.update()

#.controller 'moodleCoursesController', ($scope,$http,$rootScope) ->
#  $scope.getCourses = (mis_id) ->
#    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
#     $scope.courses = data
#  $rootScope.$watch "user", (user) -> $scope.getCourses(user.mis_id) if user
#
.controller 'SearchController', ($scope,$http,$location,$routeParams,Topic) ->
  $scope.working = false
  $scope.filter = "people"
  $scope.search = -> $location.path("/search").search("q",$scope.q)
  $scope.doSearch = ->
    $scope.working = true
    Topic.reset()
    $http.get("/people/search.json?q=#{$routeParams.q}").success (data) ->
      $scope.people = data.people
      $scope.courses = data.courses
      $scope.filter = "courses" if data.people.length == 0
      $scope.working = false
  $scope.doSearch()

.factory 'Topic', ($http,$rootScope,$document) ->
  topic = false
  topicType  = false
  set:
    (mis_id = "user", type = "person") ->
      $http.get("/#{if type == 'person' then 'people' else 'courses'}/#{mis_id}.json").then (result) ->
        topic = result.data
        topicType = type
        $rootScope.$broadcast("setTopic")
        $document.foundation()
        console.log "Topic set to #{topicType}: #{topic.name} (#{topic.mis_id})"
        topic
  reset: ->
    topic = false
    $rootScope.$broadcast("setTopic")
  get: -> topic
  getId: -> topic.mis_id
  getType: -> topicType
  update: ->
    if topic
      $http.get("/#{if topicType == 'person' then 'people' else 'courses'}/#{topic.mis_id}.json?refresh=true").then (result) ->
        topic = result.data
        $rootScope.$broadcast("update-topic")
        console.log "Topic #{topicType}: #{topic.name} updated."
  urlBase: ->
    (switch topicType
      when "person" then "/people/"
      when "course" then "/courses/"
    ) + topic.mis_id

.directive 'leapViewsMenu', ($http,Topic,$rootScope) ->
  restrict: "E"
  templateUrl: "/assets/views_menu.html"
  link: (scope) ->
    refresh = ->
      $http.get('/views.json').success (data) ->
        scope.views = data
        scope.baseUrl = "#/#{Topic.getType()}/#{Topic.getId()}/"
    $rootScope.$on 'setTopic', -> refresh()
    refresh()

.directive 'leapUserBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/user_bar.html'
  link: (scope) ->
    scope.user = $rootScope.user
    
.directive 'leapTopicBar', (Topic) ->
  restrict: "E"
  templateUrl: '/assets/topic_bar.html'

.directive 'leapTopicHeader', ($rootScope,Topic) ->
  restrict: "EA"
  templateUrl: '/assets/topic_header.html'
  link: (scope, element) ->
    $rootScope.$on 'setTopic', ->
      scope.topicType = Topic.getType()
      scope.topic = Topic.get()
      if scope.topic then element.show() else element.hide()

.directive 'leapTopBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/top_bar.html'

.directive 'leapTopic', (Topic,$rootScope) ->
  restrict: "E"
  templateUrl: "/assets/topic.html"
  link: (scope) ->
    $rootScope.$on 'setTopic', ->
      scope.topicType = Topic.getType()
      scope.misId = Topic.getId()

.directive 'leapPersonHeader', ($http,Topic) ->
  restrict: "EA"
  templateUrl: '/assets/person_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.detailsPane='contacts'
    scope.$watch 'misId', ->
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data

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
      $http.get("/courses/#{scope.misId}.json").success (data) ->
        scope.course = data

.directive 'leapPerson', ($http,$rootScope,Topic) ->
  restrict: "EA"
  templateUrl: '/assets/person.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.$watch 'misId', ->
      updateListenerOff() if updateListenerOff
      if scope.misId == Topic.getId
        scope.person = Topic.get()
        updateListenerOff = $rootScope.$on "update-topic", ->
          scope.person = Topic.get()
      else
        $http.get("/people/#{scope.misId}.json").success (data) ->
          scope.person = data
        

.directive 'leapTimelineEvent', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/timeline_event.html'
  scope:
    leapEventId: '@'
  link: (scope,element,attrs) ->
    $http.get("#{Topic.urlBase()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data

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
