/* GLOBAL */

// Constant settings
const DATA_FILE = "./data/dfperim.csv"
const TO_ROTATE = ["anisotropyGrayscale", "anisotropyMooney"]; // x-axis tick labels will be rotated
const REGRESSION_OPTS = ["none", "linear", "quadratic", "exponential", "logarithmic", "power"];
const MARGIN = {top: 20, right: 30, bottom: 60, left: 60}, // dimensions and margins of the graph
    width = 414 - MARGIN.left - MARGIN.right,
    height = 360 - MARGIN.top - MARGIN.bottom;

// Declare
var data;
var variables;
var svg;
var svgXaxis;
var svgYaxis;
var titleXaxis;
var titleYaxis;
var tooltip;
var regressionTooltip;

// Initialize (will be updated based on user input)
var xVar = "curiosity";
var yVar = "aha";
var regressionOpt = "none";

// To keep track of which state we're in
var state = {
    fixedTooltip: false, // whether tooltip is fixed (i.e., doesn't disappear on mouseout)
    showTooltip: false // whether tooltip should be visible
}

// Set up the scales
var xScale = d3.scaleLinear()
    .range([0, width])
    .nice();

var yScale = d3.scaleLinear()
    .range([height, 0])
    .nice()

var xScaleZoomed; // alternative scale to be used when user is zooming or panning
var yScaleZoomed; // alternative scale to be used when user is zooming or panning

// Set up the axes
var xAxis = d3.axisBottom()
    .scale(xScale)
    .tickSizeOuter(1)

var yAxis = d3.axisLeft()
    .scale(yScale)
    .tickSizeOuter(1);

// Set up regression
var regression = d3.regressionLinear()
    .x(d => d[xVar])
    .y(d => d[yVar])

// Pan and zoom
var zoom = d3.zoom()
    .scaleExtent([1, 20])
    .extent([[MARGIN.left, 0], [width - MARGIN.right, height]])
    .translateExtent([[MARGIN.left, 0], [width - MARGIN.right + 40, height]])
    .on("zoom", zoomed);

/*HELPER FUNCTIONS*/
function baseName(str) {
    var base = new String(str).substring(str.lastIndexOf('/') + 1);
    if (base.lastIndexOf(".") != -1)
        base = base.substring(0, base.lastIndexOf("."));
    return base;
}

function getNumericVars(variables){
    var numericVars = new Array();
    var max;
    var numeric;
    for (var i = 0; i < variables.length; i++){
        numeric = data.some(function(d){return !(isNaN(d[variables[i]] || d[variables[i]] == ""))})
        if (numeric){
            numericVars.push(variables[i])
        }
    }
    return numericVars
}

/* SETTING UP PAGE */
function makeDropDown(id, options, initText, f) {
    console.log("making dropdown", id)

    // Find the right dropdown based on id
    var dropdown = document.getElementById(id);
    var list = dropdown.getElementsByClassName("dropdown-menu scrollable-menu")[0]

    // Set text
    dropdown.getElementsByClassName("btn")[0].innerHTML = initText;

    // Fill dropdown list with options
    for (i = 0; i < options.length; i++) {
        var item = document.createElement("a")
        item.href = "#";
        item.classList = "dropdown-item";
        item.innerHTML = options[i];
        item.onclick = (function () {
            var index = i;
            return function () {
                // Update text to reflect chosen option
                dropdown.getElementsByClassName("btn")[0].innerHTML = options[index];

                // Call f and pass chosen option
                f(options[index]);
            }
        })();
        list.appendChild(item);
    }
}

