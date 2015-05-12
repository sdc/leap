angular.module 'leapApp', ['ngRoute','ngSanitize','mm.foundation','duScroll']

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
