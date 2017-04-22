function get_percentage(batch_id)
{
  jQuery.getJSON('/batch_montages/' + batch_id + '.json',
    function(data)
    {
      $('#percentage').text(data.percentage);
      if(data.status == "done")
      {
        location.reload();
      }
      else
      {
        setTimeout(function() { get_percentage(batch_id) }, 500);
      }
    }
  );
}
