
$(".main").fadeOut(0)
$("#2").fadeOut(0)
$("#3").fadeOut(0)
$("#4").fadeOut(0)



$(document).ready(function() {
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $('.main').fadeOut(0);
            $.post('https://HDPack/hide', JSON.stringify({}));
        }
    };
});

function ZatrudnijSie(job) {
    $.post('https://HDPack/job', JSON.stringify({praca: job}));
}

function NextJob(event) {
    const Tata = event.target
    const TataNigga = Tata.parentNode
    const TataNigga2 = TataNigga.parentNode
    if (TataNigga2.id > 2) {
    } else {
        $("#" + TataNigga2.id).fadeOut(0)
        $("#" + String(Number(TataNigga2.id) + 1)).fadeIn(200)
    }
}
function LastJob(event) {
    const Tata = event.target
    const TataNigga = Tata.parentNode
    const TataNigga2 = TataNigga.parentNode
    if (TataNigga2.id == 1) {
    } else {
        $("#" + TataNigga2.id).fadeOut(0)
        $("#" + String(Number(TataNigga2.id) - 1)).fadeIn(200)
    }
        
}


window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'open':
            $(".main").fadeIn(200)
           break;
        case 'hide':
            $('.main').fadeOut(0);
            break;
    }
});