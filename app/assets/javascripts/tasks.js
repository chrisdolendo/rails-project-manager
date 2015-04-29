var getTasks = function(projectId){
  console.log("called");
  $.ajax({
      type: "GET",
      url: "/projects/" + projectId + "/tasks",
      dataType: 'html'
  }).done(function(serverData){
    $("#task-table").append(serverData);
  });
};