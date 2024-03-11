const trace_opts = {
    name: "Language",
    type: "bar",
    marker: {
        color: 'rgba(5,5,30,0.7)',
        line: {color: 'rgba(5,5,30,1.0)', width: 1}
    }
}
const layout_opts = {
    font: {size: 16, family: `"Menlo", "Monaco", "Lucida Console", "Liberation Mono", "DejaVu Sans Mono", "Bitstream Vera Sans Mono", "Courier New", serif`},
}
var data_all = {};

function get_traces(data_raw, group_key, x_key, y_key) {
    data = {};
    var groups = [...new Set(data_raw[group_key])];
    groups.forEach(group => {
        indices = data_raw[group_key].map(
            (el, index) => (el === group) ? index : NaN
        ).filter(
            el => !isNaN(el)
        )
        data[group] = [{
            x: indices.map(i => data_raw[x_key][i]),
            y: indices.map(i => data_raw[y_key][i]),
            ...trace_opts
        }]
    });
    return {groups: groups, data: data}
}

// lang stats
fetch("/q1_top_langs.json")
    .then(res => res.json())
    .then(function (data_raw) {
        data = [{
            x: data_raw["lang"],
            y: data_raw["perc_sites"],
            ...trace_opts
        }]
        var layout = {
            ...layout_opts,
            title: {text: 'Top languages', font: {size: 16}},
            xaxis: {title: 'Language', titlefont: {size: 16}},
            yaxis: {title: '% of websites', titlefont: {size: 16}},
        }
        Plotly.newPlot("top-langs", data, layout);
    })
    .catch(function(err) {
        console.error(err)
    });

// tld-lang stats
fetch("/q2_tld_top_langs.json")
    .then(res => res.json())
    .then(function (data_raw) {
        var plot_id = "tld-top-langs";
        var default_group = "com";
        var {groups, data} = get_traces(data_raw, "tld", "lang", "perc_of_tld");
        data_all[plot_id] = data;
        var plot = document.getElementById('tld-top-langs');
        var layout = {
            ...layout_opts,
            title: {text: 'Top languages for .com', font: {size: 16}},
            xaxis: {title: 'Language', titlefont: {size: 16}},
            yaxis: {title: '% of websites', titlefont: {size: 16}},
        };
        Plotly.newPlot(plot, data[default_group], layout);
        var dropdown = document.getElementById(`${plot_id}-select`);
        groups.forEach(group => {
            var opt = document.createElement('option')
            opt.value = group
            opt.innerText = group
            if (group === default_group) {opt.selected = "selected"}
            dropdown.appendChild(opt)
        })
        dropdown.onchange = function (event) {
            layout.title.text = `Top languages for .${event.target.value}`;
            Plotly.newPlot(plot_id, data_all[plot_id][event.target.value], layout);
        }
    })
    .catch(function(err) {
        console.error(err)
    });

// lang stats
fetch("/q4_secondary_lang_prevalence.json")
    .then(res => res.json())
    .then(function (data_raw) {
        data = [{
            x: data_raw["lang"],
            y: data_raw["avg_rank"],
            ...trace_opts
        }]
        var plot = document.getElementById('secondary-lang-prevalence');
        var layout = {
            ...layout_opts,
            title: {text: 'Avg ranking as a secondary language', font: {size: 16}},
            xaxis: {title: 'Secondary language', titlefont: {size: 16}},
            yaxis: {title: 'Avg ranking', titlefont: {size: 16}},
        }
        Plotly.newPlot(plot, data, layout);
    })
    .catch(function(err) {
        console.error(err)
    });

// secondary lang stats
fetch("/q3_secondary_langs.json")
    .then(res => res.json())
    .then(function (data_raw) {
        var plot_id = "secondary-langs";
        var default_group = "pol";
        var {groups, data} = get_traces(data_raw, "lang_main", "lang", "perc_sites");
        data_all[plot_id] = data;
        var layout = {
            ...layout_opts,
            title: {text: 'Secondary languages on pol sites', font: {size: 16}},
            xaxis: {title: 'Language', titlefont: {size: 16}},
            yaxis: {title: '% of websites', titlefont: {size: 16}},
        };
        Plotly.newPlot(plot_id, data[default_group], layout);
        var dropdown = document.getElementById(`${plot_id}-select`);
        groups.forEach(group => {
            var opt = document.createElement('option')
            opt.value = group
            opt.innerText = group
            if (group === default_group) {opt.selected = "selected"}
            dropdown.appendChild(opt)
        })
        dropdown.onchange = function (event) {
            layout.title.text = `Secondary languages on ${event.target.value} sites`;
            Plotly.newPlot(plot_id, data_all[plot_id][event.target.value], layout);
        }
    })
    .catch(function(err) {
        console.error(err)
    });

// secondary lang stats
fetch("/q5_secondary_lang_top_primaries.json")
    .then(res => res.json())
    .then(function (data_raw) {
        var plot_id = "secondary-lang-top-primaries";
        var default_group = "pol";
        var {groups, data} = get_traces(data_raw, "lang", "lang_main", "rank_as_secondary");
        data_all[plot_id] = data;
        var layout = {
            ...layout_opts,
            title: {text: 'Sites where pol is added as secondary language', font: {size: 16}},
            xaxis: {title: 'Primary language', titlefont: {size: 16}},
            yaxis: {title: 'Rank among secondary langs', titlefont: {size: 16}},
        };
        Plotly.newPlot(plot_id, data[default_group], layout);
        var dropdown = document.getElementById(`${plot_id}-select`);
        groups.forEach(group => {
            var opt = document.createElement('option')
            opt.value = group
            opt.innerText = group
            if (group === default_group) {opt.selected = "selected"}
            dropdown.appendChild(opt)
        })
        dropdown.onchange = function (event) {
            layout.title.text = `Sites where ${event.target.value} is added as secondary language`;
            Plotly.newPlot(plot_id, data_all[plot_id][event.target.value], layout);
        }
    })
    .catch(function(err) {
        console.error(err)
    });
