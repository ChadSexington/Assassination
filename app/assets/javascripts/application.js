// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
$(document).ready(function() {
	// find the first container
	var bodyContainer = $("body").children().eq(1);
	var childs = $("body").children();

	console.log("Found this many children: " + childs.length);
	console.log("First child: " + childs[0]);

	console.log("Does navbar-inverse have a length: " + $(".navbar-inverse").length);
	// if an admin is logged in (meaning the second navbar is rendered) adjust the body padding
	if ($(".navbar-inverse").length != 0) {
		bodyContainer.css({"padding-top":"100px"});
		console.log("Changed the top padding")
	}
  $('#round_start_datetime').datetimepicker();
  $('#round_end_datetime').datetimepicker();

  $('#kill9').on ('change', enableKill9Options);
  
  function enableKill9Options() {
    if ($('#kill9').is(':checked') ){
      $('#kill9_start_time').prop("disabled", false);
    } else {
      $('#kill9_start_time').prop("disabled", true);
    }
  }

});
