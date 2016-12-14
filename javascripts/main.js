'use strict';

function times(n, iterator) {
    var accum = new Array(Math.max(0, n));
    for (var i = 0; i < n; i++) {
        accum[i] = iterator(i);
    }
    return accum;
}

$(function () {
    var $main = $(".config-panel");

    function render(i) {
        // Update Name
        $main.find('.config-name').text("Configuration #" + (i + 1));

        // Update description
        $main.find('.config-description').text(configs[i][2]);

        // Update auto groups
        $main.find('.config-automorphism-group-cardinality').text(configs[i][3]);

        // Update small realizability
        var finiteFieldOrders = [3, 4, 5, 7, 8, 9, 11, 13, 16, 17, 19];
        $main.find('.sr tbody tr').remove();

        var $mainSrTbody = $main.find('.sr tbody');
        for (var j = 0; j < finiteFieldOrders.length; j++) {
            var $row = $("<tr><td>" + finiteFieldOrders[j] + "</td><td>" + configs[i][4][j] + "</td></tr>");
            $mainSrTbody.append($row);
        }

        // Clear table
        var $table = $main.find('table.points');
        $table.html('');

        // Compute columns
        var points = configs[i][1];
        var nCols = Math.max.apply(null, points.map(function (x) {
            return x.length;
        }));

        // Generate header
        var $headRow = $("<tr>");
        $("<th>Line Number</th>").appendTo($headRow);
        for (var i = 1; i <= nCols; i++) {
            $("<th>Point " + i + "</th>").appendTo($headRow);
        }
        $headRow.appendTo($table);

        // Populate
        for (var i = 0; i < points.length; i++) {
            var $curRow = $("<tr>");

            $("<td>Line " + (i + 1) + "</td>").appendTo($curRow);
            var $cells = times(nCols, function (j) {
                return $("<td>").text(j < points[i].length ? points[i][j] : "--");
            });
            $cells.forEach(function ($cell) {
                $cell.appendTo($curRow);
            });
            $curRow.appendTo($table);
        }

        $('.config-info-box').show();
    }

    var $sidebar = $(".nav-pills");
    for (var i = 0; i < NumberOfConfigurations; i++) {
        var $item = $("<a>");
        $item.text(i + 1);

        var traits = ['pill'];
        if (configs[i][7]) {
            traits = traits.concat(configs[i][7].split(' '));
        }

        var numLines = configs[i][1].length;
        traits.push(numLines + 'lines');

        var dim = configs[i][5] <= 1 ? configs[i][5] : "unknown";
        traits.push('dim-' + dim);

        var realizable = configs[i][6] == '-' ? 'maybe-' : configs[i][6] === false ? 'un' : '';
        traits.push(realizable + 'realizable');

        if (configs[i][3] >= 16) {
            traits.push('highly-symmetric');
        }

        for (var j = 0; j < traits.length; j++) {
            $item.addClass(traits[j]);
        }

        $item.appendTo($sidebar)
            .click((function (_i) {
                return function () {
                    render(_i);
                };
            })(i));
    }

    $('.pill').not('.7point').not('.8point').not('.9point').addClass('10point');

    $('#config-choice').change(function () {
        $('.pill').hide();
        $(this).find('option:selected').each(function () {
            var cls = $(this).attr('data-show');
            $('.' + cls).show();
            console.log(cls)
        });
    });
});