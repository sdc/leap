angular.module 'leapApp', ['ngSanitize','infinite-scroll']

.controller 'timelineEventsController', ($scope,$http) ->
  $scope.getEvents = (url) ->
    $http.get(url).success (data) ->
      $scope.events = data
      $scope.getEvent(d.id) for d in data

  $scope.getEvent = (id) ->
    $http.get(eventUrl(id)).success (data) ->
      $scope.events[i] = data for e,i in $scope.events when e.id == id

.controller 'moodleCoursesController', ($scope,$http) ->
  $scope.getCourses = (url) ->
    $http.get(url).success (data) ->
      $scope.courses = data
        
.filter 'iconUrl', ->
  (input) ->
    if /^http/.test(input) then input else "/assets/#{input}"

eventUrl = (id) ->
  "/events/#{id}.json"
