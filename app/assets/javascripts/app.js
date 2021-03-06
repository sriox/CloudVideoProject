"use strict";

var app = angular.module("videos", []);

app.controller('MainController', ['$scope', function($scope){
	
}]);

app.controller('RegisterController', ['$scope', function($scope){
	$scope.confirmPassword = null;
    $scope.user = {};
}]);

app.controller('LoginController', ['$scope', function($scope){
    $scope.user = {};
}]);

app.controller('NavbarController', ['$scope', function($scope){
    $scope.logout = function(){
        document.location = '/logout';
    }
}]);

app.controller('NewContestController', ['$scope', '$location', function($scope, $location){
    $scope.contest = {};
    $scope.baseUrl = location.host;
    $scope.cleanUrl = function(){
        $scope.contest.url = !!$scope.contest.url ? $scope.contest.url.split(' ').join(''): '';
    };
    $('#startDate').datepicker({
        dateFormat: 'yy-mm-dd',
        changeMonths: true,
        onClose: function(selectedDate){
            $('#endDate').datepicker('option', 'minDate', selectedDate);
        }
    });
    $('#endDate').datepicker({
        dateFormat: 'yy-mm-dd',
        changeMonths: true,
        onClose: function(selectedDate){
            $('#startDate').datepicker('option', 'maxDate', selectedDate);
        }
    });
}]);

app.controller('ContestsIndexController', ['$scope', function($scope){
    $scope.goTo = function(url){
        document.location = url;
    }
    $scope.copyLink = function(e, link){
        var input = $('#linkToCopy');
        input.val(location.host + '/contests/' + link);
        $('#myModal').modal('show');
        input.select();
    }
}]);

app.controller('ContestsShowController', ['$scope', function($scope){
    $scope.customUrl = location.host + '/contests/' + $('#customUrl').val();
}]);