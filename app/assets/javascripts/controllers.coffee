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

.run ($http,$rootScope,Topic) ->
  Topic.set().then (data) -> $rootScope.user = data

.controller 'timelineController', ($scope,$http,$routeParams,$rootScope,Topic) ->
  $scope.getEvents = ->
  #  date = $scope.events[$scope.events.length-1].event_date if $scope.events.length > 1
    $http.get("/people/#{Topic.getId()}/views/#{$routeParams.view_name}").success (data) ->
      $scope.events = $scope.events.concat(data)
  #$scope.$on "updated_topic", -> $scope.updateEvents()
  $rootScope.hideTopicBar = false
  $scope.events = []
  Topic.set($routeParams.person_id).then ->
    $scope.getEvents()
  #$scope.update_count = 0

#.controller 'moodleCoursesController', ($scope,$http,$rootScope) ->
#  $scope.getCourses = (mis_id) ->
#    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
#     $scope.courses = data
#  $rootScope.$watch "user", (user) -> $scope.getCourses(user.mis_id) if user
#
.controller 'searchController', ($scope,$http,$location,$routeParams,$rootScope) ->
  $scope.working = false
  $scope.search = -> $location.path("/search").search("q",$scope.q)
  $scope.doSearch = ->
    $scope.working = true
    $rootScope.hideTopicBar = true
    $http.get("/people/search.json?q=#{$routeParams.q}").success (data) ->
      $scope.people = data
      $scope.working = false
  $scope.doSearch()

.factory 'Topic', ($http,$rootScope) ->
  topic = false
  set:
    (mis_id = "user") ->
      $http.get("/people/#{mis_id}.json").then (result) ->
        topic = result.data
        $rootScope.$broadcast("setTopic")
        $rootScope.hideTopicBar = false
        console.log "Topic set to #{topic.name} (#{topic.mis_id})"
        topic
  get: -> topic
  getId: -> topic.mis_id

.directive 'leapViewsMenu', ($http,Topic) ->
  restrict: "E"
  templateUrl: "/assets/views_menu.html"
  link: (scope) ->
    $http.get('/views.json').success (data) ->
      scope.views = data
      scope.baseUrl = "#/person/#{Topic.getId()}/"

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

.directive 'leapPerson', ($http,$rootScope,Topic) ->
  restrict: "EA"
  templateUrl: '/assets/person.html'
  scope:
    misId: '@'
    src: '@'
    size: '@'
  link: (scope,element,attrs) ->
    scope.size = attrs.size if attrs.size
    if attrs.misId
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data
    else if scope.src == "user"
      scope.person = $rootScope.user
    else if scope.src == "topic"
      scope.person = Topic.get()
      $rootScope.$on 'setTopic', ->
        scope.person = Topic.get()

.directive 'leapTimelineEvent', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/timeline_event.html'
  scope:
    leapEventId: '@'
  link: (scope,element,attrs) ->
    $http.get("/people/#{Topic.getId()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data
