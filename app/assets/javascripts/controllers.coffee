angular.module 'leapApp', ['ngRoute','ngSanitize']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/person/:person_id',
      controller: "timelineController",
      templateUrl: "/assets/tiles.html"
    .when '/course/:course_id',
      controller: "timelineController",
      templateUrl: "/assets/people.html"
    .when '/person/:person_id/timeline/:view_name',
      controller: "timelineController"
      templateUrl: "/assets/timeline.html"
    .when '/person/:person_id/tiles/:view_name',
      controller: "timelineController"
      templateUrl: "/assets/tiles.html"
    .when '/search',
      controller: 'searchController',
      templateUrl: '/assets/search.html'
])

.run ($http,$rootScope) ->
  $http.get("/people/user.json").success (data) ->
    $rootScope.user = $rootScope.topic = data
    $rootScope.hideUserBar = $rootScope.hideTopicBar = false

.controller 'timelineController', ($scope,$http,$routeParams,$rootScope,Topic,$interval) ->
  $scope.update_count = 0
  $rootScope.hideTopicBar = false
  $scope.getEvent = (id) ->
    $scope.update_count++
    $rootScope.topic.updating = "btn-success"
    $http.get "/people/#{$routeParams.person_id}/events/#{id}.json"
      .success (data) ->
        $scope.events[i] = data for e,i in $scope.events when e.id == id
        $rootScope.topic.updating = false unless --$scope.update_count

  $scope.updateEvents = ->
    $scope.getEvent(d.id) for d in $scope.events

  $scope.getEvents = ->
    date = $scope.events[$scope.events.length-1].event_date if $scope.events.length > 1
    $http.get("/people/#{$routeParams.person_id}/views/#{$routeParams.view_name || "all"}.json#{ "?date=#{date}" if date}").success (data) ->
      $scope.events = $scope.events.concat(data)
      $scope.updateEvents()
      #$interval $scope.updateEvents, 5000
  Topic.set $routeParams.person_id
  $scope.events = []
  $scope.getEvents()
  $scope.$on "updated_topic", -> $scope.updateEvents()

#.controller 'viewsController', ($scope,$http) ->
#  $scope.getViews = ->
#    $http.get('/views.json').success (data) ->
#      $scope.views = data
#  $scope.getViews()
#
#.controller 'moodleCoursesController', ($scope,$http,$rootScope) ->
#  $scope.getCourses = (mis_id) ->
#    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
#     $scope.courses = data
#  $rootScope.$watch "user", (user) -> $scope.getCourses(user.mis_id) if user
#
.controller 'searchController', ($scope,$http,$location,$routeParams,$rootScope) ->
  $scope.working = false
  $scope.search = ->
    $location.path("/search").search("q",$scope.q)

  $scope.doSearch = ->
    $scope.working = true
    $rootScope.hideTopicBar = true
    $http.get("/people/search.json?q=#{$routeParams.q}").success (data) ->
      $scope.people = data
      $scope.working = false
  $scope.doSearch()

#.controller 'topicController', ($scope,$rootScope,Topic) ->
#  $scope.update = -> Topic.update()
#
.factory 'Topic', ($http,$rootScope) ->
  set:
    (mis_id) ->
      $http.get("/people/#{mis_id}.json").success (data) ->
        $rootScope.topic = data
  update: ->
    if $rootScope.topic
      $rootScope.topic.updating = "btn-warning"
      $http.get("/people/#{$rootScope.topic.mis_id}.json?refresh=true").success (data) ->
        $rootScope.topic = data
        $rootScope.$broadcast("updated_topic")

#.filter 'iconUrl', ->
#  (input) ->
#    if /^http/.test(input) then input else "/assets/#{input}"
#
.directive 'leapUserBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/user_bar.html'
  link: (scope) ->
    scope.user = $rootScope.user
    
.directive 'leapTopicBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/topic_bar.html'
  link: (scope) ->

.directive 'leapTopBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/top_bar.html'
  link: (scope) ->
    scope.toggleUserBar = ->
      $rootScope.hideUserBar = !$rootScope.hideUserBar
    scope.toggleTopicBar = ->
      $rootScope.hideTopicBar = !$rootScope.hideTopicBar

.directive 'leapCourse', ($http) ->
  restrict: "E"
  templateUrl: '/assets/course.html'
  scope:
    misId: '@'
  link: (scope,element,attrs) ->
    $http.get("/courses/#{scope.misId}.json").success (data) ->
      scope.course = data

.directive 'leapPerson', ($http,$rootScope) ->
  restrict: "EA"
  templateUrl: '/assets/person.html'
  scope:
    misId: '@'
    src: '@'
  link: (scope,element,attrs) ->
    if attrs.misId
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data
    else if scope.src == "user"
      scope.person = $rootScope.user
    else if scope.src == "topic"
      $rootScope.$watch "topic", (topic) ->
        scope.person = topic
