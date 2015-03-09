angular.module 'leapApp', ['ngRoute','ngSanitize','infinite-scroll']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/timeline/:view_name/:person_id', 
      controller: "timelineEventsController"
      templateUrl: "/views/all"
  ])

.controller 'timelineEventsController', ($scope,$http,$routeParams) ->
  $scope.getEvents = (url) ->
    $http.get("/people/#{$routeParams.person_id}/views/#{$routeParams.view_name}.json").success (data) ->
      $scope.events = data
      $scope.getEvent(d.id) for d in data

  $scope.getEvent = (id) ->
    $http.get(eventUrl(id)).success (data) ->
      $scope.events[i] = data for e,i in $scope.events when e.id == id

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
