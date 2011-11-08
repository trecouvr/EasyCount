

package easycount.chart

type Chart.spec = {
    width : int
    height : int
    colors : list(string)
    datas : list(float)
    names : list(string)
    title : string
}

Chart = {{
    
    default = {
        width = 300
        height = 225
        colors = []
        datas = []
        names = []
        title = ""
    }
    
    xhtml(spec : Chart.spec) : xhtml =
        to_string(sep : string, l) : string =
            List.to_string_using("","",sep,List.map(v->"{v}",l))
        url = "http://chart.apis.google.com/chart"
	url = url^"?chxt=y"
	url = url^"&chbh=a"
	url = url^"&chs={spec.width}x{spec.height}"
	url = url^"&cht=bvg"
	url = url^"&chco={to_string(",",spec.colors)}"
	url = url^"&chd=t:{to_string("|",spec.datas)}"
	url = url^"&chds=a"
	url = url^"&chdl={to_string("|",spec.names)}"
	url = url^"&chdlp=b"
	url = url^"&chtt={spec.title}"
        do jlog(url)
        <img src={url} alt={spec.title} />
    



}}
