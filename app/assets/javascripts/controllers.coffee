angular.module 'leapApp', ['ngRoute','ngSanitize']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/timeline/:view_name/:person_id', 
      controller: "timelineEventsController"
      templateUrl: "/views/all"
  ])

.controller 'timelineEventsController', ($scope,$http,$routeParams) ->
  $scope.getEvent = (id) ->
    $http.get(eventUrl(id)).success (data) ->
      $scope.events[i] = data for e,i in $scope.events when e.id == id

  $scope.getEvents = ->
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

.controller 'moodleCoursesController', ($scope,$http) ->
  $scope.getCourses = (url) ->
    $http.get(url).success (data) ->
      $scope.courses = data
        
.filter 'iconUrl', ->
  (input) ->
    if /^http/.test(input) then input else "/assets/#{input}"

eventUrl = (id) ->
  "/events/#{id}.json"