/* IMAGE TOOLTIP FUNCTIONALITY*/
function tipMouseover (d) {
    if (!state.fixedTooltip) {
        // Initialize
        var tt_path;
        var tt_path_quoted;
        var gs_path;
        var gs_path_quoted;
        var html;
        var x_value;
        var y_value;
        var tt_image = new Image()
        var gs_image = new Image()
        var pageX  = d3.event.pageX;
        var pageY = d3.event.pageY;
        
        // Update state.showTooltip
        state.showTooltip = true; 

        // Format image paths
        tt_path = d.currentStim;
        tt_path_quoted = '"' + tt_path + '"';

        gs_path = baseName(d.currentStim);
        gs_path = gs_path.substring(0, gs_path.length - 2);
        gs_path = "../img/gs/" + gs_path + "gs.jpg";
        gs_path_quoted = '"' + gs_path + '"';

        // Format data to show in tooltip
        x_value = Number.parseFloat(d[xVar])
        x_value = x_value >= 100 ? x_value : x_value.toPrecision(2)

        y_value = Number.parseFloat(d[yVar])
        y_value = y_value >=100 ? y_value : y_value.toPrecision(2)

        // Construct the content of the tooltip
        html =
        "<div class='tooltip_icons'> <i id = 'tooltip_close' class='fa fa-times' onclick='closeTooltip()'></i></div>" +
        "<div class='image_container' onclick='openImage(" + tt_path_quoted + ")'>" +
            "<img src=" + tt_path_quoted + "class='tooltip_img'/>" +
        "</div>" +
        "<div class='image_container' onclick='openImage(" + gs_path_quoted + ")'>" +
            "<img src=" + gs_path_quoted + "class='tooltip_img' onclick='openImage(this.src)'/>" +
        "<div class='solution_mask' onmouseover='fade(this)' onmouseleave='unfade(this)'>"+
            "<p>Hover to reveal solution</p></div>" +
        "</div>" +
        "<div class='tooltip_text'>" + "(" +  x_value + "," + y_value + ")" + "</div>";

        // Update the content of the tooltip
        tooltip.html(html);

        // Add closing functionality
        d3.select("#tooltip_close").on("click", closeTooltip);

        // Update size and style of hovered data point
        d3.select(this).attr("r", 5).classed("selected", true);

        // Function to call once tt_image is loaded
        tt_image.onload = function() {
            // Load gs_image
            gs_image.src = gs_path;
        }

        // Function to call once gs_image is loaded
        gs_image.onload = function(){
            // To handle a scenario in which tipMouseout is triggered before images have been loaded
            if (!state.showTooltip){
                // Don't show tooltip if state has changed in the meantime
                return
            }
            // Position and display tooltip
            if (pageY > (window.innerHeight/2)){
                tooltip.style("left", (pageX + 10) + "px")
                    .style("top", (pageY - parseFloat(tooltip.style("height"))-10) + "px")
                    .transition()
                    .duration(200) // ms
                    .style("opacity", .9) // started as 0!
                    .style("pointer-events", "auto");
            }else{
                tooltip.style("left", (pageX + 10) + "px")
                    .style("top", (pageY + 10) + "px")
                    .transition()
                    .duration(200) // ms
                    .style("opacity", .9) // started as 0!
                    .style("pointer-events", "auto");
            }
        }

        // Load tt image
        tt_image.src = tt_path;
    }
};

function fade(element) {
    // Gradually reduce opacity
    d3.select(element).transition().duration(1000).style("opacity", 0);
}

function unfade(element) {
    // Reset opacity
    d3.select(element).interrupt().style("opacity", 1);
}

function openImage(url) {
    window.open(url);
}

function tipMouseout (d) {
    if (!state.fixedTooltip) {
        closeTooltip();
    }
};

function closeTooltip() {
    state.fixedTooltip = false;
    state.showTooltip = false;
    d3.selectAll("circle").attr("r", 2).classed("selected", false);
    tooltip.transition()
        .duration(300) // ms
        .style("opacity", 0) // don't care about position!
        .style("pointer-events", "none");
}

