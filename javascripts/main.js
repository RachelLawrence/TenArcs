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
    $main.find('.config-name').text("Configuration #" + (i + 1));

    // Update description
    $main.find('.config-description').text(configs[i][2]);
    
    // Update auto groups
    $main.find('.config-automorphism-group-cardinality').text(configs[i][3]);
    
    // Update small realizability
    $main.find('.config-small-realizability-3').text(configs[i][4][0]);
    $main.find('.config-small-realizability-4').text(configs[i][4][1]);
    $main.find('.config-small-realizability-5').text(configs[i][4][2]);
    $main.find('.config-small-realizability-7').text(configs[i][4][3]);
    $main.find('.config-small-realizability-8').text(configs[i][4][4]);
    $main.find('.config-small-realizability-9').text(configs[i][4][5]);
    $main.find('.config-small-realizability-11').text(configs[i][4][6]);
    $main.find('.config-small-realizability-13').text(configs[i][4][7]);
    $main.find('.config-small-realizability-16').text(configs[i][4][8]);
    $main.find('.config-small-realizability-17').text(configs[i][4][9]);
    $main.find('.config-small-realizability-19').text(configs[i][4][10]);

    // Clear table
    var $table = $main.find('table.points');
    $table.html('');

    // Compute columns
    var points = configs[i][1];
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
    
    var item = 'pill">' + (i+1) + '</a>';
    item = configs[i][7] + ' ' + item;
    item = configs[i][1].length + 'lines ' + item;
    if (configs[i][5] == 0) {
      item = 'dim-zero ' + item;
    } else if (configs[i][5] == 1) {
      item = 'dim-one ' + item;
    }
    else {
      item = 'dim-unclear ' + item;
    }
    if (configs[i][6] == '-') {
      item = 'realizable-unclear ' + item;
    }
    if (configs[i][6]) {
      item = 'realizable-yes ' + item;
    }
    if (configs[i][6] == false) {
      item = 'realizable-no ' + item;
    }
    if (configs[i][3] >= 16) {
      item = 'highly-symmetric ' + item;
    }
    item = '<a class="' + item;
    $(item)
      .appendTo($sidebar)
      .click((function(_i) {
        return function(e) {
          render(_i);
        };
      })(i));
  };
});

function showClassical() {
  $(".pill").hide();
  $(".classical").show(); 
}

function showDim( value ) {
  $(".pill").hide();
  if (value == 0) {
    $(".dim-zero").show();
  } else if (value == 1) {
    $(".dim-one").show();
  }
  else {
    $(".dim-unclear").show();
  } 
}

function showRealizable( value ) {
  $(".pill").hide();
  if (value == '?') {
    $(".realizable-unclear").show();
  } else if (value) {
    $(".realizable-yes").show();
  }
  else {
    $(".realizable-no").show();
  } 
}

function showNPoints (value) {
  $(".pill").hide();
  if (value == 7) {
    $(".7point").show();
  }
  if (value == 8) {
    $(".8point").show();
  }
  if (value == 9) {
    $(".9point").show();
  }
  if (value == 10) {
    $(".pill").show();
    $(".7point").hide();
    $(".8point").hide();
    $(".9point").hide();
  }
}

function showNLines (value) {
  $(".pill").hide();
  $("." + value + "lines").show();
}

function showSelfDual () {
  $(".pill").hide();
  $(".selfdual").show();
}

function showHighlySymmetric() {
  $(".pill").hide();
  $(".highly-symmetric").show();
}

function showWord( word ) {
  $(".pill").hide();
  $("." + word).show();
}

function showAll() {
  $(".pill").show();
}
