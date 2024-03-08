// tld-lang stats
fetch("/q1_tld_lang_all.json")
    .then(res => res.json())
    .then(function (data_raw) {
        console.log(data_raw)
        data = {};
        var distinct_tlds = [...new Set(data_raw["tld"])];
        distinct_tlds.forEach(tld => {
            indices = data_raw["tld"].map(
                (el, index) => (el === tld) ? index : NaN
            ).filter(
                el => !isNaN(el)
            )
            data[tld] = [{
                x: indices.map(i => data_raw["lang"][i]),
                y: indices.map(i => data_raw["total"][i]),
                name: "Language",
                type: "bar"
            }]
        });
        console.log(data)
        // TODO tld from dropdown, update plot on change
        var tld_plot = document.getElementById('tld-lang');
        var layout = {}
        Plotly.newPlot(tld_plot, data["com"], layout);
    })
    .catch(function(err) {
        console.error(err)
        console.error("Error for q1_tld_lang_all")
    });
