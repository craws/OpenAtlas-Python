
var svg = d3.select('svg').attr('width', width).attr('height', height);
var nodes_data = graph['nodes'];
var links_data = graph['links'];
var simulation = d3.forceSimulation().nodes(nodes_data); // Set up the simulation

// Add forces, we're going to add a charge to each node, also going to add a centering force
simulation
    .force('charge', d3.forceManyBody().strength(charge))  // Positive for together, negative apart
    .force('center', d3.forceCenter(width/2, height/2))  // No idea what this does exactly
    .force('x', d3.forceX().x(0))  // Needed to keep nodes together
    .force('y', d3.forceY().y(0))  // Needed to keep nodes together
    .force('links', d3.forceLink(graph['links']).id(function(d) {return d.id;}).distance(distance))  // distance is forcing nodes apart
    .on('tick', tickActions);  // Add tick actions

var g = svg.append('g').attr('class', 'everything'); // Add encompassing group for the zoom

var link = g.append('g')
    .attr('class', 'links')
    .selectAll('line')
    .data(links_data)
    .enter().append('line');

var node = g.append('g')
    .attr('class', 'nodes')
    .selectAll('g')
    .data(graph.nodes)
    .enter().append('g')

var circles = node.append('circle')
    .attr('r', 12)
    .attr('fill', function(d) { return d.color; });

var labels = node.append('text')
    .text(function(d) { return d.name; })
    .attr('x', 0)
    .attr('y', 20)
    .attr("text-anchor", "middle")
    .attr("dy", ".35em");

// Maybe use title (shows at mouseover label) if names are too long
// node.append('title').text(function(d) { return 'd.name'; });

// Add drag capabilities
var drag_handler = d3.drag()
    .on('start', drag_start)
    .on('drag', drag_drag)
    .on('end', drag_end);

drag_handler(node);

var zoom_handler = d3.zoom().on('zoom', zoomActions); // Add zoom capabilities
zoom_handler(svg);

/** Functions **/

function drag_start(d) {
    if (!d3.event.active) simulation.alphaTarget(0.3).restart();
    d.fx = d.x;
    d.fy = d.y;
}

// Make sure you can't drag the circle outside the box
function drag_drag(d) {
    d.fx = d3.event.x;
    d.fy = d3.event.y;
}

function drag_end(d) {
    if (!d3.event.active) simulation.alphaTarget(0);
    d.fx = null;
    d.fy = null;
}

function zoomActions(){
    g.attr('transform', d3.event.transform)
}

function tickActions() {
    link
        .attr('x1', function(d) { return d.source.x; })
        .attr('y1', function(d) { return d.source.y; })
        .attr('x2', function(d) { return d.target.x; })
        .attr('y2', function(d) { return d.target.y; });

    node.attr('transform', function(d) {
        return 'translate(' + d.x + ',' + d.y + ')';
    })
}
