xquery version "3.1";
import module namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/handke-app/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/handke-app/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $geojson := 
    <geojson>
        <type>FeatureCollection</type>{

for $event in collection($config:app-root||'/data/editions')//tei:event
    let $title := root($event)//tei:titleStmt/tei:title[@level='a']/text()[1]
    let $processedTitle := replace(xs:string(functx:substring-after-last($title, '(')), '\)', '')
    let $placeID := substring-after($event/@where, '#')
    let $place := doc($config:app-root||'/data/indices/listplace.xml')//tei:place[@xml:id=$placeID]
    let $coordinates := reverse(for $x in tokenize($place//tei:geo/text(), ',') return <coordinates>{number(functx:trim($x))}</coordinates>)
    let $lat := number(functx:trim(tokenize($place//tei:geo/text(), ',')[2]))
    let $lng := number(functx:trim(tokenize($place//tei:geo/text(), ',')[1]))
    let $type := data($event/@type)
    let $text := normalize-space(string-join($event//text(), ' '))
    let $start := if (exists(data($event/@notBefore))) 
        then data($event/@notBefore) 
        else if (exists(data($event/@from)))
        then data($event/@from)
        else "1980-01-01"
    let $end := if (exists(data($event/@notAfter))) 
        then data($event/@notAfter) 
        else if (exists(data($event/@to)))
        then data($event/@to)
        else "2017-01-01"
        where $coordinates/text()[1] != ""
        return
            <features>
                <type>Feature</type>
                <geometry>
                    <type>Point</type>
                    <coordinates>{$lat}</coordinates>
                    <coordinates>{$lng}</coordinates>
                </geometry>
                <properties>
                    <start>{$start}</start>
                    <end>{$end}</end>
                    <placename>{$place/tei:placeName/text()}</placename>
                    <eventtype>{$type}</eventtype>
                    <text>{$text}</text>
                    <link>{app:hrefToDoc($event)}</link>
                    <title>{$processedTitle}</title>
                </properties>
            </features>
        }
    </geojson>

return $geojson