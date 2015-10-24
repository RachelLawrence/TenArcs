'use strict';

function times(n, iterator) {
  var accum = Array(Math.max(0, n));
  for (var i = 0; i < n; i++) {
    accum[i] = iterator(i);
  }
  return accum;
};

$(function() {
  var $main = $(".config-panel");

  function render(i) {
    // Update Name
    $main.find('.config-name').text(Names[i]);

    // Clear table
    var $table = $main.find('table.points');
    $table.html('');

    // Compute columns
    var points = Points[i];
    var nCols = Math.max.apply(null, points.map(function(x) {
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
      var $cells = times(nCols, function(j) {
        return $("<td>").text(j < points[i].length ? points[i][j] : "--");
      });
      $cells.forEach(function($cell) {
        $cell.appendTo($curRow);
      });
      $curRow.appendTo($table);
    }
  }

  var $sidebar = $(".nav-pills");
  for (var i = 0; i < NumberOfConfigurations; i++) {
    var item = '<a>' + (i + 1) + '</a>';
    $(item)
      .appendTo($sidebar)
      .click((function(_i) {
        return function(e) {
          render(_i);
        };
      })(i));
  };
});