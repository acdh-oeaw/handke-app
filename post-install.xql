xquery version "3.0";
import module namespace config="http://www.digital-archiv.at/ns/handke-app/config" at "modules/config.xqm";

(: grant 'read' and 'execute' permissions on restxq endpoint module to editors and annotators :)
sm:chmod(xs:anyURI($config:app-root||"/modules/api.xqm"), "rwxrwxr-x")