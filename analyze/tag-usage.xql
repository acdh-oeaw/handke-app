xquery version "3.1";
import module namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/handke-app/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/handke-app/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $tag := request:get-parameter("tag", "del")
let $result := 
<result>{
    for $doc in collection($config:app-root||'/data/editions')//tei:TEI
    let $title := normalize-space(($doc//tei:title)[1])
    let $processedTitle := replace(xs:string(functx:substring-after-last($title, '(')), '\)', '')
    let $del := count($doc//*[name()=$tag])
    group by $doc
    order by $del
    return
        <payload>
            <item>{$processedTitle}</item>
            <item>{$del}</item>
        </payload>
}</result>
return 
    <data>
        <tagname>{$tag}</tagname>
        {$result}
    </data>