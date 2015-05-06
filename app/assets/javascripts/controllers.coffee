angular.module 'leapApp'

.controller 'TimelineController', ($scope,$http,$routeParams,Topic,Timeline,$rootScope,$log,$interval) ->
  Topic.set($routeParams.topic_id,$routeParams.topic_type).then ->
    Timeline.setView $routeParams.view_name || "all"
    Topic.update()
    $rootScope.topic = Topic.get()
    #$interval Timeline.update, 4000
  $rootScope.$on "timelineUpdated", ->
    $scope.years = Timeline.years()
    $scope.events = Timeline.get()
    $scope.view = Timeline.getView()

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
