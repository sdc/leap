function isSilverlightInstalled(){
 var isSilverlightInstalled = false;
    try{
     //check on IE
     try{
         var slControl = new ActiveXObject('AgControl.AgControl');
         isSilverlightInstalled = true;
     }
     catch (e){
         //either not installed or not IE. Check Firefox
         if ( navigator.plugins["Silverlight Plug-In"] ){
             isSilverlightInstalled = true;
         }
     }
 }
 catch (e){
     //we don’t want to leak exceptions. However, you may want
     //to add exception tracking code here.
 }
 return isSilverlightInstalled;
}
;
window.onload = function() {
    if (isSilverlightInstalled() == false){
      var ebs = document.getElementsByClassName('slchk');
      var no_silverlight_msg = 'Please note that your browser currently is not compatible with SPARKE (EBS Reports); therefore if you would like to make use of the EBS link you will need to ensure you are using Leap with Internet Explorer (IE).\n\nWe are currently investigating compatibility for your browser with SPARKE for future developments.';
        for (var i = 0; i < ebs.length; ++i) {
            ebs[i].setAttribute('readonly', 'readonly');
            ebs[i].onclick=function(){
              alert(no_silverlight_msg);
              return false;
            }
        }
    }
}
;

/**
 * Ruby already truncates aspirations > 255 characters
 * 
 * This script prevents users from entering more than data-maxchars in the first place 
 * and counts down from max to 0
 *
 */
// $(function(){
//     $(window).load(function() {
//         $( ".charcount" ).each(function( index ) {

//             $(this).on('keypress keyup', function(e){
//                 var max = $(this).data('maxchars');
//                 var id = $(this).attr('id');

//                 var chars_remaining = max - $(this).val().length;
//                 if (chars_remaining >= 0) {
//                     $(".charcount").next('span').find('span.charcount_chars#' + id + '_chars').html(chars_remaining);
//                 }           
//                 if (this.value.length == max) {
//                         e.preventDefault();
//                 } else if (this.value.length > max) {
//                         this.value = this.value.substring(0, max);
//                 }
//             });

//         });
//     });
// });

/**
 * Ruby already truncates aspirations > 255 characters
 * 
 * This script prevents users from entering more than data-maxchars in the first place 
 * and counts down from max to 0
 *
 */
var charcount_keypress_assigned = [];

var onload_setup_charcount = function() {
    $( ".charcount" ).each(function( index ) {
        var id = $(this).attr('id');

        if ( charcount_keypress_assigned.indexOf( id ) < 0 )
            {
            charcount_keypress_assigned.push(id);
            $(this).on('keypress keyup', function(e){
                var max = $(this).data('maxchars');
                var id = $(this).attr('id');

                var chars_remaining = max - $(this).val().length;
                if (chars_remaining >= 0) {
                    $(".charcount").next('span').find('span.charcount_chars#' + id + '_chars').html(chars_remaining);
                }           
                if (this.value.length == max) {
                        e.preventDefault();
                } else if (this.value.length > max) {
                        this.value = this.value.substring(0, max);
                }
            });
        }

    });
};

// belt and braces onload...
$(document).ready( onload_setup_charcount );
$(document).on('page:load', onload_setup_charcount);
$(document).on("page:load ready", onload_setup_charcount);
$(function() { onload_setup_charcount(); } );
$(window).load( onload_setup_charcount );
window.onload = onload_setup_charcount;
