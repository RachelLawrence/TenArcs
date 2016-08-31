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

    // Update description
    $main.find('.config-description').text(Descriptions[i]);
    
    // Update auto groups
    $main.find('.config-automorphism-group-cardinality').text(AutomorphismGroups[i]);
    
    // Update small realizability
    $main.find('.config-small-realizability-3').text(SmallRealizability[i][0]);
    $main.find('.config-small-realizability-4').text(SmallRealizability[i][1]);
    $main.find('.config-small-realizability-5').text(SmallRealizability[i][2]);
    $main.find('.config-small-realizability-7').text(SmallRealizability[i][3]);
    $main.find('.config-small-realizability-8').text(SmallRealizability[i][4]);
    $main.find('.config-small-realizability-9').text(SmallRealizability[i][5]);
    $main.find('.config-small-realizability-11').text(SmallRealizability[i][6]);
    $main.find('.config-small-realizability-13').text(SmallRealizability[i][7]);
    $main.find('.config-small-realizability-16').text(SmallRealizability[i][8]);
    $main.find('.config-small-realizability-17').text(SmallRealizability[i][9]);
    $main.find('.config-small-realizability-19').text(SmallRealizability[i][10]);

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
    var item = i + 1;
    if (Names[i].charAt(0) == '*') {
      item = '<b>' + item + '</b>';
    }
    item = '<a>' + item + '</a>';
    $(item)
      .appendTo($sidebar)
      .click((function(_i) {
        return function(e) {
          render(_i);
        };
      })(i));
  };
});