/*ZOOMING & PANNING FUNCTIONALITY*/
function zoomed() {
    // Create new scale objects based on event
    xScaleZoomed = d3.event.transform.rescaleX(xScale);
    yScaleZoomed = d3.event.transform.rescaleY(yScale);

    // Update tick format
    if (TO_ROTATE.indexOf(xVar) >= 0) {
        xAxis.ticks(10, "s");
        xScaleZoomed.domain([0, d3.max(data, function (d) {
            return parseFloat(d[xVar]);
        })])
        svgXaxis.call(xAxis.scale(xScaleZoomed)).selectAll(".tick text").attr("transform", function (d) {
            return "rotate(-65)"
        }).style("text-anchor", "end")

    } else {
        xAxis.ticks(10);
        xScale.domain([0, d3.max(data, function (d) {
            return parseFloat(d[xVar]);
        })])
        svgXaxis.call(xAxis.scale(xScaleZoomed)).call(xAxis.scale(xScaleZoomed)).selectAll(".tick text").attr("transform", function (d) {
            return "rotate(0)"
        }).style("text-anchor", "center")
    }

    if (TO_ROTATE.indexOf(yVar) >= 0) {
        yAxis.ticks(10, "s");
    } else {
        yAxis.ticks(10);
    }

    // Update axes
    svgYaxis.call(yAxis.scale(yScaleZoomed));
    svg.selectAll("circle").data(data)
        .attr('cx', function (d) {
            return xScaleZoomed(d[xVar])
        })
        .attr('cy', function (d) {
            return yScaleZoomed(d[yVar])
        });

    // Update regression line
    d3.selectAll(".regression-line")
        .attr("d", d3.line()
            .x(function (d) {
                return xScaleZoomed(d.x)
            })
            .y(function (d) {
                return yScaleZoomed(d.y)
            })
        )
}

/*REGRESSION FUNCTIONALITY*/
function updateRegression(selection) {
    // Update regressionOpt
    regressionOpt = selection;

    // Set correct regression
    switch (regressionOpt) {
        case "linear":
            regression = d3.regressionLinear()
                .x(d => d[xVar])
                .y(d => d[yVar]);
            break;
        case "quadratic":
            regression = d3.regressionQuad()
                .x(d => d[xVar])
                .y(d => d[yVar]);
            break;
        case "exponential":
            regression = d3.regressionExp()
                .x(d => d[xVar])
                .y(d => d[yVar]);
            break;
        case "logarithmic":
            regression = d3.regressionLog()
                .x(d => d[xVar])
                .y(d => d[yVar]);
            break;
        case "power":
            regression = d3.regressionPow()
                .x(d => d[xVar])
                .y(d => d[yVar]);
            break;
        case "none":
            svg.selectAll(".regression-line").remove();
            return
    }

    // Set scales for regression line
    var line = d3.line()
        .x(function (d) {
            return xScaleZoomed(d.x);
        })
        .y(function (d) {
            return yScaleZoomed(d.y);
        })

    // Fit regression to data (exclude missing data)
    var completeData = data.filter(function (d) {
        return !(d[xVar] == "" || d[yVar] == "" || isNaN(d[xVar] || isNaN(d[yVar])))
    });
    var regression_results = regression(completeData);
    var regressionLine = svg.selectAll(".regression-line");

    // Update the line
    regressionLine
        .data([convertLinePoints(regression_results)], function (d) {
            return d.x
        })
        .enter()
        .append("path")
        .attr("class", "regression-line")
        .merge(regressionLine)
        .transition()
        .duration(1000)
        .attrTween('d', function (d) {
            var previous = d3.select(this).attr('d');
            var current = line(d);
            return d3.interpolatePath(previous, current);
        })
        .attr("clip-path", "url(#plotting-area)")

    // Add hover functionality
    svg.selectAll(".regression-line")
        .on("mouseover", showRsquared(regression_results.rSquared))
        .on("mouseout", hideRsquared)
}

function convertLinePoints(points) {
    // Get results of regression in a format that we can use to plot the line
    var converted = new Array()
    for (var i = 0; i < points.length; i++) {
        converted[i] = {"x": points[i][0], "y": points[i][1]};
    }
    return converted
}

/*REGRESSION TOOLTIP FUNCTIONALITY*/
function showRsquared(value) {
    console.log(value)
    function fillTooltip(d) {
        if (!state.fixedTooltip) {
            console.log(d3.event.pageX, d3.event.pageY)
            var html = "R&sup2 = " + Number.parseFloat(value.toPrecision(2))
            regressionTooltip.html(html)
                .style("left", (d3.event.pageX+10) + "px")
                .style("top", (d3.event.pageY+10) + "px")
                .transition()
                .duration(200) // ms
                .style("opacity", .9)
                .style("pointer-events", "auto");
        }
    }
    return fillTooltip;
}

