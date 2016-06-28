$(document).foundation()
$( document ).ready(function() {
    $('p.markdown').each(function(){
      var md_content = $(this).text();
      html_content = markdown.toHTML( md_content );
      html_content = html_content.split('.');
      $(this).html(html_content[0]);
    });
});
