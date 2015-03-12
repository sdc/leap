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

.controller 'timelineEventsController', ($scope,$http,$routeParams,Topic) ->
  $scope.getEvent = (id) ->
    $http.get "/people/#{$routeParams.person_id}/events/#{id}.json"
      .success (data) ->
        $scope.events[i] = data for e,i in $scope.events when e.id == id

  $scope.getEvents = ->
    Topic.set($routeParams.person_id)
    date = $scope.events[$scope.events.length-1].event_date if $scope.events.length > 1
    $http.get("/people/#{$routeParams.person_id}/views/#{$routeParams.view_name}.json?date=#{date}").success (data) ->
      $scope.events = $scope.events.concat(data)
      $scope.getEvent(d.id) for d in data

  $scope.events = []
  $scope.getEvents()

.controller 'topicController', ($scope,Topic,User) ->
  $scope.user = User.set()
  $scope.$watch User.get,  -> $scope.user  = User.get()  if User.get()
  $scope.$watch Topic.get, -> $scope.topic = Topic.get() if Topic.get()

.controller 'viewsController', ($scope,$http) ->
  $scope.getViews = ->
    $http.get('/views.json').success (data) ->
      $scope.views = data
  $scope.getViews()

.controller 'moodleCoursesController', ($scope,$http,Topic) ->
  $scope.getCourses = (mis_id) ->
    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
      $scope.courses = data
  $scope.$watch Topic.get, -> $scope.getCourses(Topic.get().mis_id) if Topic.get()

.factory 'Topic', ($http) ->
  topic = false
  set:
    (mis_id) ->
      $http.get("/people/#{mis_id}.json").success (data) ->
        topic = data
  get: -> topic

.factory 'User', ($http) ->
  user= false
  set: ->
    $http.get("/people/user.json").success (data) ->
      user = data
  get: -> user
  staff: -> user?.staff
        
.filter 'iconUrl', ->
  (input) ->
    if /^http/.test(input) then input else "/assets/#{input}"