function hideRsquared() {
    regressionTooltip.transition()
        .duration(300) // ms
        .style("opacity", 0) // don't care about position!
        .style("pointer-events", "none");
}

/*DYNAMIC VARIABLES*/
function updateX(selection) {
    // Update xVar
    xVar = selection;

    // Update axis title
    titleXaxis.text(xVar)

    // Reset zoom scale
    xScaleZoomed = d3.scaleLinear()
    .range([0, width])
    .nice();

    // Update domains
    var max = d3.max(data, function(d){return parseFloat(d[xVar])});
    var min = d3.min(data, function(d){return parseFloat(d[xVar])});

    xAxis.scale(xScale)
    if (min >= 0) {
        xScale.domain([0, max])
        xScaleZoomed.domain([0, max])
    }else{
        if (max <=0){
            xScale.domain([min, 0])
            xScaleZoomed.domain([min, 0])
        }
        else{
            xScale.domain([min, max])
            xScaleZoomed.domain([min, max])
        }
    }
    // Update axes
    if (TO_ROTATE.indexOf(xVar) >= 0) {
        xAxis.ticks(10, "s");
        svgXaxis.transition().duration(1000).call(xAxis).selectAll(".tick text").attr("transform", function (d) {
            return "rotate(-65)"
        }).style("text-anchor", "end")
    } else {
        xAxis.ticks(10);
        svgXaxis.transition().duration(1000).call(xAxis).selectAll(".tick text").attr("transform", function (d) {
            return "rotate(0)"
        }).style("text-anchor", "center")
    }

    // Update circles (After William Liu's example: http://bl.ocks.org/WilliamQLiu/bd12f73d0b79d70bfbae)
    svg.selectAll("circle")
        .transition()  // Transition from old to new
        .duration(1000)  // Length of animation
        .on("start", function () {  // Start animation
            d3.select(this)  // 'this' means the current element
                .attr("r", 5);  // Change size
        })
        .delay(function (d, i) {
            return i / data.length * 500;  // Dynamic delay (i.e. each item delays a little longer)
        })
        //.ease("linear")  // Transition easing - default 'variable' (i.e. has acceleration), also: 'circle', 'elastic', 'bounce', 'linear'
        .attr("cx", function (d) {
            return xScale(d[xVar]);  // Circle's X
        })
        .on("end", function () {  // End animation
            d3.select(this)  // 'this' means the current element
                .transition()
                .duration(500)
                .attr("r", 2);  // Change radius
        });

    // Update regression
    updateRegression(regressionOpt);
}

function updateY(selection) {
    // Update yVar
    yVar = selection;

    // Update axis title
    titleYaxis.text(yVar)

    // Reset zoom scale
    yScaleZoomed = d3.scaleLinear()
    .range([height, 0])
    .nice();

    // Update domains
    var max = d3.max(data, function(d){return parseFloat(d[yVar])});
    var min = d3.min(data, function(d){return parseFloat(d[yVar])});

    yAxis.scale(yScale)
    if (min >= 0) {
        yScale.domain([0, max])
        yScaleZoomed.domain([0, max])

    }else{
        if (max <=0){
            yScale.domain([min, 0])
            yScaleZoomed.domain([min, 0])

        }
        else{
            yScale.domain([min, max])
            yScaleZoomed.domain([min, max])
        }
    }

    // Update axes
    if (TO_ROTATE.indexOf(yVar) >= 0) {
        yAxis.ticks(10, "s");
    } else {
        yAxis.ticks(10);
    }
    svgYaxis.transition().duration(1000).call(yAxis)

    // Update circles (After William Liu's example: http://bl.ocks.org/WilliamQLiu/bd12f73d0b79d70bfbae)
    svg.selectAll("circle")
        .transition()  // Transition from old to new
        .duration(1000)  // Length of animation
        .on("start", function () {  // Start animation
            d3.select(this)  // 'this' means the current element
                .attr("r", 5);  // Change size
        })
        .delay(function (d, i) {
            return i / data.length * 500;  // Dynamic delay (i.e. each item delays a little longer)
        })
        //.ease("linear")  // Transition easing - default 'variable' (i.e. has acceleration), also: 'circle', 'elastic', 'bounce', 'linear'
        .attr("cy", function (d) {
            return yScale(d[yVar]);  // Circle's X
        })
        .on("end", function () {  // End animation
            d3.select(this)  // 'this' means the current element
                .transition()
                .duration(500)
                .attr("r", 2);  // Change radius
        });

    // Update regression
    updateRegression(regressionOpt);
}

