angular.module 'leapApp', ['ngRoute','ngSanitize']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/timeline/:view_name/:person_id',
      controller: "timelineEventsController"
      templateUrl: "/assets/timeline.html"
    .when '/tiles/:view_name/:person_id',
      controller: "timelineEventsController"
      templateUrl: "/assets/tiles.html"
  ])

.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  ]

.controller 'timelineEventsController', ($scope,$http,$routeParams,Topic,User) ->
  $scope.getEvent = (id) ->
    $http.get "/people/#{$routeParams.person_id}/events/#{id}.json"
      .success (data) ->
        $scope.events[i] = data for e,i in $scope.events when e.id == id

  $scope.getEvents = ->
    Topic.set($routeParams.person_id)
    User.set()
    date = $scope.events[$scope.events.length-1].event_date if $scope.events.length > 1
    $http.get("/people/#{$routeParams.person_id}/views/#{$routeParams.view_name}.json?date=#{date}").success (data) ->
      $scope.events = $scope.events.concat(data)
      $scope.getEvent(d.id) for d in data

  $scope.events = []
  $scope.getEvents()

.controller 'viewsController', ($scope,$http) ->
  $scope.getViews = ->
    $http.get('/views.json').success (data) ->
      $scope.views = data
  $scope.getViews()

.controller 'moodleCoursesController', ($scope,$http,$rootScope) ->
  $scope.getCourses = (mis_id) ->
    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
      $scope.courses = data
  $rootScope.$watch "topic", (topic) -> $scope.getCourses(topic.mis_id) if $rootScope.topic

.factory 'Topic', ($http,$rootScope) ->
  topic = false
  set:
    (mis_id) ->
      $http.get("/people/#{mis_id}.json").success (data) ->
        $rootScope.topic = data

.factory 'User', ($http,$rootScope) ->
  user= false
  set: ->
    $http.get("/people/user.json").success (data) ->
      $rootScope.user = data
  staff: -> user?.staff
        
.filter 'iconUrl', ->
  (input) ->
    if /^http/.test(input) then input else "/assets/#{input}"
