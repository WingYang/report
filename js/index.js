/**
 * Created by Wing on 2016/9/6.
 */

$(document).ready(function () {
    $('.detail').on('click',function () {
        $(this).parent().nextUntil("tr.server_brief").slideToggle("fast");
    })
})