$(document).ready(function(){
    $('.hud').hide();

    window.addEventListener('message', function(event) {

        var data = event.data;

        if (data.show != null) {
            if (data.show) {
                $(".hud").fadeIn(250);
            } else {
                $(".hud").fadeOut(250);
            }
        }

        if (data.showplayerhud != null) {
            if (data.showplayerhud) {
                $(".player-hud").fadeIn(250);
            } else {
                $(".player-hud").fadeOut(250);
            }
        }

        if (data.showspeedometer != null) {
            if (data.showspeedometer) {
                $(".speedometer").fadeIn(250);
            } else {
                $(".speedometer").fadeOut(250);
            }
        }

        if (data.id != null) {
            $('.id').text(data.id);
        }

        if (data.hour != null) {
            $('.hour').text(data.hour);
        }
        
        if (data.username != null) {
            $('.username').text(data.username);
        }

        if (data.job != null) {
            $('.job-name').text(data.job);
        }

        if (data.blackmoney != null) {
            $('.blackmoney-balance').text("$ " + numberWithCommas(data.blackmoney));
        }

        if (data.bank != null) {
            $('.bank-balance').text("$ " + numberWithCommas(data.bank));
        }

        if (data.money != null) {
            $('.cash-balance').text("$ " + numberWithCommas(data.money));
        }

        if (data.cc != null) {
            $('.cc-balance').text("$ " + numberWithCommas(data.cc));
        }

        if (data.hunger != null) {
            $('.hungerbar-done').css('width', Math.round(data.hunger) + "%");
            $('.hungerbar-done').text(Math.round(data.hunger) + "%");
        }

        if (data.thirst != null) {
            $('.thirstbar-done').css('width', Math.round(data.thirst ) + "%");
            $('.thirstbar-done').text(Math.round(data.thirst ) + "%");
        }

        if (data.mic != null) {
            if (data.mic) {
                $('.mic').css('opacity', "100%");
            }
            else {
                $('.mic').css('opacity', "70%");
            }
        }

        if (data.miclevel != null) {
            $('.mic-level').text(data.miclevel);
        }

        if (data.fuel != null) {
            $('.fuelbar-done').css('width', data.fuel + "%");
            $('.fuelbar-done').text(data.fuel + "%");
        }

        if (data.vehiclespeed != null) {
            $('.velocity-balance').text(data.vehiclespeed);
        }

        if (data.lightson != null) {
            if (data.lightson) {
                $('.fa-adjust').css('opacity', "100%");
            }
            else {
                $('.fa-adjust').css('opacity', "50%");
            }
        }

        if (data.seatbelt != null) {
            if (data.seatbelt) {
                $('.fa-compress-alt').css('opacity', "100%");
            }
            else {
                $('.fa-compress-alt').css('opacity', "50%");
            }
        }

        if (data.highbeamson != null) {
            if (data.highbeamson) {
                $('.fa-adjust').css('opacity', "100%");
                $('.fa-adjust').css('color', "var(--color9)");
            }
            else {
                $('.fa-adjust').css('color', "var(--color8)");
            }
        }

        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
        }
    });
});