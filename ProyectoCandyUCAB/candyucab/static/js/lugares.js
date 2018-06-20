var estado = document.getElementById('estadonat');
var municipio = document.getElementById('muni_nat');
var parroquia = document.getElementById('parroquia_nat');

estado.onchange = function(){
    est = estado.value;
    console.log(est);

    /*fetch('/municipio/'+est).then(function(response){

        console.log(response.data)
        /*response.json().then(function(data){
            var opcionHTML = '';

            console.table(data);

            /*for(var muni in data.municipios){
                opcionHTML += '<option value="'+muni.id+'">'+muni.nombre+'</option>';
            }
            municipio.innerHTML = opcionHTML;
        });

    });*/

};