/*MAIN*/
$(document).ready(function () {

    // Set widths of other page elements equal to graph width
    $(".span-graph-width").width(width + MARGIN.left + MARGIN.right)

    // Make regression menu
    makeDropDown("regression-menu", REGRESSION_OPTS, regressionOpt, updateRegression);

    // Append tooltips
    tooltip = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

    regressionTooltip = d3.select("body").append("div")
        .attr("class", "regression-tooltip")
        .style("opacity", 0);

    // Append the svg to the body of the page and set the width and height
    // Append a 'g' element to group the circles together and 'translate'
    svg = d3.select("#data-viz").append("svg")
        .attr("width", width + MARGIN.left + MARGIN.right)
        .attr("height", height + MARGIN.top + MARGIN.bottom)
        .append("g")
        .attr("transform", "translate(" + MARGIN.left + "," + MARGIN.top + ")");

    // Draw the X axis
    svgXaxis = svg.append('g')
        .attr('class', 'axis label')
        .attr('transform', 'translate(0,' + height + ')')
        .call(xAxis);

    titleXaxis = svgXaxis.append('text')
        .attr('class', 'label')
        .attr('id', 'x axis title')
        .attr('x', width / 2)
        .attr('y', MARGIN.bottom - 10)
        .attr('fill', 'black')
        .attr('text-anchor', 'middle')
        .text(xVar);

    // Draw the Y axis
    svgYaxis = svg.append('g')
        .attr('class', 'axis label')
        .call(yAxis);

    titleYaxis = svgYaxis.append('text')
        .attr('class', 'label')
        .attr('id', 'y axis title')
        .attr('transform', 'translate(-290,320)rotate(-90)')
        .attr('x', 320 - height / 2)
        .attr('y', 290 - MARGIN.left + 10)
        .attr('fill', 'black')
        .attr('text-anchor', 'middle')
        .text(yVar);

    // Append a clipPath to prevent data being plotted outside the intended region
    svg.append("clipPath")
        .attr("id", "plotting-area")
        .append("rect")
        .attr("x", 0)
        .attr("y", -6)
        .attr("width", width + 6)
        .attr("height", height + 6)

    // Append a rectangle that will respond to zooming and panning
    svg.append("rect")
        .attr("width", width)
        .attr("height", height)
        .style("fill", "none")
        .style("pointer-events", "all")
        .call(zoom);

    //Read the data
    d3.csv(DATA_FILE, function (result) {
        data = result;
        variables = getNumericVars(data.columns.slice(1));
        variables.sort(function (a,b){
            // Case insensitive sort
            // https://stackoverflow.com/questions/8996963/how-to-perform-case-insensitive-sorting-in-javascript
            // Ivan Krechetov's solution
            return a.toLowerCase().localeCompare(b.toLowerCase());
        }); 
        makeDropDown("x-menu", variables, xVar, updateX);
        makeDropDown("y-menu", variables, yVar, updateY);

        // Adjust scales to data range
        updateX(xVar);
        updateY(yVar);

        // Add dots
        svg.append('g')
            .selectAll("circle")
            .data(data)
            .enter()
            .append("circle")
            .attr("cx", function (d) {
                return xScale(d[xVar]);
            })
            .attr("cy", function (d) {
                return yScale(d[yVar]);
            })
            .attr("r", 2)
            .attr("clip-path", "url(#plotting-area)")
            //.style("fill", "#158daf")
            .on("mouseover", tipMouseover)
            .on("mouseout", tipMouseout)
            .on("click", function () {
                state.fixedTooltip = true;
            });
    });
});



