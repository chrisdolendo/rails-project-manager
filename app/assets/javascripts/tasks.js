var getTasks = function(projectId){
  $.ajax({
      type: "GET",
      url: "/projects/" + projectId + "/tasks",
      dataType: 'html'
  }).done(function(serverData){
    $("#task-table").append(serverData);
  });
};